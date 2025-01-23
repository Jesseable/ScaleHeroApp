//
//  SettingsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 27/12/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    @Binding var screenType: ScreenType
    
    private let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    var fileReaderAndWriter = FileReaderAndWriter()
    // These are also on contentView
    private let scaleInstruments = ["Strings", "Piano", "Organ"]
    private let droneInstruments = ["Cello", "Tuning Fork"]
    private let transpositionModes = ["Notes", "Instrument"]
    private let metronomePulses = ["Compound", "Simple", "Off"]
    // These are also on contentView
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    private let introPulseOptions = ["1", "2", "3", "4", "5", "6", "7", "8"]
    private let musicNotesAlphabet = ["C", "G", "D", "A", "E", "B", "F#|Gb", "C#|Db", "G#|Ab", "D#|Eb", "A#|Bb", "F"]
    private let instrumentSelection = ["Bassoon in C", "Clarinet in Bb", "Clarinet in Eb", "Euphonium in C", "Horn in F", "Oboe in C", "Recorder in C", "Recorder in F", "Flute in C", "Saxophone in Bb", "Saxophone in Eb", "Strings in C", "Trombone in C", "Trumpet in Bb", "Tuba in F"]
    @State private var presentAlert = false
    @State var instrumentSelected : String
    @State var backgroundColour : String
    @State var transpositionMode : String
    @State var transposition : String
    @State var metronomePulseSelected : String
    @State var droneSelected : String
    @State var slowIntroBeatsSelected : String
    @State var fastIntroBeatsSelected : String
    
    var body: some View {
        let buttonHeight = universalSize.height/18
        let bottumButtonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            VStack {
                
                Text("SETTINGS").asTitle()
                
                ScrollView {
                    
                    Group {
                        MainUIButton(buttonText: "Background:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("ScaleNote Selection", selection: $backgroundColour) {
                                    ForEach(backgrounds, id: \.self) {
                                        Image($0)
                                    }
                                }
                                .formatted()
                            }
                        }
                        
                        Divider().background(Color.white)
                    }
                    
                    // Transposition buttons
                    Group {
                        MainUIButton(buttonText: "Transposition: ", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("ScaleNote Selection", selection: $transpositionMode) {
                                    ForEach(transpositionModes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }.onChange(of: transpositionMode) { mode in /// COULD TRY TO CUSTOMISE MORE LATER ON
                            if (mode == "Notes") {
                                transposition = "C"
                            } else {
                                transposition = "Strings in C"
                            }
                        }
                        
                        Menu {
                            ForEach((transpositionMode == "Notes") ? musicNotesAlphabet : instrumentSelection, id: \.self) { note in
                                Button("Note: \(note)", action: {transposition = note})
                            }
                        } label: {
                            MainUIButton(buttonText: (transpositionMode == "Notes") ? "Note: \(transposition)" : "Instrument: \(transposition)", type: 1, height: buttonHeight)
                        }
                        
                        Divider().background(Color.white)
                    }
                
                    Group {
                        MainUIButton(buttonText: "Scale Instrument:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("ScaleNote Selection", selection: $instrumentSelected) {
                                    ForEach(scaleInstruments, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }
                        
                        Divider().background(Color.white)
                    
                        MainUIButton(buttonText: "Drone: ", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("DroneNote Selection", selection: $droneSelected) {
                                    ForEach(droneInstruments, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Metronome:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Metronome Pulse Selection", selection: $metronomePulseSelected) {
                                    ForEach(metronomePulses, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }
                        
                        Divider().background(Color.white)
                    }
                    
                    Group {
                        MainUIButton(buttonText: "Intro Beats (<=70bpm):", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Metronome Count", selection: $slowIntroBeatsSelected) {
                                    ForEach(introPulseOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }
                        Divider().background(Color.white)
                    }

                    Group {
                        MainUIButton(buttonText: "Intro Beats (>70bpm):", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Metronome Count", selection: $fastIntroBeatsSelected) {
                                    ForEach(introPulseOptions, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .formatted()
                            }
                        }

                        Divider().background(Color.white)
                    }
                    
                    Group {
                        Button {
                            applyAll(scaleInstruments: scaleInstruments,
                                     backgrounds: backgrounds,
                                     transposition: transposition,
                                     metronomePulse: metronomePulseSelected,
                                     droneInstrument: droneSelected,
                                     fastBeats: fastIntroBeatsSelected,
                                     slowBeats: slowIntroBeatsSelected)

                        } label: {
                            MainUIButton(buttonText: "Apply SystemImage star.circle", type: 9, height: bottumButtonHeight)
                        }
                        
                        // ADD A DEFAULT BUTTON TO RESET TO DEFAULT ATTRIBUTES. MAKE SURE TO CONNECT THE VALUES USED IN CONTENT VIEW
                        Button {
                            presentAlert = true
                        } label: {
                            MainUIButton(buttonText: "Reset to Default", type: 9, height: bottumButtonHeight)
                        }
                    }
                }
                    
                Spacer()

                Button {
                    // Applies changes when going back
                    applyAll(scaleInstruments: scaleInstruments,
                             backgrounds: backgrounds,
                             transposition: transposition,
                             metronomePulse: metronomePulseSelected,
                             droneInstrument: droneSelected,
                             fastBeats: fastIntroBeatsSelected,
                             slowBeats: slowIntroBeatsSelected)
                    
                    self.screenType = .aboutview
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: bottumButtonHeight)
                }
            }
            .alert(isPresented: $presentAlert) {
                Alert(
                    title: Text("Reset to Default"),
                    message: Text("Are you sure?"),
                    primaryButton: .default(Text("Confirm"), action: {
                        
                        backgroundColour = "Purple"
                        instrumentSelected = "Piano"
                        transpositionMode = "Notes"
                        transposition = "C"
                        droneSelected = "Cello"
                        metronomePulseSelected = "Off"
                        slowIntroBeatsSelected = "2"
                        fastIntroBeatsSelected = "4"

                        applyAll(scaleInstruments: scaleInstruments,
                                 backgrounds: backgrounds,
                                 transposition: transposition,
                                 metronomePulse: metronomePulseSelected,
                                 droneInstrument: droneSelected,
                                 fastBeats: fastIntroBeatsSelected,
                                 slowBeats: slowIntroBeatsSelected)
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: { /*Do Nothing*/ })
                )
            }
        }
    }
    
    private func applyAll(scaleInstruments: [String],
                          backgrounds: [String],
                          transposition: String,
                          metronomePulse: String,
                          droneInstrument: String,
                          fastBeats: String,
                          slowBeats: String) {
        applyTransposition(transposition: transposition)
        applyBackground(backgrounds: backgrounds)
        applyScaleInstrument(scaleInstruments: scaleInstruments)
        applyMetronomePulse(for: metronomePulse)
        applyDroneInstrument(droneInstrument: droneInstrument)
        applyIntroBeats(fastBeats: fastBeats, slowBeats: slowBeats)
    }
    
    private func applyIntroBeats(fastBeats: String, slowBeats: String) {
        fileReaderAndWriter.writeIntroBeats(beats: "\(slowBeats)-\(fastBeats)")
    }
    
    private func applyScaleInstrument(scaleInstruments: [String]) {
        for scaleInstrument in scaleInstruments {
            if (instrumentSelected == scaleInstrument) {
                fileReaderAndWriter.writeScaleInstrument(newInstrument: scaleInstrument)
            }
        }
    }
    
    private func applyDroneInstrument(droneInstrument: String) {
        fileReaderAndWriter.writeDroneInstrument(newDrone: droneInstrument)
    }
    
    private func applyBackground(backgrounds: [String]) {
        for background in backgrounds {
            if (backgroundColour == background) {
                fileReaderAndWriter.writeBackgroundImage(newImage: background)
                musicNotes.backgroundImage = "Background" + background
            }
        }
    }
    
    private func applyMetronomePulse(for metronomePulse: String) {
        fileReaderAndWriter.writeNewMetronomePulse(newPulse: metronomePulse)
    }
    
    // TODO: Maybe change to a FileNote to be saved later on...
    private func applyTransposition(transposition: String) {
        fileReaderAndWriter.writeNewTransposition(newTransposition: transposition)
//        musicNotes.transposition = transposition
    }
}

/**
 Sets the text field requirements.
 */
extension Picker {
    func formatted() -> some View {
        pickerStyle( .segmented)
        .colorScheme(.light)
        .padding(.horizontal, 11)
    }
}
