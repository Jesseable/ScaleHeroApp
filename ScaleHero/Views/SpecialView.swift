//
//  SpecialView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 3/1/22.
//

import SwiftUI

struct SpecialView: View {
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: String
    @State var specialTitle: String
    @EnvironmentObject var musicNotes: MusicNotes
    private let modes = ["Lydian", "Ionian", "Mixolydian", "Dorian", "Aeolian", "Phrygian", "Locrian"]

    var backgroundImage: String
    
    var body: some View {
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                let buttonHeight = universalSize.height/10
                
                Text(specialTitle).bold().textCase(.uppercase).font(.title).foregroundColor(.white).scaledToFit()
                
                ScrollView {
                
                    if (specialTitle.lowercased() == "modes") {
                        ForEach(modes, id: \.self) { mode in
                            Button {
                                musicNotes.tonality = mode
                                musicNotes.type = "mode"
                                screenType = "soundview"
                            } label: {
                                MainUIButton(buttonText: mode, type: 1, height: buttonHeight)
                            }
                        }
                    }
                }
                Spacer()
                
                Button {
                    self.screenType = "scale"
                } label: {
                    MainUIButton(buttonText: "Scale", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
//
//struct SpecialView_Previews: PreviewProvider {
//
//    var screenType = "SpecialView"
//
//    static var previews: some View {
//        SpecialView(screenType: self.$screenType, specialTitle: "modes", backgroundImage: "BackgroundImage")
//    }
//}
