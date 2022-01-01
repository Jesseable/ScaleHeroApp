//
//  SettingsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 27/12/21.
//

import SwiftUI

struct SettingsView: View {
    
    let universalSize = UIScreen.main.bounds
    @Binding var screenType: String
    var backgroundImage: String
    let manager = FileManager.default
    var fileReaderAndWriter = FileReaderAndWriter()
    @State var instrument : String?
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
                VStack {
                    
                    Spacer()
                    
                    // Works perfectly
                    Menu ("Scale Note Instrument: " + (instrument ?? fileReaderAndWriter.readScaleInstrument())) {
                        Button("Cello") {
//                            fileReaderAndWriter.createFile()
                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Cello")
                            instrument = fileReaderAndWriter.readScaleInstrument()
                            print(instrument)
                        }
                        
                        Button("Jesse's Vocals") {
                            fileReaderAndWriter.writeScaleInstrument(newInstrument: "Jesse's Vocals")
                            instrument = fileReaderAndWriter.readScaleInstrument()
                            print(instrument)
                        }
                    }
                    
                    Spacer()
                    Button {
                        self.screenType = "homePage"
                    } label: {
                        Text("HomePage")
                    }.padding()
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
