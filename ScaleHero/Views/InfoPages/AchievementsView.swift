//
//  AchievementsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 5/7/2022.
//

import SwiftUI

struct AchievementsView: View {
    @Binding var screenType: ScreenType
    var backgroundImage: String
    
    var fileReaderAndWriter = FileReaderAndWriter()
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    
    var body: some View {
        VStack {
            Text("ACHIEVEMENTS").asTitle()
            // Show Achievements Here
            Spacer()
            Button {
                musicNotes.backDisplay = .noteSelection
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: universalSize.height / 10)
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
}
