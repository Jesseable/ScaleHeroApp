//
//  ScaleEnumOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 26/6/2022.
//

import Foundation

enum ScaleType {
    case majorMode(mode: MajorScaleMode)
    case pentatonicMode(mode: PentatonicScaleMode)
    case wholetone
}

enum TonicOption {
    case noRepeatedTonic
    case repeatedTonicAll
    case repeatedTonic
}

// The int is the rotations in the major scale it must undertake
enum MajorScaleMode : Int, CaseIterable {
    case ionian = 0
    case dorian = 1
    case phrygian = 2
    case lydian = 3
    case mixolydian = 4
    case aeolian = 5
    case locrian = 6
}

// The int is the rotations in the major pentatonic scale it must undertake
enum PentatonicScaleMode : Int, CaseIterable {
    case mode1_major = 0
    case mode2_egyptian = 1
    case mode3_manGong = 2
    case mode4_ritusen = 3
    case mode5_minor = 4
}

enum Case {
    case arpeggio(tonality: ArpeggioTonality)
    case scale(tonality: ScaleTonality)
}

enum ArpeggioTonality : CaseIterable {
    case major
    case minor
    case dominant7th
    case diminished7th
    case major7th
    case minor7th
}

enum ScaleTonality : CaseIterable {
    case major
    case naturalMinor
    case harmonicMinor
    case melodicMinor
    case chromatic
    case pentatonic
    case blues
}

enum Interval : Int {
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

enum AlterAmount: Int {
    case decrease = -1
    case increase = 1
}
