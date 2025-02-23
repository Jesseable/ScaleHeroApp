//
//  ScaleArrays.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

struct ScaleArray: NoteArrayBase {
    let id: UUID
    let note: Notes
    let major: [Notes]
    let naturalMinor: [Notes]
    let harmonicMinor: [Notes]
    let melodicMinor: [Notes]
    let chromatic: [Notes]
    let pentatonic: [Notes]
    let blues: [Notes]
}
