//
//  FavouritesInfoView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesInfoView: View {
    
    var backgroundImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fileReaderAndWriter : FileReaderAndWriter
    
    var body: some View {
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                ScrollView {
                    Text("Favourites Info").asTitle()
                        .padding()
                    
                    Divider().background(Color.white)
                    
                    Text("**Adding To Favourites Page**")
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(5)
                    
                    Text(infoText())
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider().background(Color.white)
                    
                    
                    Text("**Deleting From Favourites Page:**")
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .padding(5)
                    
                    Text(deletionInfoText())
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Color(fileReaderAndWriter.readBackgroundImage()).ignoresSafeArea() }
        }
    }
    
    func infoText() -> String {
        let text = """
        1. Select a scale and adjust characteristics as desired
        2. Scroll down to the 'Save' button
        3. Press and confirm
        4. Congratulations! You have saved the scale
        """
        return text
    }
    
    func deletionInfoText() -> String {
        let text = """
        1. Select the delete button
        2. All buttons will turn red
        3. Click on the scale to delete
        4. Congratulations! This scale is now deleted
        """
        return text
    }
}
