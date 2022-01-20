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
        let title = scaleType
        let buttonHeight = universalSize.height/15
        let bottumButtonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text(musicNotes.getMusicTitile(from: title))
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                ScrollView {
                    
                    Button {
                        let scaleTypeArr = scaleType.components(separatedBy: " ")
                        let startingNote = scaleTypeArr[0]
                        let tonality = scaleTypeArr[1].lowercased()
                        let scaleType = scaleTypeArr[2].lowercased()
                        var scale = WriteScales(type: scaleType.lowercased())
                        let scaleInfo = scale.ScaleNotes(startingNote: startingNote, octave: musicNotes.octaves, tonality: tonality, tonicOption: musicNotes.tonicis)
                        let scaleSoundFiles = playScale.convertToSoundFile(scaleInfoArray: scaleInfo)
                        musicNotes.scaleNotes = scaleSoundFiles
                        
                        let delay = CGFloat(60/musicNotes.tempo)
                        musicNotes.noteName = startingNote
                        musicNotes.timer = Timer.publish(every: delay, on: .main, in: .common).autoconnect()

                        Sound.enabled = true
                        isPlaying = true
                        
                    } label: {
                        MainUIButton(buttonText: "Play SystemImage speaker.wave.3", type: 1, height: buttonHeight)
                    }

                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Number of Octaves:", type: 4, height: buttonHeight)
                    
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
                
                        MainUIButton(buttonText: "Tempo = " + String(Int(musicNotes.tempo)), type: 4, height: buttonHeight)
                        Slider(value: $musicNotes.tempo, in: 20...180, step: 1.0)
                            .padding(.horizontal)
                        Divider().background(Color.white)

                        // create a new mainUIbutton display to be half the width so you can fit both of these in a HStack !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        Button {
                            drone.toggle()
                        } label: {
                            HStack {
                                if (drone) {
                                    MainUIButton(buttonText: "Drone SystemImage checkmark.square", type: 1, height: buttonHeight)
                                } else {
                                    MainUIButton(buttonText: "Drone SystemImage square", type: 1, height: buttonHeight)
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
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Repeat Tonics", type: 4, height: buttonHeight) // Make a new UI button colour for the ones pickers are on
                        ZStack {
                            MainUIButton(buttonText: "", type: 4, height: buttonHeight)
                            Section {
                                Picker("Tonic selection", selection: $musicNotes.tonicis) {
                                    Text("Never").tag(1)
                                    Text("All").tag(2)
                                    Text("All/first").tag(3)
                                }
                                .padding(.horizontal)
                                .pickerStyle( .segmented)
                                .colorScheme(.dark)
                            }
                        }
                    }
                    Spacer()
                }
                
                // You will have to add a stop sound function here as well to stop the scale when going out of the scale view
                Button {
                    switch musicNotes.type.lowercased() {
                    case "mode":
                        musicNotes.type = "Major Scale Modes"
                        self.screenType = "specialview"
                    case "chromatic-scale", "whole-tone-scale":
                        musicNotes.type = "Special"
                        self.screenType = "specialview"
                    case "harmonic","melodic":
                        self.screenType = "scale"
                    case "dominant-seventh", "major-seventh", "minor-seventh", "diminished-seventh":
                        musicNotes.type = "tetrads"
                        self.screenType = "specialview"
                    case "pentatonic", "":
                        self.screenType = "abstractview"
                    default:
                        self.screenType = musicNotes.type
                    }
                } label: {
                    switch musicNotes.type.lowercased() {
                    case "mode":
                        MainUIButton(buttonText: "Modes", type: 3, height: bottumButtonHeight)
                    case "chromatic-scale", "whole-tone-scale":
                        MainUIButton(buttonText: "Special", type: 3, height: bottumButtonHeight)
                    case "harmonic","melodic":
                        MainUIButton(buttonText: "Scales", type: 3, height: bottumButtonHeight)
                    case "dominant-seventh", "major-seventh", "minor-seventh", "diminished-seventh":
                        MainUIButton(buttonText: "Tetrads", type: 3, height: bottumButtonHeight)
                    case "pentatonic", "":
                        MainUIButton(buttonText: "Abstract Scales", type: 3, height: bottumButtonHeight)
                    default:
                        MainUIButton(buttonText: musicNotes.type, type: 3, height: bottumButtonHeight)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPlaying) {
            PlayingView(backgroundImage: backgroundImage, scaleType: scaleType, playScaleNotes: scaleNotes, playDrone: drone, playSounds: playScale, title: title)
        }
    }
}
