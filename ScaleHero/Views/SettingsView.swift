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
    private let scaleInstruments = ["Cello", "Jesse's Vocals"]
    // These are also on contentView
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    @State var instrumentSelected : String
    @State var backgroundColour : String

    
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
                    
                    MainUIButton(buttonText: "Background:", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("ScaleNote Selection", selection: $backgroundColour) {
                                ForEach(backgrounds, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle( .segmented)
                            .colorScheme(.light)
                            .padding(.horizontal, 11)
                        }
                    }
                
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
                    
                    Menu {
                        Button("NewInstru") {
                        }
                        
                        Button("LookAt This one") {
                        }
                    } label: {
                        MainUIButton(buttonText: "DroneNote: ", type: 1, height: buttonHeight)
                    }.menuStyle( .borderlessButton)
                    
                    Button {
                        for scaleInstrument in scaleInstruments {
                            if (instrumentSelected == scaleInstrument) {
                                fileReaderAndWriter.writeScaleInstrument(newInstrument: scaleInstrument)
                            }
                        }
                        
                        for background in backgrounds {
                            if (backgroundColour == background) {
                                fileReaderAndWriter.writeBackgroundImage(newImage: background)
                                musicNotes.backgroundImage = "Background" + background
                            }
                        }
                    } label: {
                        MainUIButton(buttonText: "Apply", type: 1, height: buttonHeight)
                    }
                }
                    
                Spacer()

                Button {
                    self.screenType = "HomeScreen"
                } label: {
                    MainUIButton(buttonText: "HomeScreen", type: 3, height: bottumButtonHeight)
                }
            }
        }
    }
}
