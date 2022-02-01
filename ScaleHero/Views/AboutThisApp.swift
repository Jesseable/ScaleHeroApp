//
//  AboutThisApp.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI

struct AboutThisApp: View {
    
    var backgroundImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fileReaderAndWriter : FileReaderAndWriter
    
    var body: some View {

        ZStack {
            Color(fileReaderAndWriter.readBackgroundImage())
                .ignoresSafeArea()

            VStack {
                    ScrollView {
                        Text("App Info")
                                    .font(.largeTitle.bold())
                                    .accessibilityAddTraits(.isHeader)
                                    .foregroundColor(Color.white)
                                    .padding()
                        
                        Divider().background(Color.white)
                        
                        Group {
                            Text("**Cello Drone Sound Files:**")
                                .font(.title2)
                                .foregroundColor(Color.white)
                                .padding(5)
                            
                            Text(musician47Info())
                                .font(.title3)
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                youtubeLink()
                            } label: {
                                MainUIButton(buttonText: "Musician 47 Link", type: 9, height: UIScreen.main.bounds.height/20)
                            }
                        }
                        
                        Divider().background(Color.white)
                        
                        Text("**Image Designer:**")
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .padding(5)
                        
                        Text(designerInfoText())
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: UIScreen.main.bounds.height/10)
                }
            }
        }
    }
    
    func musician47Info() -> String {
        let text = """
        The Cello Drone Files were downloaded from 'Musician 47' on youtube
        You can access these wonderful sound files on YouTube through this link:
        """
        return text
    }
    
    func youtubeLink() {
        if let url = URL(string: "https://www.youtube.com/channel/UCroo7Q3k4YH_xcwWuxynf5g?app=desktop") {
            UIApplication.shared.open(url)
        }
    }
    
    func designerInfoText() -> String {
        let text = """
        All images were designed by my close friend Jyllianne
        A huge thanks for all of her help!
        """
        return text
    }
}
