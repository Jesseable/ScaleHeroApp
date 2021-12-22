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
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
            
                VStack {
                    Spacer()
                    
                    // Turn to image button
                    Menu("Note: " + String(musicNotes.noteName)) {
                        ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                            Button("Note: \(note)", action: {musicNotes.noteName = note})
                        }
                    }.padding()
                    
                    // Turn to image button
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Major arpeggio")) {
                        Text("Major (Triad)")
                    }.padding()
                    
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Minor arpeggio")) {
                        Text("Minor (Triad)")
                    }.padding()
                    
                    // Go to another link to select options
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Special arpeggio")) {
                        Text("Special (Tetrads)")
                    }.padding()
                    
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
