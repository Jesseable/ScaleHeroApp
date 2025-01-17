//
//  ArpeggioArrays.swift
//  ScaleHero
//
//  Created by Jesse Graf on 25/6/2022.
//

import Foundation

struct ArpeggioArray: NoteArrayBase {
    let id: UUID
    let note: Notes
    let major: [Notes]
    let minor: [Notes]
    let dominant7th: [Notes]
    let diminished7th: [Notes]
    let major7th: [Notes]
    let minor7th: [Notes]
}
