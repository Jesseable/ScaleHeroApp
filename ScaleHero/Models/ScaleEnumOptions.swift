//
//  ScaleEnumOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 26/6/2022.
//

import Foundation

enum ScreenType {
    case homepage
    case arpeggio
    case scale
    case otherview
    case settings
    case soundview
    case droneview
    case favouritesview
    case aboutview
    case noteSelection
    case achievements
    case soundOptionsView
}

enum TonicOption : Equatable, Codable {
    case noRepeatedTonic
    case repeatedTonicAll
    case repeatedTonic
}

// The int is the rotations in the major scale it must undertake
enum MajorScaleMode : Int, CaseIterable, Equatable, Codable {
    case ionian = 0
    case dorian = 1
    case phrygian = 2
    case lydian = 3
    case mixolydian = 4
    case aeolian = 5
    case locrian = 6
}

enum Case : Codable {
    case arpeggio(tonality: ArpeggioTonality)
    case scale(tonality: ScaleTonality)
}

extension Case : Equatable {
    static func == (lhs: Case, rhs: Case) -> Bool {
        switch (lhs, rhs) {
        case (.scale(let lhsType), .scale(let rhsType)):
            return lhsType == rhsType
        case (.arpeggio(let lhsType), .arpeggio(tonality: let rhsType)):
            return lhsType == rhsType
        default:
            return false
        }
    }
}


// The int is the rotations in the major pentatonic scale it must undertake
enum PentatonicScaleMode : Int, CaseIterable, Equatable, Codable {
    case mode1_major = 0
    case mode2_egyptian = 1
    case mode3_manGong = 2
    case mode4_ritusen = 3
    case mode5_minor = 4
}

enum ArpeggioTonality : String, CaseIterable, Equatable, Codable{
    case major = "major"
    case minor = "minor"
    case dominant7th = "dominant 7th"
    case diminished7th = "diminished 7th"
    case major7th = "major 7th"
    case minor7th = "minor 7th"
}

enum ChromaticAlteration : CaseIterable, Equatable, Codable {
    case unchanged
    case wholeTone
    // possibly add third options here (up in minor thirds etc
}

enum ScaleTonality : Equatable, Codable {
    case major(mode: MajorScaleMode)
    case naturalMinor
    case harmonicMinor
    case melodicMinor
    case chromatic(alteration: ChromaticAlteration)
    case pentatonic(mode: PentatonicScaleMode)
    case blues
}

enum Interval : Int {
    case none = 0
    case thirds = 3
    case fourths = 4
    case fifths = 5
}

enum IntervalOption {
    case allUp
    case allDown
    case oneUpOneDown
    case oneDownOneUp
}

enum AlterAmount : Int {
    case decrease = -1
    case increase = 1
}

enum OtherScaleTypes : String {
    case majorModes = "major modes"
    case pentatonicModes = "pentatonic modes"
    case special = "special scales"
    case tetrads = "7th scales (tetrads)"
}

enum circleOfFifthsOption {
    case outer
    case inner
    case centre
}
