//
//  AboutDeveloperView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI

struct AboutDeveloperView: View {
    
    var backgroundImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fileReaderAndWriter : FileReaderAndWriter
    
    var body: some View {
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            VStack {
                ScrollView {
                    Text("Developer: Jesse Graf").asTitle()
                        .padding()
                    
                    Divider().background(Color.white)
                    
                    Text("**About the developer:**")
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(5)
                    
                    Text(advantagesText())
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Back", type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Color(fileReaderAndWriter.readBackgroundImage()).ignoresSafeArea() }
        }
    }

    func advantagesText() -> String {
        let text = """
        Jesse Graf is currently a student at the University of Queensland pursuing a double degree in engineering and the arts, majoring in programming, music and German.
        
        He plays the cello, piano and saxophone, and is a private music teacher who is always looking for ways to help his students' practice be more fun and productive.
        """
        return text
    }
}

