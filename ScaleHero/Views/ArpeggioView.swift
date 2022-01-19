//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

/**
 View for selecting arpeggios and tetrads. Set up the same as the scalesView
 */
struct ArpeggioView : View {

    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: String
    let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                
                Text("ARPEGGIOS")
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
                        musicNotes.type = "arpeggio"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Major (Triad)", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "arpeggio"
                        self.screenType = "soundview"
                    } label: {
                        MainUIButton(buttonText: "Minor (Triad)", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.type = "Tetrads"
                        self.screenType = "specialview"
                    } label: {
                        MainUIButton(buttonText: "Special (Tetrads)", type: 1, height: buttonHeight)
                    }
                }
                
                Spacer()
                
                Button {
                    self.screenType = "HomeScreen"
                } label: {
                    MainUIButton(buttonText: "HomeScreen", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
