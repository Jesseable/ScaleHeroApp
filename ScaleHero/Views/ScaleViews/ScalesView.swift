//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

/**
 Observable object class that stays in the environment. Saves and publishes data that will be used in multiple classes
 */
class MusicNotes: ObservableObject {

    private let musicAlphabet = ["C", "G", "D", "A", "E", "B", "F#/Gb", "C#/Db", "G#/Ab", "D#/Eb", "A#/Bb", "F"]
    private let instrumentSelection = ["Bassoon in C", "Clarinet in Bb", "Clarinet in Eb", "Euphonium in C", "Horn in F", "Oboe in C", "Recorder in C", "Recorder in F", "Flute in C", "Saxophone in Bb", "Saxophone in Eb", "Strings in C", "Trombone in C", "Trumpet in Bb", "Tuba in F"]
    
    @Published var noteName = "C"
    @Published var tempo = 60.0
    @Published var octaves = 1
    
    // tonicMode cases: 1 being never, 2: always, 3: always except for the first note
    @Published var tonicMode = 1
    @Published var type = "Scale"
    @Published var tonality = "Major"
    @Published var scaleNotes = [""]
    @Published var scaleNoteNames = [""]
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var backgroundImage : String?
    @Published var playScaleNotes = true
    @Published var playDrone = true
    @Published var startingOctave = 1
    @Published var isFavouriteScale = false
    @Published var transposition = "C"
    @Published var noteDisplay = 2
    @Published var metronome = true
    @Published var dismissable = false
    @Published var repeatNotes = false
    @Published var metronomePulse = 1
    @Published var endlessLoop = false
    
    func getMusicAlphabet() -> [String] {
        return musicAlphabet
    }
    
    func getInstrumentSelection() -> [String] {
        return instrumentSelection
    }
    
    func getMusicTitile(from title: String) -> String {
        return title.replacingOccurrences(of: "-", with: " ").uppercased().replacingOccurrences(of: "TETRAD ", with: "").replacingOccurrences(of: "SEVENTH", with: "7th").replacingOccurrences(of: "OTHERS ", with: "")
    }
}

/**
 Creates the view to select a number of varieties of scales.
 */
struct ScalesView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: String
    private let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {

                Text("SCALES").asTitle()
                
                ScrollView {
                    
                    NoteSelectionButton(buttonHeight: buttonHeight)
                    
                    // Major scale
                    Button {
                        musicNotes.tonality = "Major"
                        musicNotes.type = "scale"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Major", type: 1, height: buttonHeight)
                    }
                    
                    // Minor scale
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "scale"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Natural Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Harmonic Minor Scale
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "harmonic"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Harmonic Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Melodic minor scale
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "melodic"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Melodic Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Major scale modes
                    Button {
                        musicNotes.type = "Major Scale Modes"
                        self.screenType = "otherview"
                    } label: {
                        MainUIButton(buttonText: "Modes", type: 1, height: buttonHeight)
                    }
                    
                    // Other Special scale options
                    Button {
                        musicNotes.type = "special"
                        self.screenType = "otherview"
                    } label: {
                        MainUIButton(buttonText: "Special", type: 1, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                Button {
                    self.screenType = "HomeScreen"
                } label: {
                    MainUIButton(buttonText: "Home Page", type: 3, height: buttonHeight)
                }
            }
        }
    }
}

/**
 Sets the text field requirements.
 */
extension Text {
    func asTitle() -> some View {
        font(.largeTitle.bold())
            .textCase(.uppercase)
            .accessibilityAddTraits(.isHeader)
            .foregroundColor(Color.white)
    }
}
