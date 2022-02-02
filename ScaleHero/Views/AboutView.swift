//
//  AboutView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI

struct AboutView: View {
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    var backgroundImage: String
    @State private var isPresented1 = false
    @State private var isPresented2 = false
    @State private var isPresented3 = false
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var body: some View {
        let buttonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
//                Text("About")
//                            .font(.largeTitle.bold())
//                            .accessibilityAddTraits(.isHeader)
//                            .foregroundColor(Color.white)
//                            .multilineTextAlignment(.center)
                
                ScrollView {
                    
                    Button {
                        self.screenType = "settings"
                    } label: {
                        MainUIButton(buttonText: "Settings", type: 1, height: buttonHeight)
                    }

                    Button {
                        isPresented1 = true
                    } label: {
                        MainUIButton(buttonText: "Acknowledgments", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        isPresented2 = true
                    } label: {
                        MainUIButton(buttonText: "Tutorial", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        isPresented3 = true
                    } label: {
                        MainUIButton(buttonText: "About", type: 1, height: buttonHeight)
                    }
                }
                Spacer()
                
                Button {
                    self.screenType = "homepage"
                } label: {
                    MainUIButton(buttonText: "Home Page", type: 3, height: buttonHeight)
                }
            }.padding(.top, 50)
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .sheet(isPresented: $isPresented1) {
            AcknowledgementsView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
        .sheet(isPresented: $isPresented2) {
            TutorialView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
        .sheet(isPresented: $isPresented3) {
            AboutDeveloperView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
    }
}
