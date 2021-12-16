//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

struct ArpeggioView : View {
    
    let universalSize = UIScreen.main.bounds
    @State var noteName = "c"
    
    @Binding var screenType: String
    
    var body: some View {
        
        NavigationView {
        
            ZStack {
                Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
            
                VStack {
                    //Text("ARPEGGIOS").bold().font(.title).foregroundColor(.white).padding()
                    
                    Spacer()
                    
                    // Turn to image button
                    Button("Select Note") {
                        noteName = "d"
                    }.padding()
                    
                    // Turn to image button
                    NavigationLink(destination: SoundView(scaleType: noteName +  " Major arpeggio")) {
                        Text("Major (Triad)")
                    }.padding()
                    
                    // Turn to image button
                    Button("Minor (Triad)") {
                        // do nothing
                    }.padding()
                    
                    // Turn to image button
                    Button("Special (Tetrads)") {
                        // do nothing
                    }.padding()
                    
                    // Turn to image button
                    Button("Settings") {
                        // do nothing
                    }.padding()
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        self.screenType = "homePage"
                    } label: {
                        Text("HomePage")
                    }.padding()
                }
                .navigationBarTitle("ARPEGGIOS", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("ARPEGGIOS")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
    }
}
