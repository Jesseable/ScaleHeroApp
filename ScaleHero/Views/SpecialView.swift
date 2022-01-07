//
//  SpecialView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 3/1/22.
//

import SwiftUI

struct SpecialView: View {
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State var specialTitle: String
    @EnvironmentObject var musicNotes: MusicNotes
    private let modes = ["Lydian", "Ionian", "Mixolydian", "Dorian", "Aeolian", "Phrygian", "Locrian"]
    private let specialTypes = ["Chromatic", "Whole-Tone"]
    private let tetrads = ["Dominant-Seventh", "Major-Seventh", "Minor-Seventh", "Diminished-Seventh"]

    var backgroundImage: String
    
    var body: some View { // TOO LARGE A VIEW, NEED TO MAKE THE VIEW SMALLER
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                let buttonHeight = universalSize.height/10
                
                Text(specialTitle).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                
                ScrollView {
                
                    switch specialTitle.lowercased() {
                    case "modes":
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
                        Text("Failed to load")
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
