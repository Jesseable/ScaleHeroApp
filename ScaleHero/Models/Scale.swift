//
//  Scale.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/1/22.
//

import Foundation

struct Scale: Identifiable, Codable, Equatable {
    var id: UUID
    let scaleInfo: String
    let tonality: String
    let type: String
    let tempo: Int
    let startingOctave: Int
    let numOctave: Int
    let tonicSelection: Int
    let scaleNotes: Bool
    let drone: Bool
    let scaleDescription: String
    let startingNote: String
}
