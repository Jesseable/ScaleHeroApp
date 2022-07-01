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

    private let musicAlphabet = ["C", "C#", "Db", "D", "D#", "E", "F", "F#", "Gb", "G", "G#", "Ab", "A", "A#", "Bb", "B"]
    private let instrumentSelection = ["Bassoon in C", "Clarinet in Bb", "Clarinet in Eb", "Euphonium in C", "Horn in F", "Oboe in C", "Recorder in C", "Recorder in F", "Flute in C", "Saxophone in Bb", "Saxophone in Eb", "Strings in C", "Trombone in C", "Trumpet in Bb", "Tuba in F"]
    
    @Published var noteName = "C"
    @Published var tempo = 60.0
    @Published var octaves = 1
    
    // tonicMode cases: 1 being never, 2: always, 3: always except for the first note
    @Published var tonicMode = TonicOption.noRepeatedTonic
    // An enum containing either scale or arpeggio followed by the tonality, e.g. Case.scale(.major)
    @Published var tonality : Case?
    @Published var intervalOption = Interval.none
    @Published var backDisplay = ScreenType.homepage
    @Published var otherSpecificScaleTypes : OtherScaleTypes?
    @Published var scaleNotes = [""]
    @Published var scaleNoteNames = [""]
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var backgroundImage : String?
    @Published var playScaleNotes = true
    @Published var playDrone = true
    @Published var startingOctave = 1
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
    
    func getType() -> String {
        switch tonality {
        case .arpeggio:
            return "arpeggio"
        case .scale:
            return "scale"
        case .none:
            return "Error: tonality was NULL"
        }
    }
    
    func getTonality() -> String {
        switch tonality {
        case .arpeggio(let tonality):
            return tonality.rawValue
        case .scale(let tonality):
            switch tonality {
            case .major(let mode):
                return getMajorModeName(mode: mode)
            case .naturalMinor:
                return "minor"
            case .harmonicMinor:
                return "harmonic minor"
            case .melodicMinor:
                return "melodic minor"
            case .chromatic(let alteration):
                return getChromaticAlteration(for: alteration)
            case .pentatonic(let mode):
                return getPentatonicModeName(mode: mode)
            case .blues:
                return "blues"
            }
        case .none:
            return "Error: tonality was NULL"
        }
    }
    
    func getChromaticAlteration(for alteration: ChromaticAlteration) -> String {
        switch alteration {
        case .unchanged:
            return "chromatic"
        case .wholeTone:
            return "whole tone"
        }
    }
    
    func getMajorModeName(mode: MajorScaleMode) -> String {
        switch mode {
        case .ionian:
            return "major"
        case .dorian:
            return "dorian mode"
        case .phrygian:
            return "phrygian mode"
        case .lydian:
            return "lydian mode"
        case .mixolydian:
            return "mixolydian mode"
        case .aeolian:
            return "aeolian mode"
        case .locrian:
            return "locrian mode"
        }
    }
    
    func getPentatonicModeName(mode: PentatonicScaleMode) -> String {
        switch mode {
        case .mode1_major:
            return "mode 1: major pentatonic"
        case .mode2_egyptian:
            return "mode 2: egytpian scale"
        case .mode3_manGong:
            return "mode 3: man gong scale"
        case .mode4_ritusen:
            return "mode 4: ritusen scale"
        case .mode5_minor:
            return "mode 5: minor pentatonic"
        }
    }
    ///Possibly do something similar capitalising every fist  letter of a word
//    func getMusicTitile(from title: String) -> String {
//
//        var newtitle =  title.replacingOccurrences(of: "-", with: " ")
//                .uppercased()
//                .replacingOccurrences(of: "TETRAD ", with: "")
//                .replacingOccurrences(of: "SEVENTH", with: "7th")
//                .replacingOccurrences(of: "OTHERS ", with: "")
//
//        if noteName.count > 1 {
//            let start = title.index(title.startIndex, offsetBy: 4) // Makes the BB appeare as Bb instead
//            let end = title.index(title.startIndex, offsetBy: 6)
//            let range = start..<end
//            newtitle = newtitle.replacingOccurrences(of: "B", with: "b", options: .literal, range: range)
//        }
//        return newtitle
//    }
}

/**
 Creates the view to select a number of varieties of scales.
 */
struct ScalesView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: ScreenType
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
                        musicNotes.tonality = .scale(tonality: .major(mode: .ionian))
                        musicNotes.backDisplay = .scale
                        self.screenType = .soundview
                    } label: {
                        MainUIButton(buttonText: "Major", type: 1, height: buttonHeight)
                    }
                    
                    // Minor scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .naturalMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Harmonic Minor Scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .harmonicMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Harmonic Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Melodic minor scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .melodicMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Melodic Minor", type: 1, height: buttonHeight)
                    }
                    
                    // Major scale modes (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .majorModes
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Major Modes", type: 1, height: buttonHeight)
                    }
                    
                    // Major scale modes (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .pentatonicModes
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Pentatonic Modes", type: 1, height: buttonHeight)
                    }
                    
                    // Other Special scale options (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .special
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Special", type: 1, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                Button {
                    musicNotes.backDisplay = .homepage
                    self.screenType = musicNotes.backDisplay
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
            .accessibilityAddTraits(.isHeader)
            .foregroundColor(Color.white)
    }
}
