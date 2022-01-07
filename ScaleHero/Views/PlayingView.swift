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
                Text(title.replacingOccurrences(of: "-", with: " ")).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                
                Spacer()
                
                Text(musicNotes.currentNote)//.components(separatedBy: "-"))
                    .onReceive(musicNotes.timer) { time in

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
                        musicNotes.currentNote = musicNotes.scaleNotes[index].components(separatedBy: "-")[2]
                        
                        // play the next note
                        Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
            
                        self.index += 1
                }

                
                Text("Tempo: \(musicNotes.tempo)")
                
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
}
