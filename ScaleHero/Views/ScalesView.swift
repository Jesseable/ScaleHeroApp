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
                    Spacer()
                    
                    // Turn to image button
                    Menu("Note: " + String(musicNotes.noteName)) {
                        ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                            Button("Note: \(note)", action: {musicNotes.noteName = note})
                        }
                    }.padding()
                    
                    Button {
                        musicNotes.tonality = "Major"
                        musicNotes.type = "scale"
                        self.screenType = "soundview"
                    } label: {
                        Text("Major")
                    }.padding()
                    
//                    // Turn to image button
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Major scale", backgroundImage: backgroundImage)) {
//                        Text("Major")
//                    }.padding()
                    
                    Button {
                        musicNotes.tonality = "Minor"
                        musicNotes.type = "scale"
                        self.screenType = "soundview"
                    } label: {
                        Text("Minor")
                    }.padding()
//
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Minor scale", backgroundImage: backgroundImage)) {
//                        Text("Minor")
//                    }.padding()
                    
                    Button {
                        // Create another page
//                        musicNotes.tonality = "Major"
//                        musicNotes.type = "scale"
//                        self.screenType = "soundview"
                    } label: {
                        Text("Minor (Triad)")
                    }.padding()
                    
//                    // Go to another link to select options
//                    NavigationLink(destination: SoundView(scaleType: musicNotes.noteName +  " Special scale", backgroundImage: backgroundImage)) {
//                        Text("Special (modes)")
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
