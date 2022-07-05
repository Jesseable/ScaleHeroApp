//
//  TonicNoteView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 5/7/2022.
//

import SwiftUI

struct TonicNoteDisplay: View {
    @EnvironmentObject var musicNotes: MusicNotes
    let buttonHeight : CGFloat
    
    var body: some View {
        MainUIButton(buttonText: "Tonic: \(musicNotes.noteName) SystemImage music.note", type: 4, height: buttonHeight * 0.75)
    }
}
