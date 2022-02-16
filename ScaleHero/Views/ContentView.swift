//
//  AppContentView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 14/12/21.
//

import SwiftUI

/**
 The view controller struct.
 Controls all of the views and sets the background image and default
 asthetic choices based off of the file descriptions.
 */
struct AppContentView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    @State private var screenType = "HomePage"
    @State private var backgroundImage : String
    private var fileReaderAndWriter = FileReaderAndWriter()
    
    // Also saved under settings view
    private let scaleInstruments = ["Strings", "Piano", "Organ"]
    
    private let droneInstruments = ["Cello", "Tuning Fork"]
    
    // Also saved under settingsView
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    
    private let metronomePulses = ["Compound", "Simple", "Off"]
    
    private let transpositionTypes = ["C", "G", "D", "A", "E", "B", "F#/Gb", "C#/Db", "G#/Ab", "D#/Eb", "A#/Bb", "F", "Bassoon in C", "Clarinet in Bb", "Clarinet in Eb", "Euphonium in C", "Horn in F", "Oboe in C", "Recorder in C", "Recorder in F", "Flute in C", "Saxophone in Bb", "Saxophone in Eb", "Strings in C", "Trombone in C", "Trumpet in Bb", "Tuba in F"]
    
    private var selectedInstrument : String
    private var selectedBackground : String
    private var transposition : String
    private var transpositionMode : String
    private var metronomeOffBeatPulse: String
    private var selectedDrone : String

    /**
    Initialises the  components of the app.
     */
    init() {
        selectedInstrument = fileReaderAndWriter.readScaleInstrument()
        if (!scaleInstruments.contains(selectedInstrument)) {
            // the default selected instrument is chosen here:
            selectedInstrument = "Piano"
            fileReaderAndWriter.writeScaleInstrument(newInstrument: selectedInstrument)
        }
        
        selectedBackground = fileReaderAndWriter.readBackgroundImage()
        if (!backgrounds.contains(selectedBackground)) {
            // the default selected background colour is chosen here:
            selectedBackground = "Purple"
            fileReaderAndWriter.writeBackgroundImage(newImage: selectedBackground)
        }
        backgroundImage = "Background" + selectedBackground
        
        transposition = fileReaderAndWriter.readTransposition()
        if (!transpositionTypes.contains(transposition)) {
            // the default selected transposition note is chosen here:
            transposition = "C"
            fileReaderAndWriter.writeNewTransposition(newTransposition: transposition)
        }
        
        let transpositionArr = transposition.components(separatedBy: " ")
        if (transpositionArr.count > 1) {
            transpositionMode = "Instrument"
        } else {
            transpositionMode = "Notes"
        }
        
        metronomeOffBeatPulse = fileReaderAndWriter.readMetronomePulse()
        if (!metronomePulses.contains(metronomeOffBeatPulse)) {
            // the default selected metronome is chosen here:
            metronomeOffBeatPulse = "Off"
            fileReaderAndWriter.writeNewMetronomePulse(newPulse: metronomeOffBeatPulse)
        }
        
        selectedDrone = fileReaderAndWriter.readDroneInstrument()
        if (!droneInstruments.contains(selectedDrone)) {
            // the default selected instrument is chosen here:
            selectedDrone = "Cello"
            fileReaderAndWriter.writeDroneInstrument(newDrone: selectedDrone)
        }
    }
    
    /**
     Toggles between views, transfering the needed parameters.
     */
    var body: some View {
        
        return Group {
            switch screenType {
            case "scale":
                ScalesView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "arpeggio":
                ArpeggioView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "otherview":
                OtherScalesView(screenType: self.$screenType, specialTitle: musicNotes.type, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "settings":
                SettingsView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage, instrumentSelected: fileReaderAndWriter.readScaleInstrument(), backgroundColour: fileReaderAndWriter.readBackgroundImage(), transpositionMode: transpositionMode, transposition: transposition, metronomePulseSelected: metronomeOffBeatPulse, droneSelected: selectedDrone)
            case "soundview":
                let scaleType = musicNotes.noteName + " " + musicNotes.tonality + " " + musicNotes.type
                SoundView(screenType: self.$screenType, scaleType: scaleType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "droneview":
                DroneView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "favouritesview":
                FavouritesView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            case "aboutview":
                AboutView(screenType: self.$screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            default:
                HomePage(screenType: $screenType, backgroundImage: musicNotes.backgroundImage ?? self.backgroundImage)
            }
        }
    }
}

/**
 The Initial view for the app.
 Contains buttons for settings, favourites and different scale types.
 Also contains the falling note animations.
 */
struct HomePage : View {
    
    private let universalSize = UIScreen.main.bounds
    var fileReaderAndWriter = FileReaderAndWriter()
    @Binding var screenType: String
    @State private var offset: CGFloat = .zero
    var backgroundImage: String

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        
        let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            // Create all music note animations
            ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.3, duration: 7.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.3, duration: 5.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: 0, duration: 10.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.4, duration: 6.25, offset: self.$offset)
            
            ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.1, duration: 4.60, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.35, duration: 12.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.07, duration: 5.48, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.48, duration: 8.00, offset: self.$offset)
            
            VStack {

                titleImage.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height/6)
                    .padding()
                
                ScrollView {
                    
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
                        self.screenType = "droneview"
                    } label: {
                        MainUIButton(buttonText: "Drone", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        self.screenType = "favouritesview"
                    } label: {
                        MainUIButton(buttonText: "Favourites", type: 2, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                    
                Button {
                    self.screenType = "aboutview"
                } label: {
                    MainUIButton(buttonText: "About / Settings", type: 3, height: buttonHeight)
                }
            }
        }.onAppear() {
            offset += universalSize.height * 1.2
        }
    }
}

/**
 Creates the animated notes for the screen.
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
