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
                    MainUIButton(buttonText: "Stop SystemImage speaker.slash", type: 3, height: buttonHeight)
                }
            }
            .onAppear(perform: {
                if (playDrone) {
                    let index = self.musicNotes.getNumTempoBeats()
                    let duration = (tempoToSeconds(tempo: self.musicNotes.tempo)
                                    * CGFloat(self.musicNotes.scaleNotes.count + index)) 
                    playSounds.playDroneSound(duration: duration,
                                              startingNote: musicNotes.scaleNotes[index]
                                                .components(separatedBy: "-")[2])
                }
            })
            .onReceive(musicNotes.timer) { time in
                
                if (playScaleNotes) {
                        
                    // stop the previous sound
                    if (index != 0) {
                        Sound.stop(file: musicNotes.scaleNotes[index-1], fileExtension: "mp3")
                    } else {
                        Sound.stop(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                    }
                    if (index == musicNotes.scaleNotes.count - 1) {
                        musicNotes.timer.upstream.connect().cancel()
                        
                        // Add in a short delay before this is called  You will have to debug this thouroughly
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                    
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
                
                // plays the next note
                if (playScaleNotes) {
                    if !musicNotes.scaleNotes[index].contains("Metronome") {
                        Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                    } else {
                        playSounds.playMetronome()
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
                default: /// STILL NEED TO SORT OUT TETRADS AND OTHERS
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
     Returns the number of seconds a note lasts for
     */
    private func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
