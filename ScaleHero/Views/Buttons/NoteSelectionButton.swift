//
//  NoteSelectionButton.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/2/2022.
//

import SwiftUI

struct NoteSelectionButton: View {
    @EnvironmentObject var musicNotes: MusicNotes
    let buttonHeight : CGFloat
    
    var body: some View {
        Menu {
            ForEach(musicNotes.getMusicAlphabet(), id: \.self) { note in
                Button("Note: \(note)", action: {musicNotes.noteName = note})
            }
        } label: {
            MainUIButton(buttonText: "Note: \(musicNotes.noteName) SystemImage arrow.down.square", type: 9, height: buttonHeight)
        }.padding(.top)
    }
}
