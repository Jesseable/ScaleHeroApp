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
                            let transposedNoteName = playScale.getTransposedNote(selectedNote: musicNotes.noteName)
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
}
