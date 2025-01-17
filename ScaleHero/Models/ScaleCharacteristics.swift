//
//  Scale.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/1/22.
//

import Foundation

/**
 This is used to save the scales as a JSON dictionary value to be read and written to in the favourites page
 
 Further possible updates:
    - Have a edit button for the characteristics.
    - Have a play through option of all scales in favourites
 */
struct ScaleCharacteristics: Identifiable, Equatable, Codable {
    var id: UUID
    let tonality: Case
    let tempo: Int
    let startingOctave: OctaveNumber
    let numOctave: OctaveNumber
    let tonicSelection: TonicOption
    let scaleNotes: Bool
    let drone: Bool
    let scaleDescription: String
    let startingNote: String
    let noteDisplay: Int
    let endlessLoop: Bool
    let intervalType: IntervalOption
    let intervalOption: Interval
}
