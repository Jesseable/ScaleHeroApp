//
//  AppContentView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 14/12/21.
//

import SwiftUI

struct AppContentView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    @State private var screenType = "HomePage"
    private var backgroundImage = "music-Copyrighted-exBackground"
    
    var body: some View {
        
        return Group {
            switch screenType {
            case "scales":
                ScalesView(screenType: self.$screenType, backgroundImage: backgroundImage)
            case "arpeggio":
                ArpeggioView(screenType: self.$screenType, backgroundImage: backgroundImage)
//            case "special":
//                print("Go to special page")
            case "settings":
                SettingsView(screenType: self.$screenType, backgroundImage: backgroundImage)
            case "soundview":
                SoundView(screenType: self.$screenType, scaleType: musicNotes.noteName + " " + musicNotes.tonality + " " + musicNotes.type, backgroundImage: backgroundImage)
            default:
                HomePage(screenType: $screenType, backgroundImage: backgroundImage)
            }
        }
    }
}

struct HomePage : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State private var offset: CGFloat = .zero
    var backgroundImage: String
    
    var body: some View {
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            // Create all music note animations
            ImageAnimation(imageName: "Treble-Cleff", xPos: universalSize.width * 0.3, duration: 7.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver", xPos: -universalSize.width * 0.3, duration: 5.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver", xPos: 0, duration: 10.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet", xPos: -universalSize.width * 0.4, duration: 6.25, offset: self.$offset)
            
            ImageAnimation(imageName: "Treble-Cleff", xPos: -universalSize.width * 0.1, duration: 4.60, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet", xPos: universalSize.width * 0.35, duration: 12.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver", xPos: universalSize.width * 0.07, duration: 5.48, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver", xPos: universalSize.width * 0.48, duration: 8.00, offset: self.$offset)
            
            VStack {
                
                Text("SCALE HERO").bold().font(.title).foregroundColor(.white).padding()
                Spacer()
                
                
                // Turn to image button
                Button("Scales") {
                    self.screenType = "scales"
                }.padding()
                
                // Turn to image button
                Button("Arpeggio") {
                    self.screenType = "arpeggio"
                }.padding()
                
                // Turn to image button
                Button("Special") {
                    // do nothing
                }.padding()
                
                Spacer()
                Spacer()
                
                Button("Settings") {
                    self.screenType = "settings"
                }.padding()

            }
        }.onAppear() {
            offset += universalSize.height*1.2
        }
    }
}

/**
 Creates the animated image for the screen.
 Starts above the display, falls vertically downwards until it is below the display.
 */
struct ImageAnimation: View {
    
    private let universalSize = UIScreen.main.bounds
    var imageName: String
    var xPos: CGFloat
    var duration: CGFloat
    @Binding var offset: CGFloat
    
    var body: some View {
        Image(imageName).resizable()
            .frame(width: universalSize.width * 0.1, height: universalSize.height * 0.1, alignment: .center)
            .padding(20)
            .shadow(color: Color.white, radius: 10.00)
            .offset(x: xPos, y: self.offset - universalSize.height/2*1.2)
            .animation(Animation.easeInOut(duration: duration).repeatForever(autoreverses: false), value: offset)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppContentView()
    }
}
