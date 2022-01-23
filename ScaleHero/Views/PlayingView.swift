//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
import SwiftySound

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
    private let universalSize = UIScreen.main.bounds
    
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
                if (playDrone) { /// SOMETIMES ENDING EARLY (HARMONIC MINOR 2 octaves C
                    let duration = (60.0/(self.musicNotes.tempo) * CGFloat(self.musicNotes.scaleNotes.count + 1)) // Change the plus to however many click in beats there are

                    playSounds.playDroneSound(duration: duration, startingNote: musicNotes.scaleNotes[0].components(separatedBy: "-")[2])
                }
            })
            .onReceive(musicNotes.timer) { time in /// ADD A CLICK IN OPTION HERE LATER
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
                
                currentNote = musicNotes.scaleNotes[index].components(separatedBy: "-")[2]
                
                // plays the next note
                if (playScaleNotes) {
                    Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                }
    
                self.index += 1
            }
        }
    }
    
    /**
     Returns the singular note from the arrays component. Determines whether to use flats or sharps for the scale.
     */
    private func getNote(from currentNote: String, for tonality: String) -> String {
        let noteArr = currentNote.replacingOccurrences(of: "/", with: "|").components(separatedBy: "|")
        let startingNote = musicNotes.scaleNotes[0].components(separatedBy: "-")[2].uppercased()
        
        if (noteArr.count == 1) {
            return noteArr[0]
        } else {
            if (tonality.lowercased() == "minor") {
                switch startingNote {
                case "D", "G", "C", "F", "A#|BB":
                    return noteArr[1]
                default:
                    return noteArr[0]
                }
            } else {
                switch startingNote {
                case "F", "A#|BB", "D#|EB", "G#|AB", "C#|DB":
                    return noteArr[1]
                default:
                    return noteArr[0]
                }
            }
        }
    }
}
