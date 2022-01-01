//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI
import SwiftySound
import AVFAudio

struct SoundView : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State var scaleType: String
    @State private var isPlaying = false
    @State private var numOctave = 1 // Put a few of these in a new class that can use environmentalObject to access all of the displays.
    @State private var tempo = CGFloat(60)
    @State private var drone = true
    @State private var chords = false
    @State private var scaleNotes = true
    @State var playScale = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    
    var backgroundImage: String
    
    var body: some View {
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                Text(scaleType).bold().textCase(.uppercase).font(.title).foregroundColor(.white).padding()
                
                Spacer()
                
                Button {
                    let scaleTypeArr = scaleType.components(separatedBy: " ")
                    let startingNote = scaleTypeArr[0]
                    let tonality = scaleTypeArr[1].lowercased()
                    let scaleType = scaleTypeArr[2].lowercased()
                    var scale = WriteScales(style: scaleType.lowercased())
                    let scaleInfo = scale.ScaleNotes(startingNote: startingNote, octave: numOctave, tonality: tonality) // Change later
                    
                    if (isPlaying) {
                        Sound.enabled = false
                        isPlaying = false
                        playScale.cancelAllSounds()
                    } else {
                        Sound.enabled = true
                        if (drone) {
                            let duration = CGFloat(60/Int(self.tempo) * scaleInfo.count)
                            playScale.playDroneSound(duration: duration, startingNote: startingNote)
                        }
                        if (scaleNotes) {
                            playScale.playScaleSounds(temp: Int(self.tempo), scaleInfoArra: scaleInfo)
                        }
                        
                        isPlaying = true
                    }
                } label: {
                    HStack {
                        if isPlaying {
                            Text("Stop")
                            Image(systemName: "speaker.slash").foregroundColor(Color.white)
                        } else {
                            Text("Play")
                            Image(systemName: "speaker.wave.3").foregroundColor(Color.white)
                        }
                    }
                }.padding()

                // Ovtaves view
                Menu("Number of Octaves = " + String(numOctave)) {
                    Button("1 octave", action: {numOctave = 1})
                    Button("2 octaves", action: {numOctave = 2})
                    Button("3 octaves", action: {numOctave = 3})
                }.padding()
            
                Text("Tempo = " + String(Int(tempo))).foregroundColor(Color.white)
                Slider(value: $tempo, in: 40...200)
                    .padding(.horizontal)
//                Menu("Tempo = " + String(tempo)) {
//                    ForEach(20..<181) { i in
//                        if (i % 10 == 0) {
//                            Button("Tempo: " + String(i), action: {tempo = i})
//                        }
//                    }
//                }.padding()
                
                Group {
                    Button {
                        if (!chords) {
                            drone.toggle()
                        }
                    } label: {
                        HStack {
                            if (drone) {
                                Text("Drone")
                                Image(systemName: "checkmark.square").foregroundColor(Color.white)
                            } else {
                                if (chords) {
                                    Text("Drone")
                                    Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                                } else {
                                    Text("Drone")
                                    Image(systemName: "square").foregroundColor(Color.white)
                                }
                            }
                        }
                    }.padding()
                    
                    Button {
                        if (!drone) {
                            chords.toggle()
                        }
                    } label: {
                        HStack {
                            if (chords) {
                                Text("Chords")
                                Image(systemName: "checkmark.square").foregroundColor(Color.white)
                            } else {
                                if (drone) {
                                    Text("Chords")
                                    Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                                } else {
                                    Text("Chords")
                                    Image(systemName: "square").foregroundColor(Color.white)
                                }
                            }
                        }
                    }.padding()
                    
                    Button {
                        scaleNotes.toggle()
                    } label: {
                        HStack {
                            if (scaleNotes) {
                                Text("Scale Notes ")
                                Image(systemName: "checkmark.square").foregroundColor(Color.white)
                            } else {
                                Text("Scale Notes ")
                                Image(systemName: "square").foregroundColor(Color.white)
                            }
                        }
                    }.padding()
                }
                
                Spacer()
                Spacer()
                
                Button {
                    self.screenType = musicNotes.type
                } label: {
                    Text(musicNotes.type)
                }.padding()
            }
        }
    }
}
