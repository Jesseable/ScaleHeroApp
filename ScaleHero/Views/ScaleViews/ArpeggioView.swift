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
    var backgroundImage: String
    
    var body: some View {
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            VStack {
                
                Text("ARPEGGIOS").asTitle()
                
                TonicNoteDisplay(buttonHeight: buttonHeight, buttonWidth: width)
                
                ScrollView {
                    
                    Button {
                        musicNotes.tonality = Case.arpeggio(tonality: .major)
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Major (Triad)", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    Button {
                        musicNotes.tonality = Case.arpeggio(tonality: .minor)
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.soundview
                    } label: {
                        MainUIButton(buttonText: "Minor (Triad)", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                    
                    Button {
                        musicNotes.otherSpecificScaleTypes = .tetrads
                        musicNotes.backDisplay = .arpeggio
                        self.screenType = ScreenType.otherview
                    } label: {
                        MainUIButton(buttonText: "7th's (Tetrads)", type: 1, height: buttonHeight, buttonWidth: width)
                    }
                }
                
                Spacer()
                
                Button {
                    musicNotes.backDisplay = .homepage
                    self.screenType = musicNotes.backDisplay
                } label: {
                    MainUIButton(buttonText: "Back", type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        }
    }
}
