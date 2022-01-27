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

        ZStack {
            Color(fileReaderAndWriter.readBackgroundImage())
                .ignoresSafeArea()

            VStack {
                    ScrollView {
                        Text("Favourites Info")
                                    .font(.largeTitle.bold())
                                    .accessibilityAddTraits(.isHeader)
                                    .foregroundColor(Color.white)
                                    .padding()
                        
                        Divider().background(Color.white)
                        
                        Text("**Adding to Favourites Page:**")
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .padding(5)
                        
                        Text(infoText())
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().background(Color.white)
                        
                        
                        Text("**Deleting from Favourites Page:**")
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
                    MainUIButton(buttonText: "Back", type: 3, height: UIScreen.main.bounds.height/10)
                }
            }
        }
    }
    
    func infoText() -> String {
        let text = """
        1. Select a scale and adjust characteristics to your satisfaction
        2. Scroll down to the 'Save' button
        3. Press and confirm
        4. Congradulations! You have saved the scale
        """
        return text
    }
    
    func deletionInfoText() -> String {
        let text = """
        1. Select the deletion button
        2. All buttons will turn red
        3. Click on the scale to delete
        4. Congradulations! This scale is now deleted
        """
        return text
    }
}
//
//struct FavouritesInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouritesInfoView()
//    }
//}
