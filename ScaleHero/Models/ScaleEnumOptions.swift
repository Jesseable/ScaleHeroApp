//
//  ScaleEnumOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 26/6/2022.
//

import Foundation

// TODO: Some of these should be moved into seperate files and classes

enum FilePath {
    case countInBeats
    case droneInst
    case scaleInst
    case background
    case transposition
    case metronome
    case achievements
    case initialHint
}

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

enum Case : Codable, TonalityProtocol {
    case arpeggio(tonality: ArpeggioTonality)
    case scale(tonality: ScaleTonality)
    case unselected
    
    var name: String {
        switch self {
        case .arpeggio(tonality: let arpeggio):
            return "Arpeggio"
        case .scale(tonality: let scale):
            return "Scale"
        case .unselected:
            return "No tonality is selected yet"
        }
    }
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

protocol ModeProtocol : CaseIterable, Equatable, Codable, RawRepresentable where RawValue == Int {
    var name: String { get }
    var modeDegree: Int { get }
}

// The int is the rotations in the major scale it must undertake
enum MajorScaleMode : Int, ModeProtocol {
    case ionian = 0
    case dorian = 1
    case phrygian = 2
    case lydian = 3
    case mixolydian = 4
    case aeolian = 5
    case locrian = 6
    
    var name: String {
        switch self {
        case .ionian: return "Ionian"
        case .dorian: return "Dorian"
        case .phrygian: return "Phrygian"
        case .lydian: return "Lydian"
        case .mixolydian: return "Mixolydian"
        case .aeolian: return "Aeolian"
        case .locrian: return "Locrian"
        }
    }
    
    var modeDegree: Int {
        switch self {
        case .ionian:
            return 0
        case .dorian:
            return 2
        case .phrygian:
            return 4
        case .lydian:
            return 5
        case .mixolydian:
            return 7
        case .aeolian:
            return 9
        case .locrian:
            return 11
        }
    }
}

// The int is the rotations in the major pentatonic scale it must undertake
enum PentatonicScaleMode : Int, ModeProtocol {
    case mode1_major = 0
    case mode2_egyptian = 1
    case mode3_manGong = 2
    case mode4_ritusen = 3
    case mode5_minor = 4
    
    var name: String {
        switch self {
        case .mode1_major:
            return "Major Pentatonic Scale"
        case .mode2_egyptian:
            return "Egyptian Pentatonic Scale"
        case .mode3_manGong:
            return "ManGong Pentatonic Scale"
        case .mode4_ritusen:
            return "Ritusen Pentatonic Scale"
        case .mode5_minor:
            return "Minor Pentatonic Scale"
        }
    }
    
    var modeDegree: Int {
        switch self {
        case .mode1_major:
            return 0
        case .mode2_egyptian:
            return 2
        case .mode3_manGong:
            return 4
        case .mode4_ritusen:
            return 7
        case .mode5_minor:
            return 9
        }
    }
}

enum ChromaticAlteration : CaseIterable, Equatable, Codable {
    case unchanged
    case wholeTone
    // possibly add third options here (up in minor thirds etc
    var name: String {
        switch self {
        case .unchanged:
            return "Chromatic"
        case .wholeTone:
            return "Whole Tone"
        }
    }
}

protocol TonalityProtocol {
    var name: String { get }
}

enum ArpeggioTonality : CaseIterable, Equatable, Codable, TonalityProtocol {
    case major
    case minor
    case dominant7th
    case diminished7th
    case major7th
    case minor7th
    
    var name: String {
        switch self {
        case .major:
            return "Major Arpeggio"
        case .minor:
            return "Minor Arpeggio"
        case .dominant7th:
            return "Dominant 7th"
        case .diminished7th:
            return "Diminished 7th"
        case .major7th:
            return "Major 7th"
        case .minor7th:
            return "Minor 7th"
        }
    }
}

enum ScaleTonality : Equatable, Codable, TonalityProtocol {
    case major(mode: MajorScaleMode)
    case naturalMinor
    case harmonicMinor
    case melodicMinor
    case chromatic(alteration: ChromaticAlteration)
    case pentatonic(mode: PentatonicScaleMode)
    case blues
    
    var name: String {
        switch self {
        case .major(mode: let mode):
            return mode.name
        case .naturalMinor:
            return "Natural Minor"
        case .harmonicMinor:
            return "Harmonic Minor"
        case .melodicMinor:
            return "Melodic Minor"
        case .chromatic(alteration: let alteration):
            return alteration.name
        case .pentatonic(mode: let mode):
            return mode.name
        case .blues:
            return "Blues"
        }
    }
    
    var hasModes: Bool {
        switch self {
        case .major, .pentatonic: // TODO: Add harmonic minor and possibly melodic modes as well
            return true
        case .naturalMinor, .blues, .harmonicMinor, .melodicMinor, .chromatic:
            return false
        }
    }
}

enum Interval : Int, Codable, Hashable {
    case none = 0
    case thirds = 3
    case fourths = 4
    case fifths = 5
}

enum IntervalOption : Codable {
    case allUp
    case allDown
    case oneUpOneDown
    case oneDownOneUp
}

enum AlterAmount : Int { // TODO: What is this
    case decrease = -1
    case increase = 1
}

enum OtherScaleTypes : String {
    case majorModes = "major modes"
    case pentatonicModes = "pentatonic modes"
    case special = "special scales"
    case tetrads = "7th scales (tetrads)"
}

enum CircleOfFifthsOption {
    case outer
    case inner
    case centre
}

enum OctaveNumber : Int, Codable, Hashable {
    case one = 1
    case two = 2
    case three = 3
}

enum NoteOctaveOption: Int, Equatable {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    
    mutating func increment() {
        switch self {
        case .one:
            self = .two
            break
        case .two:
            self = .three
            break
        case .three:
            self = .four
            break
        case .four:
            fatalError(" Cannot decrement from noteOctave four") // TODO: turn to a handable error
        }
    }
    
    mutating func decrement() {
        switch self {
        case .one:
            fatalError(" Cannot decrement from noteOctave one") // TODO: turn to a handable error
        case .two:
            self = .one
            break
        case .three:
            self = .two
            break
        case .four:
            self = .three
            break
        }
    }
}
