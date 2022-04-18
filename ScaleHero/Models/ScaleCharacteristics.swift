//
//  Scale.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/1/22.
//

import Foundation

/**
 This is used to save the scales as a JSON dictionary value to be read and written to in the favourites page
 */
struct ScaleCharacteristics: Identifiable, Codable, Equatable {
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
    let noteDisplay: Int
    let endlessLoop: Bool
}
