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
    
    @Binding var screenType: String
    @State var scaleType: String
    @State private var isPlaying = false
    @State private var presentAlert = false
    @State private var disableOctaveSelection = false
    @State var playScale = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var backgroundImage: String
    
    var body: some View {
        let title = scaleType
        let buttonHeight = universalSize.height/17
        let bottumButtonHeight = universalSize.height/10
        let maxFavourites = 7
        var disableOctaveSelection = (musicNotes.octaves < 2) ? false : true

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text(musicNotes.getMusicTitile(from: title)).asTitle()
                
                // You will have to add a stop sound function here as well to stop the scale when going out of the scale view
                Button {
                    if (musicNotes.isFavouriteScale) {
                        self.screenType = "favouritesview"
                        musicNotes.isFavouriteScale.toggle()
                    } else {
                        switch musicNotes.type.lowercased() {
                        case "mode":
                            musicNotes.type = "Major Scale Modes"
                            self.screenType = "otherview"
                        case "chromatic-scale", "whole-tone-scale", "major-pentatonic-scale", "minor-pentatonic-scale", "blues-scale":
                            musicNotes.type = "special"
                            self.screenType = "otherview"
                        case "harmonic","melodic":
                            self.screenType = "scale"
                        case "dominant-seventh", "major-seventh", "minor-seventh", "diminished-seventh":
                            musicNotes.type = "Tetrads"
                            self.screenType = "otherview"
                        case "pentatonic", "":
                            self.screenType = "abstractview"
                        default:
                            self.screenType = musicNotes.type
                        }
                    }
                } label: {
                    MainUIButton(buttonText: "Back", type: 9, height: bottumButtonHeight)
                }
                ScrollView {

                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Number of Octaves:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Octave selection", selection: $musicNotes.octaves) {
                                    Text("1").tag(1)
                                    Text("2").tag(2)
                                    Text("3").font(.title).tag(3)
                                }
                                .padding(.horizontal)
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }.onChange(of: musicNotes.octaves) { octave in
                            if (octave == 1) {
                                disableOctaveSelection = false
                            }
                        }
                        
                        Divider().background(Color.white)
                        
                        MainUIButton(buttonText: "Starting Octaves:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Octave:", selection: $musicNotes.startingOctave) {
                                    Text("1").tag(1)
                                    Text("2").tag(2)
                                    Text("3").tag(3)
                                }
                                .padding(.horizontal)
                                .pickerStyle( .segmented)
                                .colorScheme(.light) 
                                .padding(.horizontal, 11)
                                .disabled(disableOctaveSelection)
                            }
                        }.onChange(of: musicNotes.octaves) { octave in
                            if (octave > 1) {
                                musicNotes.startingOctave = 1
                                disableOctaveSelection = true
                            }
                        }
                        
                        Divider().background(Color.white)
                
                        MainUIButton(buttonText: "Tempo = " + String(Int(musicNotes.tempo)), type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Slider(value: $musicNotes.tempo, in: 20...180, step: 1.0)
                                .padding(.horizontal)
                        }
                        
                        Divider().background(Color.white)

                        HStack {

                            Button {
                                musicNotes.playDrone.toggle()
                            } label: {
                                if (musicNotes.playDrone) {
                                    MainUIButton(buttonText: "Drone SystemImage checkmark.square", type: 6, height: buttonHeight)
                                } else {
                                    MainUIButton(buttonText: "Drone SystemImage square", type: 6, height: buttonHeight)
                                }
                            }
                            
                            Button {
                                musicNotes.playScaleNotes.toggle()
                            } label: {
                                if (musicNotes.playScaleNotes) {
                                    MainUIButton(buttonText: "Play Notes SystemImage checkmark.square", type: 5, height: buttonHeight)
                                } else {
                                    MainUIButton(buttonText: "Play Notes SystemImage square", type: 5, height: buttonHeight)
                                }
                            }
                        }
                    }
                    Group {
                        HStack {
                            Button {
                                musicNotes.metronome.toggle()
                            } label: {
                                if (musicNotes.metronome) {
                                    MainUIButton(buttonText: "Metronome SystemImage checkmark.square", type: 6, height: buttonHeight)
                                } else {
                                    MainUIButton(buttonText: "Metronome SystemImage square", type: 6, height: buttonHeight)
                                }
                            }
                            
                            Button {
                                musicNotes.repeatNotes.toggle()
                            } label: {
                                if (musicNotes.repeatNotes) {
                                    MainUIButton(buttonText: "Repeat Notes SystemImage checkmark.square", type: 5, height: buttonHeight)
                                } else {
                                    MainUIButton(buttonText: "Repeat Notes SystemImage square", type: 5, height: buttonHeight)
                                }
                            }
                        }
                        Button {
                            musicNotes.endlessLoop.toggle()
                        } label: {
                            if (musicNotes.endlessLoop) {
                                MainUIButton(buttonText: "Endless Loop SystemImage checkmark.square", type: 1, height: buttonHeight)
                            } else {
                                MainUIButton(buttonText: "Endless Loop SystemImage square", type: 1, height: buttonHeight)
                            }
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Repeat Tonics", type: 4, height: buttonHeight) // Make a new UI button colour for the ones pickers are on
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Tonic selection", selection: $musicNotes.tonicMode) {
                                    Text("Never").tag(1)
                                    Text("All").tag(2)
                                    Text("Not Initial").tag(3)
                                }
                                .padding(.horizontal)
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Note Display", type: 4, height: buttonHeight) // Make a new UI button colour for the ones pickers are on
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Sharps or Flats", selection: $musicNotes.noteDisplay) {
                                    Image("Sharp").tag(1)
                                    Text("Automatic").tag(2)
                                    Image("Flat").tag(3)
                                }
                                .padding(.horizontal)
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Button {
                        presentAlert = true
                    } label: {
                        MainUIButton(buttonText: "Save", type: 1, height: buttonHeight)
                    }
                    
                    Spacer()
                }
                Button {
                    let scaleTypeArr = scaleType.components(separatedBy: " ")
                    let startingNote = scaleTypeArr[0]
                    let tonality = scaleTypeArr[1].lowercased()
                    let scaleType = scaleTypeArr[2].lowercased()
                    var scale = WriteScales(type: scaleType.lowercased())
                    let scaleInfo = scale.ScaleNotes(startingNote: startingNote,
                                                     octave: musicNotes.octaves,
                                                     tonality: tonality,
                                                     tonicOption: musicNotes.tonicMode,
                                                     startingOctave: musicNotes.startingOctave)
                    let scaleSoundFiles = playScale.convertToSoundFile(scaleInfoArray: scaleInfo, tempo: Int(musicNotes.tempo))
                    let delay = CGFloat(60/musicNotes.tempo)
                    musicNotes.scaleNotes = scaleSoundFiles
                    musicNotes.scaleNoteNames = playScale.convertToSoundFile(scaleInfoArray: scale.getScaleNoteNames(), tempo: Int(musicNotes.tempo))
                    
                    // Could add in quavers?
                    switch fileReaderAndWriter.readMetronomePulse().lowercased() {
                    case "simple":
                        musicNotes.metronomePulse = 4
                    case "compound":
                        musicNotes.metronomePulse = 3
                    case "off":
                        musicNotes.metronomePulse = 1
                    default:
                        musicNotes.metronomePulse = 1
                    }
                    // This line of code sets at what tempo when the metronome off beat pulses will not play
                    if (musicNotes.tempo >= 70 || !musicNotes.metronome) {
                        musicNotes.metronomePulse = 1
                    }
                    musicNotes.timer = Timer.publish(every: delay/CGFloat(musicNotes.metronomePulse), on: .main, in: .common).autoconnect()
                    musicNotes.noteName = startingNote
                
                    isPlaying = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        musicNotes.dismissable = true
                    }
                } label: {
                    MainUIButton(buttonText: "Play SystemImage speaker.wave.3", type: 3, height: buttonHeight*2)
                }
            }
            .alert(isPresented: $presentAlert) {
                Alert(
                    title: Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save To Favourites": " You have too many favourites. Delete One First"),
                    message: Text(title),
                    primaryButton: .default(Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save": "Go to favourites Page"), action: {
                        
                        if (fileReaderAndWriter.scales.count < maxFavourites) {
                            
                            fileReaderAndWriter.add(scaleInfo: scaleType,
                                                    tonality: musicNotes.tonality,
                                                    type: musicNotes.type,
                                                    tempo: Int(musicNotes.tempo),
                                                    startingOctave: musicNotes.startingOctave,
                                                    numOctave: musicNotes.octaves,
                                                    tonicSelection: musicNotes.tonicMode,
                                                    scaleNotes: musicNotes.playScaleNotes,
                                                    drone: musicNotes.playDrone,
                                                    startingNote: musicNotes.noteName,
                                                    noteDisplay: musicNotes.noteDisplay,
                                                    endlessLoop: musicNotes.endlessLoop)
                        
                        }
                        // Goes to the favourites screen
                        self.screenType = "favouritesview"
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: { /*Do Nothing*/ })
                )
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .fullScreenCover(isPresented: $isPlaying) {
            PlayingView(backgroundImage: backgroundImage,
                        scaleType: scaleType,
                        playScaleNotes: musicNotes.playScaleNotes,
                        playDrone: musicNotes.playDrone,
                        playSounds: playScale,
                        title: title,
                        currentNote: musicNotes.noteName,
                        repeatNotes: musicNotes.repeatNotes,
                        repeatingEndlessly: musicNotes.endlessLoop)
        }
    }
}
