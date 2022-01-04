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
    
    @State var isPlaying = false
    
    var body: some View {

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            let buttonHeight = universalSize.height/10
            
            VStack {
                Spacer()
                
                Text(String(index-1) + musicNotes.currentNote)
                    .onReceive(musicNotes.timer) { time in
                        print(musicNotes.scaleNotes)
                        // stop the previous sound
                        if (index != 0) {
                            Sound.stop(file: musicNotes.scaleNotes[index-1], fileExtension: "mp3")
                        } else {
                            Sound.stop(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                        }
                        if (index == musicNotes.scaleNotes.count - 1) {
                            musicNotes.timer.upstream.connect().cancel()
                            
                            // Add in a short delay before this is called  You will have to debug this thouroughly
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                        // play the next note
                        Sound.play(file: musicNotes.scaleNotes[index], fileExtension: "mp3")
                        
                        musicNotes.currentNote = musicNotes.scaleNotes[index]
                        self.index += 1
                }

                
                Text("Note Playing is: \(musicNotes.scaleNotes[0])")
                
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
