//
//  DroneView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI
import AVFoundation

/**
 Plays the drone notes alone for an inifnit amount of time until it says stop.
 */
struct DroneView : View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    private let universalSize = UIScreen.main.bounds
    var fileReaderAndWriter = FileReaderAndWriter()
    
    @Binding var screenType: ScreenType
    @State private var isPlaying = false
    @State var playScale = PlaySounds()
    
    var backgroundImage: String
    
    var body: some View {
        let title = musicNotes.noteName + " Drone"
        let buttonHeight = universalSize.height/10

        VStack {
            
            Text(title).asTitle()
            
                
            TonicNoteDisplay(buttonHeight: buttonHeight)
            
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
            
            Spacer()
            
            Button {
                musicNotes.backDisplay = .homepage
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
}
