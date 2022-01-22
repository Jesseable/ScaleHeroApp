//
//  FavouritesView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesView: View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    var backgroundImage: String
    @State private var isPresented = false
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        let contentAdded = false

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text("Favourites")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                ScrollView {
                    if (!contentAdded) {
                        Button {
                            isPresented = true
                        } label: {
                            MainUIButton(buttonText: "Add your first scale", type: 1, height: buttonHeight)
                        }
                    }
                }
                Spacer()
                
                Button {
                    self.screenType = "homepage"
                } label: {
                    MainUIButton(buttonText: "Home Page", type: 3, height: buttonHeight)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .sheet(isPresented: $isPresented) {
            FavouritesInfoView(backgroundImage: backgroundImage)
        }
    }
}
//
//struct FavouritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavouritesView()
//    }
//}
