//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
import SwiftySound
import AVFoundation

struct PlayingView: View {
    @EnvironmentObject var musicNotes: MusicNotes
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var backgroundImage : String
    let scaleType : String
    let playScaleNotes : Bool
    let playDrone : Bool
    @State var playSounds : PlaySounds
    let title: String
    @State var currentNote: String
    @State var index = 0
    @State var isPlaying = false
    @State var firstTime = true
    @State var delay : CGFloat?
    let universalSize = UIScreen.main.bounds
    @State var firstNoteDisplay = true
    
    var body: some View {
        let buttonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            VStack {
                Text(musicNotes.getMusicTitile(from: title))
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Image(getNote(from: currentNote, for: musicNotes.tonality)).resizable()
                
                Spacer()
                
                Button {
                    playSounds.cancelAllSounds()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Stop", type: 3, height: buttonHeight)
                }
            }
            .onAppear(perform: {
                
                // Allows sound to play when ringer is on silent
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
                if (playDrone) {
                    let extraDuration : Int
                    if musicNotes.tempo >= 80 {
                        extraDuration = 4
                    } else {
                        extraDuration = 1
                    }
                    
                    let duration = (tempoToSeconds(tempo: self.musicNotes.tempo)
                                    * CGFloat(self.musicNotes.scaleNotes.count + extraDuration))
                    
                    playSounds.playDroneSound(duration: duration,
                                              startingNote: currentNote)
                }
            })
            .onReceive(musicNotes.timer) { time in
                    
                if (musicNotes.scaleNoteNames[index].contains("Metronome")) {
                    let numBeats = self.musicNotes.getNumTempoBeats()
                    var countingImageArr = ["Two", "One"]
                    if (numBeats == 4) {
                        countingImageArr.insert("Three", at: 0)
                        countingImageArr.insert("Four", at: 0)
                    }
                    currentNote = countingImageArr[self.index]
                } else {
                    currentNote = musicNotes.scaleNoteNames[self.index].components(separatedBy: "-")[2]
                }
                
                // Allows sound to play when ringer is on silent
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
                // plays the next note
                if (playScaleNotes) {
                    if !musicNotes.scaleNotes[index].contains("Metronome") {
                        Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                    } else {
                        if musicNotes.metronome {
                            do {
                                try playSounds.playMetronome()
                                if (musicNotes.tempo < 70) {
                                    playSounds.offBeatMetronome(fileName: "Metronome1",
                                                                rhythm: fileReaderAndWriter.readMetronomePulse(),
                                                                timeInterval: tempoToSeconds(tempo: self.musicNotes.tempo))
                                }
                            } catch {
                                print("File Error When reading metronome")
                            }
                        }
                    }
                }
                    
                // stop the previous sound
                if (index > 0) {
                    if (musicNotes.scaleNotes[index] != musicNotes.scaleNotes[index-1]) {
                        Sound.stop(file: musicNotes.scaleNotes[index-1], fileExtension: "mp3")
                    }
                }
                
                if (index == musicNotes.scaleNotes.count - 1) {
                    musicNotes.timer.upstream.connect().cancel()
                    
                    // Add in a short delay before this is called  You will have to debug this thouroughly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                self.index += 1
            }
        }
    }
    
    /**
     Returns the singular note from the arrays component. Determines whether to use flats or sharps for the scale.
     */
    private func getNote(from currentNote: String, for tonality: String) -> String {
        let index = self.musicNotes.getNumTempoBeats()
        let noteArr = currentNote.replacingOccurrences(of: "/", with: "|").components(separatedBy: "|")
        let startingNote = musicNotes.scaleNotes[index].components(separatedBy: "-")[2].uppercased()
        
        if (noteArr.count == 1) {
            return noteArr[0]
        } else {
            switch musicNotes.noteDisplay {
            case 1:
                return noteArr[0]
            case 2:
                switch tonality.lowercased() {
                case "minor", "aeolian":
                    let selection = ["D", "G", "C", "F", "A#|BB"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "major", "ionian":
                    let selection =  ["F", "A#|BB", "D#|EB", "G#|AB", "C#|DB"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "dorian":
                    let selection =  ["G", "C", "F", "A#|BB", "D#|EB"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "phrygian":
                    let selection =  ["A", "D", "G", "C", "F"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "lydian":
                    let selection =  ["A#|BB", "D#|EB", "G#|AB", "D#|EB", "F#|GB"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "mixolydian":
                    let selection =  ["C", "F", "A#|BB", "F#|GB", "B"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "locrian":
                    let selection =  ["E", "A", "D", "A#|BB", "E"]
                    return noteArr[sharpOrFlat(for: startingNote, on: selection)]
                case "tetrad", "others":
                    return noteArr[forTypesSharpOrFlat(for: startingNote)]
                default:
                    return noteArr[0]
                }
            case 3:
                return noteArr[1]
            default:
                return noteArr[0]
            }
        }
    }
    
    /**
     Chooses sharps or flats option. 0 sharps, 1 flats
     */
    private func sharpOrFlat(for note: String, on selection: [String]) -> Int {
        if (selection.contains(note)) {
            return 1
        }
        return 0
    }
    
    /**
     Chooses sharps or flats for ambiguous tonalities
     */
    private func forTypesSharpOrFlat(for note: String) -> Int {
        var selection : [String]
        switch musicNotes.type.lowercased() {
        case "major-pentatonic-scale", "major-seventh", "dominant-seventh":
            selection = ["F", "A#|BB", "D#|EB", "G#|AB", "C#|DB"]
            return sharpOrFlat(for: note, on: selection)
        case "minor-seventh", "diminished-seventh", "minor-pentatonic-scale", "blues-scale":
            selection = ["D", "G", "C", "F", "A#|BB"]
            return sharpOrFlat(for: note, on: selection)
        default:
            return 0
        }
    }
    
    /**
     Returns the number of seconds a note lasts for
     */
    private func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
