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
    
    var body: some View {
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                let buttonHeight = universalSize.height/10
                
                Text(specialTitle).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                
                ScrollView {
                
                    if (specialTitle.lowercased() == "modes") {
                        ForEach(modes, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = mode
                                musicNotes.type = "mode"
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: mode, type: 1, height: buttonHeight)
                            }
                        }
                    } else if (specialTitle.lowercased() == "special") {
                        ForEach(specialTypes, id: \.self) { type in
                            Button {
                                musicNotes.tonality = "" //There is no tonality for these scales
                                musicNotes.type = type + "-Scale"
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: type, type: 1, height: buttonHeight)
                            }
                        }
                    } else if (specialTitle.lowercased() == "tetrads") {
                            ForEach(tetrads, id: \.self) { type in
                                Button {
                                    musicNotes.tonality = "tetrad" //There is no tonality for these scales
                                    musicNotes.type = type
                                    screenType = "soundview"
                                } label: {
                                    MainUIButton(buttonText: type, type: 1, height: buttonHeight)
                                }
                            }
                    }
                }
                Spacer()
                
                Button {
                    self.screenType = "scale"
                } label: {
                    MainUIButton(buttonText: "Scale", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
