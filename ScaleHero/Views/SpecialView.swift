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
struct SpecialView: View {
    
    @Binding var screenType: String
    @State var specialTitle: String
    @EnvironmentObject var musicNotes: MusicNotes
    
    private let universalSize = UIScreen.main.bounds
    // All button names for the modes specialView in scales
    private let modes = ["Lydian", "Ionian", "Mixolydian", "Dorian", "Aeolian", "Phrygian", "Locrian"]
    // All button names for the special specialView in scales
    private let specialTypes = ["Chromatic", "Whole-Tone"]
    // All button names for the tetrads specialView in arpeggios
    private let tetrads = ["Dominant-Seventh", "Major-Seventh", "Minor-Seventh", "Diminished-Seventh"]
    var backgroundImage: String
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                Text(specialTitle).textCase(.uppercase)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    
                    Menu {
                        ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                            Button("Note: \(note)", action: {musicNotes.noteName = note})
                        }
                    } label: {
                        MainUIButton(buttonText: "Note: \(musicNotes.noteName)", type: 1, height: buttonHeight)
                    }.padding(.top)
                
                    switch specialTitle.lowercased() {
                    case "major scale modes":
                        ForEach(modes, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = mode
                                musicNotes.type = "mode"
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: mode, type: 1, height: buttonHeight)
                            }
                        }
                    case "special":
                        ForEach(specialTypes, id: \.self) { type in
                            Button {
                                musicNotes.tonality = "" //There is no tonality for these scales
                                musicNotes.type = type + "-Scale"
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: type, type: 1, height: buttonHeight)
                            }
                        }
                    case "tetrads":
                        ForEach(tetrads, id: \.self) { type in
                            Button {
                                musicNotes.tonality = "tetrad"
                                musicNotes.type = type
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: type.components(separatedBy: "-")[0] + " 7th", type: 1, height: buttonHeight)
                            }
                        }
                    default:
                        // make a clearer error message in the form of an UI button
                        MainUIButton(buttonText: "FAID TO LOAD", type: 1, height: buttonHeight)
                    }
                }
                Spacer()
                
                Button {
                    if (musicNotes.type == "Tetrads") {
                        self.screenType = "arpeggio"
                    } else {
                        self.screenType = "scale"
                    }
                } label: {
                    if (musicNotes.type == "Tetrads") {
                        MainUIButton(buttonText: "Arpeggios", type: 3, height: buttonHeight)
                    } else {
                        MainUIButton(buttonText: "Scale", type: 3, height: buttonHeight)
                    }
                }
            }
        }
    }
}
