//
//  SettingsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 27/12/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    @Binding var screenType: String
    
    private let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    var fileReaderAndWriter = FileReaderAndWriter()
    // These are also on contentView
    private let scaleInstruments = ["Strings", "Piano", "Organ"]
    private let droneInstruments = ["Cello", "Tuning Fork"]
    private let transpositionModes = ["Notes", "Instrument"]
    private let metronomePulses = ["Compound", "Simple"]
    // These are also on contentView
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    @State var instrumentSelected : String
    @State var backgroundColour : String
    @State var transpositionMode : String
    @State var transposition : String
    @State var metronomePulseSelected : String
    @State var droneSelected : String
    
    var body: some View {
        let buttonHeight = universalSize.height/18
        let bottumButtonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            VStack {
                
                Text("SETTINGS")
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(Color.white)
                
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
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
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
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }.onChange(of: transpositionMode) { mode in /// COULD TRY TO CUSTOMISE MORE LATER ON
                            if (mode == "Notes") {
                                transposition = "C"
                            } else {
                                transposition = "Strings in C"
                            }
                        }
                        
                        Menu {
                            ForEach((transpositionMode == "Notes") ? musicNotes.getMusicAlphabet() :musicNotes.getInstrumentSelection() , id: \.self) { note in
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
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }
                        
                        Divider().background(Color.white)
                    }
                    
                    MainUIButton(buttonText: "Drone: ", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("DroneNote Selection", selection: $droneSelected) {
                                ForEach(droneInstruments, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle( .segmented)
                            .colorScheme(.light)
                            .padding(.horizontal, 11)
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Presentation Pulse:", type: 4, height: buttonHeight)
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                            Section {
                                Picker("Metronome Pulse Selection", selection: $metronomePulseSelected) {
                                    ForEach(metronomePulses, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle( .segmented)
                                .colorScheme(.light)
                                .padding(.horizontal, 11)
                            }
                        }
                        
                        Divider().background(Color.white)
                    }
                    
                    Button {
                        applyAll(scaleInstruments: scaleInstruments,
                                 backgrounds: backgrounds,
                                 transposition: transposition,
                                 metronomePulse: metronomePulseSelected,
                                 droneInstrument: droneSelected)

                    } label: {
                        MainUIButton(buttonText: "Apply SystemImage star.circle", type: 9, height: bottumButtonHeight)
                    }
                }
                    
                Spacer()

                Button {
                    // Applies changes when going back
                    applyAll(scaleInstruments: scaleInstruments,
                             backgrounds: backgrounds,
                             transposition: transposition,
                             metronomePulse: metronomePulseSelected,
                             droneInstrument: droneSelected)
                    
                    self.screenType = "aboutview"
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: bottumButtonHeight)
                }
            }
        }
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
    
    private func applyTransposition(transposition: String) {
        fileReaderAndWriter.writeNewTransposition(newTransposition: transposition)
        musicNotes.transposition = transposition
    }
    
    private func applyAll(scaleInstruments: [String], backgrounds: [String], transposition: String, metronomePulse: String, droneInstrument: String) {
        applyTransposition(transposition: transposition)
        applyBackground(backgrounds: backgrounds)
        applyScaleInstrument(scaleInstruments: scaleInstruments)
        applyMetronomePulse(for: metronomePulse)
        applyDroneInstrument(droneInstrument: droneInstrument)
    }
}
