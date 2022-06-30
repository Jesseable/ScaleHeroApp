//
//  SpecialView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 3/1/22.
//

import SwiftUI

/**
 Creates the view for all of the special cases inside of scales and arpeggios. Such as chromatic scales, tetrads, modes ect
 */
struct OtherScalesView: View {
    
    @Binding var screenType: ScreenType
    @State var displayType: OtherScaleTypes
    @EnvironmentObject var musicNotes: MusicNotes
    
    private let universalSize = UIScreen.main.bounds
    // All button names for the modes specialView in scales
    private let modes = ["Lydian", "Ionian", "Mixolydian", "Dorian", "Aeolian", "Phrygian", "Locrian"]
    // All button names for the special specialView in scales
    private let specialTypes = ["Chromatic", "Whole-Tone", "Major-Pentatonic", "Minor-Pentatonic", "Blues"]
    // All button names for the tetrads specialView in arpeggios
    private let tetrads = ["Dominant-Seventh", "Major-Seventh", "Minor-Seventh", "Diminished-Seventh"]
    var backgroundImage: String
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                Text(displayType.rawValue).asTitle()
                
                ScrollView {
                    NoteSelectionButton(buttonHeight: buttonHeight) // NEEDS TO ALSO CHANGE THE DISPLAY TO THE SOUND DISPLAY
                    getView(view: displayType, buttonHeight: buttonHeight)
                }
                Spacer()
                
                Button {
                    if (displayType == .tetrads) {
                        self.screenType = .arpeggio
                    } else {
                        self.screenType = .scale
                    }
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
                }
            }
        }
    }
    
    @ViewBuilder func getView(view: OtherScaleTypes, buttonHeight: CGFloat) -> some View {
        switch view {
        case .majorModes: // All Major Modes
            ForEach (MajorScaleMode.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .major(mode: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    let name = musicNotes.getMajorModeName(mode: mode)
                    MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                }
            }
        case .pentatonicModes: // All pentatonic modes
            ForEach (PentatonicScaleMode.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .pentatonic(mode: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    let name = musicNotes.getPentatonicModeName(mode: mode)
                    MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                }
            }
        case .special: // Can go to pentatonic modes screen and contains all chromatic scale alterations and blues scale
            ForEach (ChromaticAlteration.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .chromatic(alteration: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    let name = musicNotes.getChromaticAlteration(for: mode)
                    MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                }
            }
            Button {
                musicNotes.tonality = .scale(tonality: .blues)
                musicNotes.backDisplay = .otherview
                self.screenType = .soundview
            } label: {
                let name = "blues"
                MainUIButton(buttonText: name, type: 1, height: buttonHeight)
            }
        case .tetrads: // Lists all of the 7th scales
            ForEach (ArpeggioTonality.allCases, id: \.self) { mode in
                if (mode != .major || mode != .minor) {
                    Button {
                        musicNotes.tonality = .arpeggio(tonality: mode)
                        musicNotes.backDisplay = .otherview
                        self.screenType = .soundview
                    } label: {
                        let name = mode.rawValue
                        MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                    }
                }
            }
        }
    }
}
