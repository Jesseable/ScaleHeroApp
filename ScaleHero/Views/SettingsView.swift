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
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Image(backgroundImage).resizable().ignoresSafeArea()
                VStack {
                    
                    // Create a button that reads from a text file and writes to one. 
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
