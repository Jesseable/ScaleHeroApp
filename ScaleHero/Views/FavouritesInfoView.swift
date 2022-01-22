//
//  FavouritesInfoView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesInfoView: View {
    
    var backgroundImage: String
    
    var body: some View {

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text("Favourites Info")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                
                Divider().background(Color.white)
                
                Text("**Add To Favourites Page:**")
                    .font(.title2)
                    .foregroundColor(Color.white)
                
                Text(infoText())
                    .font(.title3)
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
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
}
//
//struct FavouritesInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouritesInfoView()
//    }
//}
