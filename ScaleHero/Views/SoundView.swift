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
        
        NavigationView {
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
                // Hidden and only activates when isPlaying is set
                NavigationLink(
                    "navLink",
                    destination: PlayingView(backgroundImage: backgroundImage, playSounds: playScale, scaleType: scaleType, title: title.replacingOccurrences(of: "-", with: " ")),
                    isActive: $isPlaying
                ).hidden().opacity(1.00) // Unseable CHNAGE TO SOMETHING ELSE
                VStack {
                    
                    //Text(title.replacingOccurrences(of: "-", with: " ")).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                    ScrollView {
                        
                        Button { /// YOU CAN DELETE A LOT OF THIS. GO THROUGH AND TIDY UP THE CODE
                            let scaleTypeArr = scaleType.components(separatedBy: " ")
                            let startingNote = scaleTypeArr[0]
                            let tonality = scaleTypeArr[1].lowercased()
                            let scaleType = scaleTypeArr[2].lowercased()
                            var scale = WriteScales(type: scaleType.lowercased())
                            let scaleInfo = scale.ScaleNotes(startingNote: startingNote, octave: musicNotes.octaves, tonality: tonality) // Change later
                            let scaleSoundFiles = playScale.convertToSoundFile(scaleInfoArray: scaleInfo)
                            musicNotes.scaleNotes = scaleSoundFiles
                            let delay = CGFloat(60/musicNotes.tempo)
                            musicNotes.timer = Timer.publish(every: delay, on: .main, in: .common).autoconnect()
                            musicNotes.currentNote = startingNote
                            
                            if (isPlaying) {
                                Sound.enabled = false
                                isPlaying = false
                                playScale.cancelAllSounds()
                            } else {
                                Sound.enabled = true
                                if (drone) { // CHANGE INTO THE PLAYSOUNDS VIEW
                                    let duration = CGFloat(60/Int(self.musicNotes.tempo) * scaleInfo.count)
                                    playScale.playDroneSound(duration: duration, startingNote: startingNote)
                                }
                                if (scaleNotes) {
                                    //playScale.playScaleSounds(temp: Int(self.musicNotes.tempo), scaleInfoArra: scaleInfo)
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
                    
                        // The tempo buttons
//                            ZStack {
                                MainUIButton(buttonText: "Tempo = " + String(Int(musicNotes.tempo)), type: 4, height: buttonHeight)
        //                        HStack {
        //                            Stepper("", value: $musicNotes.tempo)
        //                                .colorScheme(.light)
        //                                .padding(.horizontal)
        //                        }
//                            }
                            Slider(value: $musicNotes.tempo, in: 40...180, step: 1.0)
                                .padding(.horizontal)
                            Divider().background(Color.white)
                        }
                        
                        Group {
                            Button {
//                                if (!chords) {
                                    drone.toggle()
//                                }
                            } label: {
                                HStack {
                                    if (drone) {
                                        MainUIButton(buttonText: "Drone SystemImage checkmark.square", type: 1, height: buttonHeight)
                                    } else {
//                                        if (chords) {
//                                            MainUIButton(buttonText: "Drone SystemImage square", type: 1, height: buttonHeight).blur(radius: 1)
//                                        } else {
                                            MainUIButton(buttonText: "Drone SystemImage square", type: 1, height: buttonHeight)
//                                        }
                                    }
                                }
                            }
//
//                            Button {
//                                if (!drone) {
//                                    chords.toggle()
//                                }
//                            } label: {
//                                HStack {
//                                    if (chords) {
//                                        MainUIButton(buttonText: "Chords SystemImage checkmark.square", type: 1, height: buttonHeight)
//                                    } else {
//                                        if (drone) {
//                                            MainUIButton(buttonText: "Chords SystemImage square", type: 1, height: buttonHeight).blur(radius: 1)
//                                        } else {
//                                            MainUIButton(buttonText: "Chords SystemImage square", type: 1, height: buttonHeight)
//                                        }
//                                    }
//                                }
//                            }
                            
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
                    }
                    
                    let bottumButtonHeight = universalSize.height/10
                    
                    // You will have to add a stop sound function here as well to stop the scale when going out of the scale view
                    Button {
                        switch musicNotes.type.lowercased() {
                        case "mode":
                            musicNotes.type = "Modes"
                            self.screenType = "specialview"
                        case "chromatic-scale", "whole-tone-scale":
                            musicNotes.type = "Special"
                            self.screenType = "specialview"
                        case "harmonic","melodic":
                            self.screenType = "scale"
                        case "dominant-seventh", "major-seventh", "minor-seventh", "diminished-seventh":
                            musicNotes.type = "tetrads"
                            self.screenType = "specialview"
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
                        default:
                            MainUIButton(buttonText: musicNotes.type, type: 3, height: bottumButtonHeight)
                        }
                    }
                }
            }
            .navigationBarTitle(title.replacingOccurrences(of: "-", with: " "), displayMode: .inline)
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
