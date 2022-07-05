//
//  ArpeggioView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/21.
//

import SwiftUI

/**
 View for selecting arpeggios and tetrads. Set up the same as the scalesView
 */
struct ArpeggioView : View {

    @EnvironmentObject var musicNotes: MusicNotes
    
    @Binding var screenType: ScreenType
    let universalSize = UIScreen.main.bounds
    var backgroundImage: String
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
        
            VStack {
                
                Text("ARPEGGIOS").asTitle()
                
                TonicNoteDisplay(buttonHeight: buttonHeight)
                
                ScrollView {
                    
                    Button {
                        musicNotes.tonality = Case.arpeggio(tonality: .major)
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Major (Triad)", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.tonality = Case.arpeggio(tonality: .minor)
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Minor (Triad)", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        musicNotes.otherSpecificScaleTypes = .tetrads
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "7th's (Tetrads)", type: 1, height: buttonHeight)
                    }
                }
                
                Spacer()
                
                Button {
                    musicNotes.backDisplay = .homepage
                    self.screenType = musicNotes.backDisplay
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
                }
            }
        }
    }
}
