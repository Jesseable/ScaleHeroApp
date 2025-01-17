//
//  Arpeggios.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

struct Arpeggios: NotesBase {
    let id: UUID
    let name: String
    let noteArray: [ArpeggioArray]
}
