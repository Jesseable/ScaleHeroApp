//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI
import SwiftySound

struct SoundView : View {
    
    let universalSize = UIScreen.main.bounds
    
    @State var scaleType: String
    
    var body: some View {
        
        ZStack {
            Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
        
            VStack {
                Text(scaleType).bold().textCase(.uppercase).font(.title).foregroundColor(.white).padding()
                Spacer()
                // Turn to image button
                Button("Play") {
                    // do nothing
                }.padding()
            }
        }
    }
}
