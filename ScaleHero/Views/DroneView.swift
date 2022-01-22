//
//  DroneView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI
import SwiftySound

struct DroneView : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State var droneNote: String
    @State private var isPlaying = false
    @State var playScale = PlaySounds()
    
    var backgroundImage: String
    
    var body: some View {
        let title = droneNote + " Drone"
        let buttonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text(title)
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                ScrollView {
                    
                    Button {
                        if (!isPlaying) {
                        playScale.playDroneSound(duration: -1, startingNote: droneNote)
                    
                        Sound.enabled = true
                        isPlaying = true
                        } else {
                            playScale.cancelDroneSound()
                            isPlaying = false
                        }
                    } label: {
                        MainUIButton(buttonText: isPlaying ? "Stop SystemImage speaker.slash": "Play SystemImage speaker.wave.3", type: 1, height: buttonHeight)
                    }
                }
                
                Spacer()
                
                Button {
                    self.screenType = "abstractview"
                } label: {
                    MainUIButton(buttonText: "Abstract Scales", type: 3, height: buttonHeight)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
    }
}
