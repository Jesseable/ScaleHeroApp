//
//  AboutThisApp.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI

struct AcknowledgementsView: View {
    
    var backgroundImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fileReaderAndWriter : FileReaderAndWriter
    
    var body: some View {

        GeometryReader { geometry in
            let menuButtonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                ScrollView {
                    Text("Acknowledgements")
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
                            MainUIButton(buttonText: "Musician 47 Link", type: 9, height: UIScreen.main.bounds.height/20, buttonWidth: UIScreen.main.bounds.width)
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Text("**Graphic Designer:**")
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
                    MainUIButton(buttonText: "Back", type: 1, height: menuButtonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Color(fileReaderAndWriter.readBackgroundImage()).ignoresSafeArea() }
        }
    }
    
    func musician47Info() -> String {
        let text = """
        The Cello Drone Sound Files were downloaded from 'Musician 47' on YouTube.
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
        A huge thanks to my good friend J.C. for their help in the graphic design of this app, including the creation of all images and the app design.
        """
        return text
    }
}
