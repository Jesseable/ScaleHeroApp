//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

struct ArpeggioView : View {
    
    let universalSize = UIScreen.main.bounds
    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: String
    var backgroundImage: String
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
            
                VStack {
                    Spacer()
                    
                    // Turn to image button
                    Menu("Note: " + String(musicNotes.noteName)) {
                        ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                            Button("Note: \(note)", action: {musicNotes.noteName = note})
                        }
                    }.padding()
                    
                    Button {
                        musicNotes.tonality = "Major"
                        musicNotes.type = "arpeggio"
                        self.screenType = "soundview"
                    } label: {
                        Text("Major (Triad)")
                    }.padding()

                    
//                    // Turn to image button
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Major arpeggio", backgroundImage: backgroundImage)) {
//                        Text("Major (Triad)")
//                    }.padding()
                    
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "arpeggio"
                        self.screenType = "soundview"
                    } label: {
                        Text("Minor (Triad)")
                    }.padding()
                    
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Minor arpeggio", backgroundImage: backgroundImage)) {
//                        Text("Minor (Triad)")
//                    }.padding()
                    
                    Button {
                        // Goes to another options page
//                        musicNotes.tonality = "Major"
//                        musicNotes.type = "arpeggio"
//                        self.screenType = "soundview"
                    } label: {
                        Text("Special (Tetrads)")
                    }.padding()
                    
                    // Go to another link to select options
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Special arpeggio", backgroundImage: backgroundImage)) {
//                        Text("Special (Tetrads)")
//                    }.padding()
                    
                    // Turn to image button
                    Button("Settings") {
                        // do nothing
                    }.padding()
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        self.screenType = "homePage"
                    } label: {
                        Text("HomePage")
                    }.padding()
                }
                .navigationBarTitle("ARPEGGIOS", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("ARPEGGIOS")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
}
