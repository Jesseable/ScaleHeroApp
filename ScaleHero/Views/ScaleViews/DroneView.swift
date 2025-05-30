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
    var fileReaderAndWriter = FileReaderAndWriter()

    @Binding var screenType: ScreenType
    @State private var isPlaying = false
    @State var playScale = PlaySounds()
    
    var backgroundImage: String
    
    var body: some View {
        
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                Text("\(musicNotes.tonicNote.name) Drone").asTitle()
                
                let musicArray = MusicArray(note: musicNotes.tonicNote)

                TonicNoteDisplay(buttonHeight: buttonHeight, buttonWidth: width)
                
                Button {
                    if (!isPlaying) {
                        let transposedNote = musicArray.getTransposedStartingNote()
                        // Allows sound to play when ringer is on silent
                        do {
                            try AVAudioSession.sharedInstance().setCategory(.playback)
                        } catch(let error) {
                            print(error.localizedDescription)
                        }
                        playScale.playDroneSound(duration: -1, tonicNote: transposedNote)
                        
                        isPlaying = true
                    } else {
                        playScale.cancelAllSounds()
                        isPlaying = false
                    }
                } label: {
                    MainUIButton(buttonText: isPlaying ? "Stop SystemImage speaker.slash": "Play SystemImage speaker.wave.3", type: 1, height: buttonHeight, buttonWidth: width)
                }
                
                Spacer()
                
                Button {
                    musicNotes.backDisplay = .homepage
                    self.screenType = musicNotes.backDisplay
                } label: {
                    MainUIButton(buttonText: "Back", type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        }
    }
}
