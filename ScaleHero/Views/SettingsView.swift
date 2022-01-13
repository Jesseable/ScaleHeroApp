//
//  SettingsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 27/12/21.
//

import SwiftUI

struct SettingsView: View { // MIGHT NEED AN APPLY BUTTON
    
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    @Binding var screenType: String
    var backgroundImage: String
    var fileReaderAndWriter = FileReaderAndWriter()
    private let scaleInstruments = ["Cello", "Jesse's Vocals"]
    private let backgrounds = ["Blue", "Green", "Purple", "Red", "Yellow"]
    //@State var instrument : String?
    @State var instrumentSelected : String
    @State var backgroundColour : String

    
    var body: some View {
        
        NavigationView {
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
                VStack {
                    let buttonHeight = universalSize.height/10
                    
                    MainUIButton(buttonText: "Background:", type: 4, height: buttonHeight)
                    
                    Section {
                        
                        Picker("ScaleNote Selection", selection: $backgroundColour) {
                            ForEach(backgrounds, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle( .segmented)
                        .colorScheme(.dark)
                    }
                
                    MainUIButton(buttonText: "Scale Instrument:", type: 4, height: buttonHeight)
                    
                    Section {
                        
                        Picker("ScaleNote Selection", selection: $instrumentSelected) {
                            ForEach(scaleInstruments, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle( .segmented)
                        .colorScheme(.dark)
                    }
                    
                    Menu {
                        Button("NewInstru") {
//                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Cello")
//                            instrument = fileReaderAndWriter.readScaleInstrument()
                        }
                        
                        Button("LookAt This one") {
//                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Jesse's Vocals")
//                            instrument = fileReaderAndWriter.readScaleInstrument()
                        }
                    } label: {
                        MainUIButton(buttonText: "DroneNote: ", type: 1, height: buttonHeight)
                    }.menuStyle( .borderlessButton)
                    
                    Menu {
                        Button("yeehaaa") {
//                            fileReaderAndWriter.createFile()
//                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Cello")
//                            instrument = fileReaderAndWriter.readScaleInstrument()
                        }
                        
                        Button("ddjbfdkjs") {
//                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Jesse's Vocals")
//                            instrument = fileReaderAndWriter.readScaleInstrument()
                        }
                    } label: {
                        MainUIButton(buttonText: "ChordsNote: ", type: 1, height: buttonHeight)
                    }.menuStyle( .borderlessButton)
                    
                    Spacer()

                    Button {
                        // To move to apply button
                        for scaleInstrument in scaleInstruments {
                            if (instrumentSelected == scaleInstrument) {
                                fileReaderAndWriter.writeScaleInstrument(newInstrument: scaleInstrument)
                                //instrument = fileReaderAndWriter.readScaleInstrument()
                            }
                        }
                        
                        for background in backgrounds {
                            if (backgroundColour == background) {
                                fileReaderAndWriter.writeBackgroundImage(newImage: background)
                                musicNotes.backgroundImage = "Background" + background
                            }
                        }
                        
                        self.screenType = "HomeScreen"
                    } label: {
                        MainUIButton(buttonText: "HomeScreen", type: 3, height: buttonHeight)
                    }
                }
                .navigationBarTitle("SETTINGS", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("SETTINGS")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
}
