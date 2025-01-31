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
    private var scaleAchievements : String
    private var initialHint : String

    /**
    Initialises the  components of the app.
     */
    init() {
        screenType = .noteSelection /// DO ALL OF THIS IN ONE TEXT FILE AND THEN HAVE ALL VALUES SAVED STRAIGHT INTO THE MUSICNOTES CLASS
        
        //SCALE INSTRUMENT
        if fileReaderAndWriter.checkFilePath(for: .scaleInst) {
            selectedInstrument = fileReaderAndWriter.readScaleInstrument()
        } else {
            selectedInstrument = "Piano"
            fileReaderAndWriter.writeScaleInstrument(newInstrument: selectedInstrument)
        }
        
        // BACKGROUND
        if fileReaderAndWriter.checkFilePath(for: .background) {
            selectedBackground = fileReaderAndWriter.readBackgroundImage()
        } else {
            selectedBackground = "Purple"
            fileReaderAndWriter.writeBackgroundImage(newImage: selectedBackground)
        }
        backgroundImage = "Background" + selectedBackground
        
        // TRANSPOSITION
        if fileReaderAndWriter.checkFilePath(for: .transposition) {
            transposition = fileReaderAndWriter.readTranspositionFile()
        } else {
            transposition = Notes.C.name
            fileReaderAndWriter.writeNewTransposition(newTransposition: transposition)
        }
        let transpositionArr = transposition.components(separatedBy: " ")
        if (transpositionArr.count > 1) {
            transpositionMode = "Instrument"
        } else {
            transpositionMode = "Notes"
        }
        
        // METRONOME
        if fileReaderAndWriter.checkFilePath(for: .metronome) {
            metronomeOffBeatPulse = fileReaderAndWriter.readMetronomePulse()
        } else {
            metronomeOffBeatPulse = "Off"
            fileReaderAndWriter.writeNewMetronomePulse(newPulse: metronomeOffBeatPulse)
        }
        
        //DRONE
        if fileReaderAndWriter.checkFilePath(for: .droneInst) {
            selectedDrone = fileReaderAndWriter.readDroneInstrument()
        } else {
            selectedDrone = "Cello"
            fileReaderAndWriter.writeDroneInstrument(newDrone: selectedDrone)
        }
        
        // INTRO BEATS
        if fileReaderAndWriter.checkFilePath(for: .countInBeats) {
            introBeats = fileReaderAndWriter.readIntroBeats()
        } else {
            introBeats = "2-4"
            fileReaderAndWriter.writeIntroBeats(beats: introBeats)
        }
        introBeatsArr = introBeats.components(separatedBy: "-")
        
        // ACHIEVEMENTS
        if fileReaderAndWriter.checkFilePath(for: .achievements) {
            scaleAchievements = fileReaderAndWriter.readScaleAchievements()
        } else {
            // The number of scales played is set to 0 here initially
            // weekCount : MonthCount : YearCount : AlltimeCount : prev Week : prev Month : prev year
            scaleAchievements = "0:0:0:0:0:0:0" /// THINK ABOUT DOING THIS BETTER HERE
        }
        var dateTime = DateTime(scaleAchievements: scaleAchievements)
        dateTime.alterCount()
        scaleAchievements = "\(dateTime.weekCount):\(dateTime.monthCount):\(dateTime.yearCount):\(dateTime.allTimeCount)"
                          + ":\(dateTime.week):\(dateTime.month):\(dateTime.year)"
        fileReaderAndWriter.writeScaleAchievements(newData: scaleAchievements)
        
        // INITIAL HINT
        if fileReaderAndWriter.checkFilePath(for: .initialHint) {
            initialHint = fileReaderAndWriter.readInitialHint()
        } else {
            initialHint = "1"
            fileReaderAndWriter.writeInitialHint(value: initialHint)
        }
    }
    
    /**
     The main switch statement to toggle between views, transfering the  parameters as required.
     */
    var body: some View {
        let selectedBackgroundImage = musicNotes.backgroundImage ?? self.backgroundImage
        let startingNote = musicNotes.tonicNote
        let notesCase = musicNotes.tonality
        
        return Group {
            switch screenType {
            case .scale:
                ScalesView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .arpeggio:
                ArpeggioView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .otherview:
                // Upon failing goes to special screen
                OtherScalesView(screenType: $screenType, displayType: musicNotes.otherSpecificScaleTypes ?? OtherScaleTypes.special, backgroundImage: selectedBackgroundImage)
            case .settings:
                SettingsView(screenType: $screenType, backgroundImage: selectedBackgroundImage, instrumentSelected: fileReaderAndWriter.readScaleInstrument(), backgroundColour: fileReaderAndWriter.readBackgroundImage(), transpositionMode: transpositionMode, transposition: transposition, metronomePulseSelected: metronomeOffBeatPulse, droneSelected: selectedDrone, slowIntroBeatsSelected: introBeatsArr[0], fastIntroBeatsSelected: introBeatsArr[1])
            case .soundview:
                SoundView(screenType: $screenType, backgroundImage: selectedBackgroundImage, tonicNote: startingNote, noteCase: notesCase)
            case .droneview:
                DroneView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .favouritesview:
                FavouritesView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .aboutview:
                AboutView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .homepage:
                HomePage(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .achievements:
                AchievementsView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            case .soundOptionsView:
                SoundOptionsView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
            default:
                NoteSelectionView(screenType: $screenType, backgroundImage: selectedBackgroundImage)
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
    
    var fileReaderAndWriter = FileReaderAndWriter()
    @Binding var screenType: ScreenType
    @State private var offset: CGFloat = .zero
    var backgroundImage: String

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let buttonHeight = height/10
            let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
            let portrate = height > width
            
            ZStack {
                AnimationNotesView(width: width * 0.9, offset: self.$offset, fileReaderAndWriter: fileReaderAndWriter)
                
                VStack {
                    if (portrate) {
                        titleImage.resizable()
                            .scaledToFit()
                            .frame(maxWidth: width * 0.9, maxHeight: height / 6, alignment: .center)
                            .clipped()
                    } else {
                        titleImage.resizable()
                            .scaledToFit()
                            .frame(maxWidth: width * 0.9, maxHeight: height / 6, alignment: .center)
                    }
                    
                    TonicNoteDisplay(buttonHeight: buttonHeight, buttonWidth: width)
                    
                    ScrollView {
                        
                        Button {
                            self.screenType = .scale
                        } label: {
                            MainUIButton(buttonText: "Scales", type: 1, height: buttonHeight, buttonWidth: width)
                        }
                        
                        Button {
                            self.screenType = .arpeggio
                        } label: {
                            MainUIButton(buttonText: "Arpeggio", type: 1, height: buttonHeight, buttonWidth: width)
                        }
                        
                        Button {
                            self.screenType = .droneview
                        } label: {
                            MainUIButton(buttonText: "Drone", type: 2, height: buttonHeight, buttonWidth: width)
                        }
                        
                        Spacer()
                    }

                    
                    Button {
                        self.screenType = .noteSelection
                    } label: {
                        MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: width)
                    }
                }
            }.onAppear() {
                offset += (width < height) ? height * 2 : width * 2
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        }
    }
}

/**
 Creates the animated notes for the screen.
 Starts above the display, falls vertically downwards until it is below the display.
 */
struct ImageAnimation: View {
    
    var imageName: String
    var xPos: CGFloat
    var duration: CGFloat
    @Binding var offset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let portraite = (geometry.size.width < geometry.size.height)
            let width = portraite ? geometry.size.width : geometry.size.height
            let height = portraite ? geometry.size.height : geometry.size.width
            
            Image(imageName).resizable()
                .frame(width: width * 0.1, height: height * 0.1, alignment: .center)
                .padding(20)
                .shadow(color: Color.white, radius: 10.00)
                .offset(x: xPos, y: self.offset - height * 0.8)
                .animation(Animation.easeInOut(duration: duration).repeatForever(autoreverses: false), value: offset)
        }
    }
}
