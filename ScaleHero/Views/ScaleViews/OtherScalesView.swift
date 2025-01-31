//
//  SpecialView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 3/1/22.
//

import SwiftUI

/**
 Creates the view for all of the special cases inside of scales and arpeggios. Such as chromatic scales, tetrads, modes ect
 */
struct OtherScalesView: View {
    
    @Binding var screenType: ScreenType
    @State var displayType: OtherScaleTypes
    @EnvironmentObject var musicNotes: MusicNotes

    var backgroundImage: String
    
    var body: some View {
        
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                Text(displayType.rawValue.uppercased()).asTitle()
                
                TonicNoteDisplay(buttonHeight: buttonHeight, buttonWidth: width)
                
                ScrollView {
                    getView(view: displayType, buttonHeight: buttonHeight, width: width)
                }
                Spacer()
                
                Button {
                    if (displayType == .tetrads) {
                        self.screenType = .arpeggio
                    } else {
                        self.screenType = .scale
                    }
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        }
    }
    
    @ViewBuilder func getView(view: OtherScaleTypes, buttonHeight: CGFloat, width: CGFloat) -> some View {
        switch view {
        case .majorModes: // All Major Modes
            ForEach (MajorScaleMode.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .major(mode: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    MainUIButton(buttonText: mode.name, type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
        case .pentatonicModes: // All pentatonic modes
            ForEach (PentatonicScaleMode.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .pentatonic(mode: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    MainUIButton(buttonText: mode.name, type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
        case .special: // Can go to pentatonic modes screen and contains all chromatic scale alterations and blues scale
            ForEach (ChromaticAlteration.allCases, id: \.self) { mode in
                Button {
                    musicNotes.tonality = .scale(tonality: .chromatic(alteration: mode))
                    musicNotes.backDisplay = .otherview
                    self.screenType = .soundview
                } label: {
                    MainUIButton(buttonText: mode.name, type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
            Button {
                musicNotes.tonality = .scale(tonality: .blues)
                musicNotes.backDisplay = .otherview
                self.screenType = .soundview
            } label: {
                let name = ScaleTonality.blues.name
                MainUIButton(buttonText: name, type: 1, height: buttonHeight, buttonWidth: width)
            }
        case .tetrads: // Lists all of the 7th scales
            ForEach (ArpeggioTonality.allCases, id: \.self) { mode in
                if (mode != .major || mode != .minor) { // TODO: THis is messy. It would be better to do this with a 
                    Button {
                        musicNotes.tonality = .arpeggio(tonality: mode)
                        musicNotes.backDisplay = .otherview
                        self.screenType = .soundview
                    } label: {
                        MainUIButton(buttonText: mode.name, type: 1, height: buttonHeight, buttonWidth: width)
                    }
                }
            }
        }
    }
}
