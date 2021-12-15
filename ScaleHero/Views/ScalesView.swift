//
//  ScalesHView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI
import SwiftySound

struct ScalesView: View {
    
    @Binding var screenType: String
    
    var body: some View {
        VStack {
            
        Spacer()
            
        Text("Hello freaky world!")
        Text("You are signed in.")
            Button {
                Sound.enabled = true
                Sound.play(file: "small-loop.mp3", numberOfLoops: 1) // Test with a proper sound file
            } label: {
                Text("Sound")
            }
            
            Button {
                Sound.stopAll()
            } label: {
                Text("Stop")
            }
            
            Spacer()
            
            Button {
                self.screenType = "homePage"
            } label: {
                Text("Back")
            }.padding()
        }
    }
}
