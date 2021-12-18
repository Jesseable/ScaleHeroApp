//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI
import SwiftySound

struct SoundView : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @State var scaleType: String
    @State private var isPlaying = false
    @State private var numOctave = 1
    @State private var tempo = 100
    @State private var drone = true
    @State private var chords = false
    @State private var scaleNotes = true
    
    var body: some View {
        
        ZStack {
            Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
        
            VStack {
                Text(scaleType).bold().textCase(.uppercase).font(.title).foregroundColor(.white).padding()
                
                Spacer()
                
                Button {
                    if (isPlaying) {
                        Sound.stopAll()
                        isPlaying = false
                    } else {
                        Sound.play(file: "small-loop.mp3", numberOfLoops: 1) // Test with a proper sound file
                        isPlaying = true
                    }
                } label: {
                    if isPlaying {
                        Text("Stop")
                    } else {
                        Text("Play")
                    }
                }.padding()

                // Ovtaves view
                Menu("Number of Octaves = " + String(numOctave)) {
                    Button("1 octave", action: {numOctave = 1})
                    Button("2 octaves", action: {numOctave = 2})
                    Button("3 octaves", action: {numOctave = 3})
                }.padding()
            
                Menu("Tempo = " + String(tempo)) {
                    ForEach(20..<181) { i in
                        if (i % 10 == 0) {
                            Button("Tempo: " + String(i), action: {tempo = i})
                        }
                    }
                }.padding()
                
                HStack {
                    Spacer()
                    if (drone) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        if (chords) {
                            Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                        } else {
                            Image(systemName: "square").foregroundColor(Color.white)
                        }
                    }
                    Button("Drone") {
                        if (!chords) {
                            drone.toggle()
                        }
                    }
                    Spacer()
                }.padding()
                
                HStack {
                    Spacer()
                    
                    if (chords) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        if (drone) {
                            Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                        } else {
                            Image(systemName: "square").foregroundColor(Color.white)
                        }
                    }
                    Button("Chords") {
                        if (!drone) {
                            chords.toggle()
                        }
                    }
                    Spacer()
                }.padding()
                
                HStack {
                    Spacer()
                    
                    if (scaleNotes) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        Image(systemName: "square").foregroundColor(Color.white)
                    }
                    Button("Scale Notes") {
                        scaleNotes.toggle()
                    }
                    Spacer()
                }.padding()
                
                
                Spacer()
                Spacer()
            }
        }
    }
}
