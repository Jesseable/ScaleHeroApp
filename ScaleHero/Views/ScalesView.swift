//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

class MusicNotes: ObservableObject {

    private let musicAlphabet = ["A", "A#/Bb", "B", "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab"]
    
    @Published var noteName = "C"
    
    func getMusicAlphabet() -> [String] {
        return musicAlphabet
    }
}

struct ScalesView: View {
    
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
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Major scale")) {
                        Text("Major")
                    }.padding()
                    
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Minor scale")) {
                        Text("Minor")
                    }.padding()
                    
                    // Go to another link to select options
                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Special scale")) {
                        Text("Special (modes)")
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
