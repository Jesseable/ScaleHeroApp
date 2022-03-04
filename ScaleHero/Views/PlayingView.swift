//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
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
    @State var repeatNotes : Bool
    private let universalSize = UIScreen.main.bounds
    @State var firstNoteDisplay = true
    @State var num = 0
    @State var repeatingEndlessly : Bool // Chnage to a variable
    
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
                    musicNotes.timer.upstream.connect().cancel()
                    presentationMode.wrappedValue.dismiss()
                    musicNotes.dismissable = false
                    UIApplication.shared.isIdleTimerDisabled = false
                } label: {
                    MainUIButton(buttonText: "Stop", type: 3, height: buttonHeight)
                }
            }
            .onAppear(perform: {
                // So the screen will never turn off when on this setting
                UIApplication.shared.isIdleTimerDisabled = true
                
                if (repeatNotes) {
                    musicNotes.scaleNotes = repeateAllNotes(in: musicNotes.scaleNotes)
                    musicNotes.scaleNoteNames = repeateAllNotes(in: musicNotes.scaleNoteNames)
                }
                
                // Allows sound to play when ringer is on silent
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
                if (playDrone) {
                    let extraDuration : Int
                    if musicNotes.tempo >= 80 {
                        extraDuration = 2
                    } else {
                        extraDuration = 1
                    }
                    
                    let duration = (tempoToSeconds(tempo: self.musicNotes.tempo)
                                    * CGFloat(self.musicNotes.scaleNotes.count + extraDuration))
                    
                    let transposedNoteName = playSounds.getTransposedNote(selectedNote: musicNotes.noteName)
                    
                    if !repeatingEndlessly {
                        playSounds.playDroneSound(duration: duration,
                                              startingNote: transposedNoteName)
                    } else {
                        playSounds.playDroneSound(duration: -1,
                                              startingNote: transposedNoteName)
                    }
                }
            })
            .onReceive(musicNotes.timer) { time in
                if (num % musicNotes.metronomePulse != 0 && musicNotes.metronome) {
                    do {
                        try playSounds.playOffbeatMetronome()
                    } catch {
                        print("File Error When reading off beat metronome")
                    }
                
                } else {
                    
                    // Metronome sound
                    if musicNotes.metronome {
                        do {
                            try playSounds.playMetronome()
                        } catch {
                            print("File Error When reading metronome")
                        }
                    }
                    
                    if (musicNotes.scaleNoteNames[index].contains("Metronome")) {
                        let countingArr = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
                        let numIntroBeats = numIntroBeats(tempo: Int(musicNotes.tempo), fileReader: fileReaderAndWriter)
                        var i = 0
                        var countingImageArr = [String]()
                        numIntroBeats.times {
                            countingImageArr.insert(countingArr[i], at: 0)
                            i += 1
                        }
//                        var countingImageArr = ["Two", "One"]
//                        if (numBeats == 4) {
//                            countingImageArr.insert("Three", at: 0)
//                            countingImageArr.insert("Four", at: 0)
//                        }
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
                            do {
                                let finalNote : Bool
                                if (index == musicNotes.scaleNotes.count - 1) {
                                    finalNote = true
                                } else {
                                    finalNote = false
                                }
                                try playSounds.playScaleNote(scaleFileName: musicNotes.scaleNotes[index], duration: tempoToSeconds(tempo: self.musicNotes.tempo), finalNote: finalNote)
                            } catch {
                                print("File Error When attempting to play scale Notes")
                            }
                        }
                    }
                    
                    if (index == musicNotes.scaleNotes.count - 1) {
                        if !self.repeatingEndlessly {
                            terminateScale()
                        } else {
                            self.index = -1 // Since it will have one added in a second
                        }
                    }
                    self.index += 1
                }
                num += 1
            }
        }
    }
    
    /**
     Repeats the scale
     */
    private func terminateScale() {
        musicNotes.timer.upstream.connect().cancel()
        
        // Add in a short delay before this is called  You will have to debug this thouroughly
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if musicNotes.dismissable {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    /**
     Returns the singular note from the arrays component. Determines whether to use flats or sharps for the scale.
     */
    private func getNote(from currentNote: String, for tonality: String) -> String {
        let index = numIntroBeats(tempo: Int(musicNotes.tempo), fileReader: fileReaderAndWriter)
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
     Returns the amount of introduction beats to be played
     */
    private func numIntroBeats(tempo: Int, fileReader: FileReaderAndWriter) -> Int {
        let tempoBeatsArr = fileReader.readIntroBeats().components(separatedBy: "-")
        if tempo < 70 {
            return Int(tempoBeatsArr[0])!
        } else {
            return Int(tempoBeatsArr[1])!
        }
    }
    
    /**
     Repeats every element in the array
     */
    private func repeateAllNotes(in soundFileArray: [String]) -> [String] {
        assert(soundFileArray.count > 0, "count must be greater than 0")
        
        var newSoundFIle = soundFileArray
        var index = 0
        
        for soundFile in newSoundFIle {
            if !newSoundFIle[index].contains("Metronome") {
                newSoundFIle.insert(soundFile, at: index)
                index += 2
            } else {
                index += 1
            }
        }

        return newSoundFIle
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
