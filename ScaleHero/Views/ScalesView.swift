//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

class MusicNotes: ObservableObject {

    private let musicAlphabet = ["C", "G", "D", "A", "E", "B", "F#/Gb", "C#/Db", "G#/Ab", "D#/Eb", "A#/Bb", "F"]
    @Published var noteName = "C"
    @Published var tempo = CGFloat(60)
    @Published var octaves = 1
    @Published var type = "Scale"
    @Published var tonality = "Major"
    @Published var scaleNotes = [""]
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var currentNote = "C"
    @Published var backgroundImage : String?
    
    func getMusicAlphabet() -> [String] {
        return musicAlphabet
    }
}

struct ScalesView: View {
    
    let universalSize = UIScreen.main.bounds
    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: String
    var backgroundImage: String
    
    var body: some View {
        
        NavigationView { // Consider removing navigation review here
        
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
            
                VStack {
                    let buttonHeight = universalSize.height/10
                    ScrollView {
                        
                        Menu {
                            ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                                Button("Note: \(note)", action: {musicNotes.noteName = note})
                            }
                        } label: {
                            MainUIButton(buttonText: "Note: \(musicNotes.noteName)", type: 1, height: buttonHeight)
                        }.padding(.top)
                        
                        Button {
                            musicNotes.tonality = "Major"
                            musicNotes.type = "scale"
                            self.screenType = "soundview"
                        } label: {
                            MainUIButton(buttonText: "Major", type: 1, height: buttonHeight)
                        }
                        
                        Button {
                            musicNotes.tonality = "Minor"
                            musicNotes.type = "scale"
                            self.screenType = "soundview"
                        } label: {
                            MainUIButton(buttonText: "Minor", type: 1, height: buttonHeight)
                        }
                        
                        Button {
                            musicNotes.tonality = "Minor"
                            musicNotes.type = "harmonic"
                            self.screenType = "soundview"
                        } label: {
                            MainUIButton(buttonText: "Harmonic Minor", type: 1, height: buttonHeight)
                        }
                        
                        Button {
                            musicNotes.tonality = "Minor"
                            musicNotes.type = "melodic"
                            self.screenType = "soundview"
                        } label: {
                            MainUIButton(buttonText: "Melodic Minor", type: 1, height: buttonHeight)
                        }
                        
                        
                        Button {
                            musicNotes.type = "Modes"
                            self.screenType = "specialview"
                        } label: {
                            MainUIButton(buttonText: "Modes", type: 1, height: buttonHeight)
                        }
                        
                        Button {
                            musicNotes.type = "Special"
                            self.screenType = "specialview"
                        } label: {
                            MainUIButton(buttonText: "Special", type: 1, height: buttonHeight)
                        }
                        
                        Spacer()
                    }
                    Button {
                        self.screenType = "HomeScreen"
                    } label: {
                        MainUIButton(buttonText: "HomeScreen", type: 3, height: buttonHeight)
                    }
                }
                .navigationBarTitle("SCALES", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("SCALES")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
}
