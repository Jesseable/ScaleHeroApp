//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

struct ArpeggioView : View {
    
    let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    
    var body: some View {
        
        ZStack {
            Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
            
            VStack {
                
                Text("ARPEGGIOS").bold().font(.title).foregroundColor(.white).padding()
                
                Spacer()
                
                // Turn to image button
                Button("Select Note") {
                    self.screenType = "scales"
                }.padding()
                
                // Turn to image button
                Button("settings") {
                    // do nothing
                }.padding()
                
                // Turn to image button
                Button("Play") {
                    // do nothing
                }.padding()
                
                Spacer()
                Spacer()
                
                Button {
                    self.screenType = "homePage"
                } label: {
                    Text("Back")
                }.padding()

            }
        }
    }
}
