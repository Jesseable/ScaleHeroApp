//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
import SwiftySound

struct PlayingView: View {
    private let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    @State var playSounds: PlaySounds
    let scaleType: String
    let playScaleNotes : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var scaleTimer: Timer? = nil
    @EnvironmentObject var musicNotes: MusicNotes
    @State var index = 0
    let title: String
    
    @State var isPlaying = false
    
    var body: some View {

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            let buttonHeight = universalSize.height/10
            
            VStack {
                Text(title.replacingOccurrences(of: "-", with: " ").uppercased().replacingOccurrences(of: "TETRAD ", with: "").replacingOccurrences(of: "SEVENTH", with: "7th")).bold().font(.title).foregroundColor(.white).scaledToFit()
                
                Spacer()
                Image(getNote(from: musicNotes.noteName, for: musicNotes.tonality)).resizable()
                Text("HiddenReciever")
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
                        
                        musicNotes.noteName = musicNotes.scaleNotes[index].components(separatedBy: "-")[2]
                        
                        if (playScaleNotes) {
                        // play the next note
                            Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                        }
            
                        self.index += 1
                    }.hidden()
//
//
//                Text("Tempo: \(musicNotes.tempo)")
                
                Spacer()
                
                Button {
                    Sound.enabled = false
                    playSounds.cancelAllSounds()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Stop SystemImage speaker.slash", type: 3, height: buttonHeight)
                }.padding( .top )
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func getNote(from currentNote: String, for tonality: String) -> String {
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
