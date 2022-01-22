//
//  FavouritesInfoView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesInfoView: View {
    
    var backgroundImage: String
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
                    
                    Divider().background(Color.white)
                    
                    Text("**Adding to Favourites Page:**")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    
                    Text(infoText())
                        .font(.title3)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                    
                        Divider().background(Color.white)
                        
                        Text("**Deleting from Favourites Page:**")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        
                        Text(deletionInfoText())
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                    }
                Spacer()
            }
        }
    }
    
    func infoText() -> String {
        let text = """
        1. Select a scale and adjust characteristics to your satisfaction
        2. Scroll down to 'Save' button
        3. Confirm
        4. The scale will now be saved
        """
        return text
    }
    
    func deletionInfoText() -> String {
        let text = """
        1. Select the deletion button
        2. All buttons will turn red
        3. Click on the scale button to delete
        4. The scale button has been deleted
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
