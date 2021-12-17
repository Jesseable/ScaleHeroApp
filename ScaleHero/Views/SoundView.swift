//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI
import SwiftySound

struct SoundView : View {
    
    let universalSize = UIScreen.main.bounds
    
    @State var scaleType: String
    @State var isPlaying = false
    @State var numOctave = 1
    @State var tempo = 100
    @State var drone = true
    
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
                }
            
                Menu("Tempo = " + String(tempo)) {
                    ForEach(40..<221) { i in
                        if (i % 10 == 0) {
                            Button("Tempo: " + String(i), action: {tempo = i})
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    }
                    if (drone) {
                        Image(systemName: "square").foregroundColor(Color.white)
                    } else {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    }
                    Button("Drone") {
                    drone.toggle()
                    Spacer()
                }
                
                
                Spacer()
                Spacer()
            }
        }
    }
}
