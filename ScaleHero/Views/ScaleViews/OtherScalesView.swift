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
    
    @Binding var screenType: String
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
                    
                    NoteSelectionButton(buttonHeight: buttonHeight)
                    
                    switch displayType {
                    case .majorModes: // All Major Modes
                        ForEach (MajorScaleMode.allCases, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = .scale(tonality: .major(mode: mode))
                            } label: {
                                let name = musicNotes.getMajorModeName(mode: mode)
                                MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                            }
                        }
                    case .pentatonicModes: // All pentatonic modes
                        ForEach (PentatonicScaleMode.allCases, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = .scale(tonality: .pentatonic(mode: mode))
                            } label: {
                                let name = musicNotes.getPentatonicModeName(mode: mode)
                                MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                            }
                        }
                    case .special: // Can go to pentatonic modes screen and contains all chromatic scale alterations and blues scale
                        ForEach (ChromaticAlteration.allCases, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = .scale(tonality: .chromatic(alteration: mode))
                            } label: {
                                let name = musicNotes.getChromaticAlteration(for: mode)
                                MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                            }
                        }
                        Button {
                            musicNotes.tonality = .scale(tonality: .blues)
                        } label: {
                            let name = "blues"
                            MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                        }
                        Button {
                            displayType = .pentatonicModes
                        } label: {
                            let name = "pentatonic modes"
                            MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                        }
                    case .tetrads: // Lists all of the 7th scales
                        ForEach (ArpeggioTonality.allCases, id: \.self) { mode in
                            if ($0 != .major || $0 != .minor) {
                                Button {
                                    musicNotes.tonality = .arpeggio(tonality: $0)
                                } label: {
                                    let name = $0.rawValue
                                    MainUIButton(buttonText: name, type: 1, height: buttonHeight)
                                }
                            }
                        }
                    }
                }
//
//                    switch specialTitle.lowercased() {
//                    case "major scale modes":
//                        ForEach(modes, id: \.self) { mode in
//                            Button {
//                                musicNotes.tonality = mode
//                                screenType = "soundview"
//                            } label: {
//                                MainUIButton(buttonText: mode, type: 1, height: buttonHeight)
//                            }
//                        }
//                    case "special":
//                        ForEach(specialTypes, id: \.self) { type in
//                            Button {
//                                musicNotes.tonality = "others"
//                                screenType = "soundview"
//                            } label: {
//                                MainUIButton(buttonText: type.replacingOccurrences(of: "-", with: " "), type: 1, height: buttonHeight)
//                            }
//                        }
//                    case "tetrads":
//                        ForEach(tetrads, id: \.self) { type in
//                            Button {
//                                musicNotes.tonality = "tetrad"
//                                screenType = "soundview"
//                            } label: {
//                                MainUIButton(buttonText: type.components(separatedBy: "-")[0] + " 7th", type: 1, height: buttonHeight)
//                            }
//                        }
//                    default:
//                        // make a clearer error message in the form of an UI button
//                        MainUIButton(buttonText: "FAID TO LOAD", type: 1, height: buttonHeight)
//                    }
                Spacer()
                
                Button {
                    if (displayType == .pentatonicModes) {
                        displayType = .special
                    } else {
                        if (musicNotes.tonality == .scale) {
                            self.screenType = "scale"
                        } else {
                            self.screenType = "arpeggio"
                        }
                    }
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
