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
    @State private var backgroundImage : String // Can change to a variety of choices
    private var fileReaderAndWriter = FileReaderAndWriter()
    private let scaleInstruments = ["Cello", "Jesse's Vocals"]
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    private var selectedInstrument : String
    private var selectedBackground : String

    init() { // Test by changing Iphone type at one point!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        selectedInstrument = fileReaderAndWriter.readScaleInstrument()
        if (!scaleInstruments.contains(selectedInstrument)) {
            selectedInstrument = "Cello" // or default option when sound files are completed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            fileReaderAndWriter.writeScaleInstrument(newInstrument: selectedInstrument)
        }
        
        selectedBackground = fileReaderAndWriter.readBackgroundImage()
        if (!backgrounds.contains(selectedBackground)) {
            selectedBackground = "Blue"
            fileReaderAndWriter.writeBackgroundImage(newImage: selectedBackground)
        }
        backgroundImage = "Background" + selectedBackground
    }
    
    var body: some View {
        
        return Group {
            switch screenType {
            case "scale":
                ScalesView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "arpeggio":
                ArpeggioView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "specialview":
                SpecialView(screenType: self.$screenType, specialTitle: musicNotes.type, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "settings":
                SettingsView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage, instrumentSelected: fileReaderAndWriter.readScaleInstrument(), backgroundColour: fileReaderAndWriter.readBackgroundImage())
            case "soundview":
                let scaleType = musicNotes.noteName + " " + musicNotes.tonality + " " + musicNotes.type
                SoundView(screenType: self.$screenType, scaleType: scaleType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            default:
                HomePage(screenType: $screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            }
        }
    }
}

struct HomePage : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State private var offset: CGFloat = .zero
    var backgroundImage: String
    
    private let titleImage = Image("ScaleHero-Title")
    
    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
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

                self.titleImage.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height/6)
                    .padding()
                
                let buttonHeight = universalSize.height/10
                
                Button {
                    self.screenType = "scale"
                } label: {
                    MainUIButton(buttonText: "Scales", type: 1, height: buttonHeight)
                }

                Button {
                    self.screenType = "arpeggio"
                } label: {
                    MainUIButton(buttonText: "Arpeggio", type: 1, height: buttonHeight)
                }
                
                Button {
                    // do nothing
                } label: {
                    MainUIButton(buttonText: "Special", type: 1, height: buttonHeight)
                }
                
                Button {
                    // do nothing
                } label: {
                    MainUIButton(buttonText: "Favourites", type: 2, height: buttonHeight)
                }
                
                Spacer()
                
                Button {
                    self.screenType = "settings"
                } label: {
                    MainUIButton(buttonText: "Settings", type: 3, height: buttonHeight)
                }
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
