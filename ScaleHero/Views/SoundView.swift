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
                let buttonHeight = universalSize.height/15
                
                Text(scaleType).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                
                Spacer()
                
                Button {
                    let scaleTypeArr = scaleType.components(separatedBy: " ")
                    let startingNote = scaleTypeArr[0]
                    let tonality = scaleTypeArr[1].lowercased()
                    let scaleType = scaleTypeArr[2].lowercased()
                    var scale = WriteScales(style: scaleType.lowercased())
                    let scaleInfo = scale.ScaleNotes(startingNote: startingNote, octave: musicNotes.octaves, tonality: tonality) // Change later
                    
                    if (isPlaying) {
                        Sound.enabled = false
                        isPlaying = false
                        playScale.cancelAllSounds()
                    } else {
                        Sound.enabled = true
                        if (drone) {
                            let duration = CGFloat(60/Int(self.musicNotes.tempo) * scaleInfo.count)
                            playScale.playDroneSound(duration: duration, startingNote: startingNote)
                        }
                        if (scaleNotes) {
                            playScale.playScaleSounds(temp: Int(self.musicNotes.tempo), scaleInfoArra: scaleInfo)
                        }
                        
                        isPlaying = true
                    }
                } label: {
                    if isPlaying {
                        MainUIButton(buttonText: "Stop SystemImage speaker.slash", type: 1, height: buttonHeight)
                    } else {
                        MainUIButton(buttonText: "Play SystemImage speaker.wave.3", type: 1, height: buttonHeight)
                    }
                }.padding( .top )

                Divider().background(Color.white)
                
                Group {
                    MainUIButton(buttonText: "Number of Octaves = " + String(musicNotes.octaves), type: 1, height: buttonHeight)
                
                    Section {
                        Picker("Octave selection", selection: $musicNotes.octaves) {
                            Text("One").tag(1)
                            Text("Two").tag(2)
                            Text("Three").tag(3)
                        }
                        .padding(.horizontal)
                        .pickerStyle( .segmented)
                        .colorScheme(.dark)
                    }
                    Divider().background(Color.white)
                }
            
                // The tempo buttons
                Group {
                    ZStack {
                        MainUIButton(buttonText: "Tempo = " + String(Int(musicNotes.tempo)), type: 1, height: buttonHeight)
//                        HStack {
//                            Stepper("", value: $musicNotes.tempo)
//                                .colorScheme(.light)
//                                .padding(.horizontal)
//                        }
                    }
                    Slider(value: $musicNotes.tempo, in: 40...180, step: 1.0)
                        .padding(.horizontal)
                    Divider().background(Color.white)
                }
                
                Group {
                    Button {
                        if (!chords) {
                            drone.toggle()
                        }
                    } label: {
                        HStack {
                            if (drone) {
                                MainUIButton(buttonText: "Drone SystemImage checkmark.square", type: 1, height: buttonHeight)
                            } else {
                                if (chords) {
                                    MainUIButton(buttonText: "Drone SystemImage square", type: 1, height: buttonHeight).blur(radius: 1)
                                } else {
                                    MainUIButton(buttonText: "Drone SystemImage square", type: 1, height: buttonHeight)
                                }
                            }
                        }
                    }
                    
                    Button {
                        if (!drone) {
                            chords.toggle()
                        }
                    } label: {
                        HStack {
                            if (chords) {
                                MainUIButton(buttonText: "Chords SystemImage checkmark.square", type: 1, height: buttonHeight)
                            } else {
                                if (drone) {
                                    MainUIButton(buttonText: "Chords SystemImage square", type: 1, height: buttonHeight).blur(radius: 1)
                                } else {
                                    MainUIButton(buttonText: "Chords SystemImage square", type: 1, height: buttonHeight)
                                }
                            }
                        }
                    }
                    
                    Button {
                        scaleNotes.toggle()
                    } label: {
                        HStack {
                            if (scaleNotes) {
                                MainUIButton(buttonText: "Notes SystemImage checkmark.square", type: 1, height: buttonHeight)
                            } else {
                                MainUIButton(buttonText: "Notes SystemImage square", type: 1, height: buttonHeight)
                            }
                        }
                    }
                }
                
                Spacer()
                Spacer()
                let bottumButtonHeight = universalSize.height/10
                Button {
                    self.screenType = musicNotes.type
                } label: {
                    MainUIButton(buttonText: musicNotes.type, type: 3, height: bottumButtonHeight)
                }
            }
        }
    }
}
