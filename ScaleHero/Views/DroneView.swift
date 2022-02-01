//
//  DroneView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI
import AVFoundation

struct DroneView : View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    private let universalSize = UIScreen.main.bounds
    var fileReaderAndWriter = FileReaderAndWriter()
    
    @Binding var screenType: String
    @State private var isPlaying = false
    @State var playScale = PlaySounds()
    
    var backgroundImage: String
    
    var body: some View {
        let title = musicNotes.noteName + " Drone"
        let buttonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text(title)
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                
                ScrollView {
                    
                    Menu {
                        ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                            Button("Note: \(note)", action: {musicNotes.noteName = note})
                        }
                    } label: {
                        MainUIButton(buttonText: "Note: \(musicNotes.noteName)", type: 9, height: buttonHeight)
                    }.padding(.top)
                    
                    Button {
                        if (!isPlaying) {
                            let transposedNoteName = getTransposedNote(selectedNote: musicNotes.noteName)
                            // Allows sound to play when ringer is on silent
                            do {
                                try AVAudioSession.sharedInstance().setCategory(.playback)
                            } catch(let error) {
                                print(error.localizedDescription)
                            }
                            playScale.playDroneSound(duration: -1, startingNote: transposedNoteName)

                        isPlaying = true
                        } else {
                            playScale.cancelAllSounds()
                            isPlaying = false
                        }
                    } label: {
                        MainUIButton(buttonText: isPlaying ? "Stop SystemImage speaker.slash": "Play SystemImage speaker.wave.3", type: 1, height: buttonHeight)
                    }
                }
                
                Spacer()
                
                Button {
                    self.screenType = "homescreen"
                } label: {
                    MainUIButton(buttonText: "Home Page", type: 3, height: buttonHeight)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
    }
    
    private func getTransposedNote(selectedNote: String) -> String {
        var transpositionNote = fileReaderAndWriter.readTransposition()
        if (transpositionNote.components(separatedBy: " ").count > 1) {
            transpositionNote = transpositionNote.components(separatedBy: " ")[1]
            transpositionNote = getFullNote(singularNote: transpositionNote)
        }
        switch transpositionNote {
        case "C":
            return findNote(transposedNote: "C", selectedNote: selectedNote)
        case "G":
            return findNote(transposedNote: "G", selectedNote: selectedNote)
        case "D":
            return findNote(transposedNote: "D", selectedNote: selectedNote)
        case "A":
            return findNote(transposedNote: "A", selectedNote: selectedNote)
        case "E":
            return findNote(transposedNote: "E", selectedNote: selectedNote)
        case "B":
            return findNote(transposedNote: "B", selectedNote: selectedNote)
        case "F#/Gb":
            return findNote(transposedNote: "F#/Gb", selectedNote: selectedNote)
        case "C#/Db":
            return findNote(transposedNote: "C#/Db", selectedNote: selectedNote)
        case "G#/Ab":
            return findNote(transposedNote: "G#/Ab", selectedNote: selectedNote)
        case "D#/Eb":
            return findNote(transposedNote: "D#/Eb", selectedNote: selectedNote)
        case "A#/Bb":
            return findNote(transposedNote: "A#/Bb", selectedNote: selectedNote)
        case "F":
            return findNote(transposedNote: "F", selectedNote: selectedNote)
        default:
            return "not Found"
        }
    }
    
    private func findNote(transposedNote: String, selectedNote: String) -> String {
        let orderedAlphabet = ["A","A#/Bb","B","C","C#/Db","D","D#/Eb","E","F","F#/Gb","G","G#/Ab","A","A#/Bb","B","C","C#/Db","D","D#/Eb","E","F","F#/Gb","G","G#/Ab"]
        // Twice as long too allow only going forwards
        let transposedIndex = orderedAlphabet.firstIndex(of: transposedNote) ?? 0
        let CIndex = orderedAlphabet.firstIndex(of: "C") ?? 0
        let selectedIndex = orderedAlphabet.firstIndex(of: selectedNote) ?? 0
        let difference = CIndex - transposedIndex
        let arrayIndex = selectedIndex - difference
        return orderedAlphabet[arrayIndex]
    }
    
    /// ALSO IN WRITE SCALES
    private func getFullNote(singularNote: String) -> String{
        switch singularNote {
        case "F#", "Gb":
            return "F#/Gb"
        case "C#", "Db":
            return "C#/Db"
        case "G#", "Ab":
            return "G#/Ab"
        case "D#", "Eb":
            return "D#/Eb"
        case "A#", "Bb":
            return "A#/Bb"
        default:
            return singularNote
        }
    }
}
