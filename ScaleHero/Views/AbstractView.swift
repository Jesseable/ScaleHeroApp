//
//  abstractView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/1/22.
//

import SwiftUI

struct AbstractView: View {

    @EnvironmentObject var musicNotes: MusicNotes
    @Binding var screenType: String
    
    private let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    
    var body: some View {
        
        let buttonHeight = universalSize.height/10
        
        ZStack {
            
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                
                Text("ABSTRACT SCALES")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color.white)
                
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
                        musicNotes.type = "Pentatonic"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Major Pentatonic", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "Pentatonic"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Minor Pentatonic", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.tonality = "Blues"
                        musicNotes.type = "" // SEE IF THIS IS ALLOWED
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Blues", type: 1, height: buttonHeight)
                    }
                    
                    Button {
//                            musicNotes.tonality = "Minor"
//                            musicNotes.type = "melodic"
//                            self.screenType = "soundview" // takes you to a new page that adds three notes to the original major/minor scale
                    } label: {
                        MainUIButton(buttonText: "Galamian System", type: 1, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                Button {
                    self.screenType = "HomeScreen"
                } label: {
                    MainUIButton(buttonText: "HomeScreen", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
