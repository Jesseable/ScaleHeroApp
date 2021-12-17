//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

struct ArpeggioView : View {
    
    let universalSize = UIScreen.main.bounds
    @State var noteName = "C"
    
    @Binding var screenType: String
    
    let musicAlphabet = ["A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab"]
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
            
                VStack {
                    //Text("ARPEGGIOS").bold().font(.title).foregroundColor(.white).padding()
                    
                    Spacer()
                    
                    // Turn to image button
                    Menu("Note: " + String(noteName)) {
                        ForEach(musicAlphabet, id: \.self) { note in
                            Button("Note: \(note)", action: {noteName = note})
                        }
                    }.padding()
                    
                    // Turn to image button
                    NavigationLink(destination: SoundView(scaleType: noteName +  " Major arpeggio")) {
                        Text("Major (Triad)")
                    }.padding()
                    
                    NavigationLink(destination: SoundView(scaleType: noteName +  " Minor arpeggio")) {
                        Text("Minor (Triad)")
                    }.padding()
                    
                    // Go to another link to select options
                    NavigationLink(destination: SoundView(scaleType: noteName +  " Special arpeggio")) {
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
