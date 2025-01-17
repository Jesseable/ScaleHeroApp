//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

/**
 Observable object class that stays in the environment. Saves and publishes data that will be used in multiple classes  TODO ------- THIS NEEDS TO HAVE ITS OWN FILE -> WHAT IS GOING ON
 */
class MusicNotes: ObservableObject {
    
    var scaleNotes = [""]
    var scaleNoteNames = [""]
    @Published var tonicNote = "C" // TODO: Needs to be changed to Notes at some point
    @Published var tempo = 60.0
    @Published var octaves: OctaveNumber = .one
    
    // tonicMode cases: 1 being never, 2: always, 3: always except for the first note
    @Published var tonicMode: TonicOption = .noRepeatedTonic
    // An enum containing either scale or arpeggio followed by the tonality, e.g. Case.scale(.major)
    @Published var tonality: Case = .unselected
    @Published var intervalOption: Interval = .none
    @Published var intervalType: IntervalOption = .allUp
    @Published var backDisplay: ScreenType = .homepage
    @Published var otherSpecificScaleTypes : OtherScaleTypes?
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var backgroundImage : String? // TODO: Is this used anywhere. Possibly just delete it...
    @Published var playScaleNotes = true
    @Published var playDrone = true
    @Published var startingOctave: OctaveNumber = .one
    @Published var transposition = "C" // TODO: Convert to a Notes at some point
    @Published var noteDisplay = 2
    @Published var metronome = true
    @Published var dismissable = false
    @Published var repeatNotes = false
    @Published var metronomePulse = 1
    @Published var endlessLoop = false
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
        
        VStack {

            Text("SCALES").asTitle()
            
            TonicNoteDisplay(buttonHeight: buttonHeight)
            
            ScrollView {
                
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
                MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
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
