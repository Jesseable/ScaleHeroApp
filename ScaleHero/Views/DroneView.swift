//
//  DroneView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI
import SwiftySound

struct DroneView : View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    private let universalSize = UIScreen.main.bounds
    
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
                        MainUIButton(buttonText: "Note: \(musicNotes.noteName)", type: 1, height: buttonHeight)
                    }.padding(.top)
                    
                    Button {
                        if (!isPlaying) {
                            playScale.playDroneSound(duration: -1, startingNote: musicNotes.noteName)
                    
                        Sound.enabled = true
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
}
