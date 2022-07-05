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
    @State private var screenType : ScreenType
    @State private var backgroundImage : String
    private var fileReaderAndWriter = FileReaderAndWriter()
    
    private var selectedInstrument : String
    private var selectedBackground : String
    private var transposition : String
    private var transpositionMode : String
    private var metronomeOffBeatPulse: String
    private var selectedDrone : String
    private var introBeats : String
    private var introBeatsArr : [String]

    /**
    Initialises the  components of the app.
     */
    init() {
        screenType = .noteSelection
        
        //SCALE INSTRUMENT
        if fileReaderAndWriter.checkFilePath(for: "scaleinstrument") {
            selectedInstrument = fileReaderAndWriter.readScaleInstrument()
        } else {
            selectedInstrument = "Piano"
            fileReaderAndWriter.writeScaleInstrument(newInstrument: selectedInstrument)
        }
        
        //BACKGROUND
        if fileReaderAndWriter.checkFilePath(for: "background") {
            selectedBackground = fileReaderAndWriter.readBackgroundImage()
        } else {
            selectedBackground = "Purple"
            fileReaderAndWriter.writeBackgroundImage(newImage: selectedBackground)
        }
        backgroundImage = "Background" + selectedBackground
        
        //TRANSPOSITION
        if fileReaderAndWriter.checkFilePath(for: "transposition") {
            transposition = fileReaderAndWriter.readTransposition()
        } else {
            transposition = "C"
            fileReaderAndWriter.writeNewTransposition(newTransposition: transposition)
        }
        let transpositionArr = transposition.components(separatedBy: " ")
        if (transpositionArr.count > 1) {
            transpositionMode = "Instrument"
        } else {
            transpositionMode = "Notes"
        }
        
        //METRONOME
        if fileReaderAndWriter.checkFilePath(for: "metronome") {
            metronomeOffBeatPulse = fileReaderAndWriter.readMetronomePulse()
        } else {
            metronomeOffBeatPulse = "Off"
            fileReaderAndWriter.writeNewMetronomePulse(newPulse: metronomeOffBeatPulse)
        }
        
        //DRONE
        if fileReaderAndWriter.checkFilePath(for: "droneinstrument") {
            selectedDrone = fileReaderAndWriter.readDroneInstrument()
        } else {
            selectedDrone = "Cello"
            fileReaderAndWriter.writeDroneInstrument(newDrone: selectedDrone)
        }
        
        //INTRO BEATS
        if fileReaderAndWriter.checkFilePath(for: "intropulse") {
            introBeats = fileReaderAndWriter.readIntroBeats()
        } else {
            introBeats = "2-4"
            fileReaderAndWriter.writeIntroBeats(beats: introBeats)
        }
        introBeatsArr = introBeats.components(separatedBy: "-")
    }
    
    /**
     The main switch statement to toggle between views, transfering the  parameters as required.
     */
    var body: some View {
        let SelectedBackgroundImage = musicNotes.backgroundImage ?? self.backgroundImage
        
        return Group {
            
            switch screenType {
            case .scale:
                ScalesView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .arpeggio:
                ArpeggioView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .otherview:
                // Upon failing goes to special screen
                OtherScalesView(screenType: self.$screenType, displayType: musicNotes.otherSpecificScaleTypes ?? OtherScaleTypes.special, backgroundImage: SelectedBackgroundImage)
            case .settings:
                SettingsView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage, instrumentSelected: fileReaderAndWriter.readScaleInstrument(), backgroundColour: fileReaderAndWriter.readBackgroundImage(), transpositionMode: transpositionMode, transposition: transposition, metronomePulseSelected: metronomeOffBeatPulse, droneSelected: selectedDrone, slowIntroBeatsSelected: introBeatsArr[0], fastIntroBeatsSelected: introBeatsArr[1])
            case .soundview:
                SoundView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .droneview:
                DroneView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .favouritesview:
                FavouritesView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .aboutview:
                AboutView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            case .homepage:
                HomePage(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
            default:
                NoteSelectionView(screenType: self.$screenType, backgroundImage: SelectedBackgroundImage)
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
    @Binding var screenType: ScreenType
    @State private var offset: CGFloat = .zero
    var backgroundImage: String

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        
        let buttonHeight = universalSize.height/10
        let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
        
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
                    .padding(.top)
                
                TonicNoteDisplay(buttonHeight: buttonHeight)
                
                ScrollView {
                    
                    Button {
                        self.screenType = .scale
                    } label: {
                        MainUIButton(buttonText: "Scales", type: 1, height: buttonHeight)
                    }

                    Button {
                        self.screenType = .arpeggio
                    } label: {
                        MainUIButton(buttonText: "Arpeggio", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        self.screenType = .droneview
                    } label: {
                        MainUIButton(buttonText: "Drone", type: 2, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                    
                Button {
                    self.screenType = .noteSelection
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
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
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppContentView()
//    }
//}
