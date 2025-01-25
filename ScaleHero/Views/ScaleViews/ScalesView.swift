//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

/**
 Creates the view to select a number of varieties of scales.
 */
struct ScalesView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: ScreenType
    var backgroundImage: String
    
    var body: some View {
        GeometryReader { geometry in
            
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                
                Text("SCALES").asTitle()
                
                TonicNoteDisplay(buttonHeight: buttonHeight, buttonWidth: width)
                
                ScrollView {
                    
                    // Major scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .major(mode: .ionian))
                        musicNotes.backDisplay = .scale
                        self.screenType = .soundview
                    } label: {
                        MainUIButton(buttonText: "Major", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Minor scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .naturalMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Minor", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Harmonic Minor Scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .harmonicMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Harmonic Minor", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Melodic minor scale
                    Button {
                        musicNotes.tonality = .scale(tonality: .melodicMinor)
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Melodic Minor", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Major scale modes (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .majorModes
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Major Modes", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Major scale modes (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .pentatonicModes
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Pentatonic Modes", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    // Other Special scale options (goes to a new option screen)
                    Button {
                        musicNotes.otherSpecificScaleTypes = .special
                        musicNotes.backDisplay = .scale
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "Special", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    Spacer()
                }
                Button {
                    musicNotes.backDisplay = .homepage
                    self.screenType = musicNotes.backDisplay
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
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
