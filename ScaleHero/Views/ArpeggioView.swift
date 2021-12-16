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
        
        NavigationView {
        
            ZStack {
                Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
            
                VStack {
                    //Text("ARPEGGIOS").bold().font(.title).foregroundColor(.white).padding()
                    
                    Spacer()
                    
                    // Turn to image button
                    Button("Major (Triad)") {
                        // do nothing
                    }.padding()
                    
                    // Turn to image button
                    Button("Minor (Triad)") {
                        // do nothing
                    }.padding()
                    
                    // Turn to image button
                    Button("Special (Tetrads)") {
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
