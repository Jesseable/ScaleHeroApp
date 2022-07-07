//
//  AchievementsCount.swift
//  ScaleHero
//
//  Created by Jesse Graf on 6/7/2022.
//

import Foundation

struct AchievementsCount: Identifiable, Codable {
    let id: UUID
    let note: String
    var major: [Int] // Var from here on to be able to change them
    var naturalMinor: [Int]
    var harmonicMinor: [Int]
    var melodicMinor: [Int]
    var chromatic: [Int]
    var pentatonic: [Int]
    var blues: [Int]
    var majorArpeggio: [Int]
    var minorArpeggio: [Int]
    var dominant7th: [Int]
    var diminished7th: [Int]
    var major7th: [Int]
    var minor7th: [Int]
    var wholeTone: [Int]
}
