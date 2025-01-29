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
            return arpeggio.name
        case .scale(tonality: let scale):
            return scale.name
        case .unselected:
            return "No tonality is selected yet"
        }
    }
    
    var hasSolFa: Bool {
        switch self {
        case .arpeggio(tonality: let arpeggio):
            return arpeggio.hasSolFa
        case .scale(tonality: let scale):
            return scale.hasSolFa
        case .unselected:
            return false
        }
    }
    
    var hasNumbers: Bool {
        switch self {
        case .arpeggio(tonality: let arpeggio):
            return arpeggio.hasNumbers
        case .scale(tonality: let scale):
            return scale.hasNumbers
        case .unselected:
            return false
        }    }
    
    var solFa: [SolFa] {
        switch self {
        case .arpeggio(tonality: let arpeggio):
            return arpeggio.solFa
        case .scale(tonality: let scale):
            return scale.solFa
        case .unselected:
            return [] // TODO: Possibly convert to an exception later on
        }
    }
    
    var numbers: [NumberRepresentation] {
        switch self {
        case .arpeggio(tonality: let arpeggio):
            return arpeggio.numbers
        case .scale(tonality: let scale):
            return scale.numbers
        case .unselected:
            return []
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
    
    var numbers: [NumberRepresentation] {
        switch self {
        case .ionian:
            return [.One, .Two, .Three, .Four, .Five, .Six, .Seven, .One, .Seven, .Six, .Five, .Four, .Three, .Two, .One]
        case .dorian:
            return [.One, .Two, .FlatThree, .Four, .Five, .Six, .FlatSeven, .One, .FlatSeven, .Six, .Five, .Four, .FlatThree, .Two, .One]
        case .phrygian:
            return [.One, .FlatTwo, .FlatThree, .Four, .Five, .FlatSix, .FlatSeven, .One, .FlatSeven, .FlatSix, .Five, .Four, .FlatThree, .FlatTwo, .One]
        case .lydian:
            return [.One, .Two, .Three, .SharpFour, .Five, .Six, .Seven, .One, .Seven, .Six, .Five, .SharpFour, .Three, .Two, .One]
        case .mixolydian:
            return [.One, .Two, .Three, .Four, .Five, .Six, .FlatSeven, .One, .FlatSeven, .Six, .Five, .Four, .Three, .Two, .One]
        case .aeolian:
            return [.One, .Two, .FlatThree, .Four, .Five, .FlatSix, .FlatSeven, .One, .FlatSeven, .FlatSix, .Five, .Four, .FlatThree, .Two, .One]
        case .locrian:
            return [.One, .FlatTwo, .FlatThree, .Four, .FlatFive, .FlatSix, .FlatSeven, .One, .FlatSeven, .FlatSix, .FlatFive, .Four, .FlatThree, .FlatTwo, .One]
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
    
    var numbers: [NumberRepresentation] {
        switch self {
        case .mode1_major:
            return [.One, .Two, .Three, .Five, .Six, .One, .Six, .Five, .Three, .Two, .One]
        case .mode2_egyptian:
            return [.One, .Two, .Four, .Five, .FlatSeven, .One, .FlatSeven, .Five, .Four, .Two, .One]
        case .mode3_manGong:
            return [.One, .FlatThree, .Four, .FlatSix, .FlatSeven, .One, .FlatSeven, .FlatSix, .Four, .FlatThree, .One]
        case .mode4_ritusen:
            return [.One, .Two, .Four, .Five, .Six, .One, .Six, .Five, .Four, .Two, .One]
        case .mode5_minor:
            return [.One, .FlatThree, .Four, .Five, .FlatSeven, .One, .FlatSeven, .Five, .Four, .FlatThree, .One]
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

enum DisplayType {
    case notes
    case solFa
    case numbers
}

enum SolFa {
    case Do
    case Re
    case Mi
    case Fa
    case Fi
    case So // TODO: Rename to Sol
    case Si
    case La
    case Ti
    
    var name: String {
        switch self {
        case .Do:
            return "Do"
        case .Re:
            return "Re"
        case .Mi:
            return "Mi"
        case .Fa:
            return "Fa"
        case .Fi:
            return "Fi"
        case .So:
            return "Sol"
        case .Si:
            return "Si"
        case .La:
            return "La"
        case .Ti:
            return "Ti"
        }
    }
}

enum NumberRepresentation {
    case FlatOne
    case One
    case SharpOne
    case FlatTwo
    case Two
    case SharpTwo
    case FlatThree
    case Three
    case SharpThree
    case FlatFour
    case Four
    case SharpFour
    case FlatFive
    case Five
    case SharpFive
    case FlatSix
    case Six
    case SharpSix
    case FlatSeven
    case Seven
    case SharpSeven
    case FlatEight
    case Eight
    case SharpEight
    
    var name: String {
        switch self {
        case .FlatOne:
            return "Flat1"
        case .One:
            return "1"
        case .SharpOne:
            return "Sharp1"
        case .FlatTwo:
            return "Flat2"
        case .Two:
            return "2"
        case .SharpTwo:
            return "Sharp2"
        case .FlatThree:
            return "Flat3"
        case .Three:
            return "3"
        case .SharpThree:
            return "Sharp3"
        case .FlatFour:
            return "Flat4"
        case .Four:
            return "4"
        case .SharpFour:
            return "Sharp4"
        case .FlatFive:
            return "Flat5"
        case .Five:
            return "5"
        case .SharpFive:
            return "Sharp5"
        case .FlatSix:
            return "Flat6"
        case .Six:
            return "6"
        case .SharpSix:
            return "Sharp6"
        case .FlatSeven:
            return "Flat7"
        case .Seven:
            return "7"
        case .SharpSeven:
            return "Sharp7"
        case .FlatEight:
            return "Flat8"
        case .Eight:
            return "8"
        case .SharpEight:
            return "Sharp8"
        }
    }
}

protocol TonalityProtocol {
    var name: String { get }
    var hasSolFa: Bool { get }
    var solFa: [SolFa] { get }
    var hasNumbers: Bool { get }
    var numbers: [NumberRepresentation] { get }
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
    
    var hasSolFa: Bool {
        switch self {
        case .major, .minor:
            return true
        case .dominant7th, .diminished7th, .major7th, .minor7th:
            return false
        }
    }
    
    var hasNumbers: Bool {
        return true // TODO: So far all arpeggios shoudl be able to have numbers
    }
    
    var solFa: [SolFa] {
        switch self {
        case .major:
            return [.Do, .Mi, .So, .Do, .So, .Mi, .Do]
        case .minor:
            return [.La, .Do, .Mi, .La, .Do, .Mi, .La]
        default:
            return []
        }
    }
    
    var numbers: [NumberRepresentation] {
        switch self {
        case .major:
            return [.One, .Three, .Five, .One, .Five, .Three, .One]
        case .minor:
            return [.One, .FlatThree, .Five, .One, .Five, .FlatThree, .One]
        case .dominant7th:
            return [.One, .Three, .Five, .FlatSeven, .One, .FlatSeven, .Five, .Three, .One]
        case .diminished7th:
            return [.One, .Three, .Five, .FlatSeven, .One, .FlatSeven, .Five, .Three, .One]
        case .major7th:
            return [.One, .Three, .Five, .Seven, .One, .Seven, .Five, .Three, .One]
        case .minor7th:
            return [.One, .FlatThree, .Five, .FlatSeven, .One, .FlatSeven, .Five, .FlatThree, .One]
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
    
    var hasSolFa: Bool {
        switch self {
        case .major, .naturalMinor, .harmonicMinor, .melodicMinor, .pentatonic:
            return true
        case .blues, .chromatic:
            return false
        }
    }
    
    var hasNumbers: Bool {
        switch self {
        case .major, .naturalMinor, .harmonicMinor, .melodicMinor, .pentatonic, .blues:
            return true
        default:
            return false
        }
    }
    
    var solFa: [SolFa] {
        switch self {
        case .major(mode: let mode):
            let solFaMajor: [SolFa] = [.Do, .Re, .Mi, .Fa, .So, .La, .Ti, .Do, .Ti, .La, .So, .Fa, .Mi, .Re, .Do]
            return MusicArray.rotateScale(of: solFaMajor, by: mode.rawValue)
        case .naturalMinor:
            return [.La, .Ti, .Do, .Re, .Mi, .Fa, .So, .La, .So, .Fa, .Mi, .Re, .Do, .Ti, .La]
        case .harmonicMinor:
            return [.La, .Ti, .Do, .Re, .Mi, .Fa, .Si, .La, .Si, .Fa, .Mi, .Re, .Do, .Ti, .La]
        case .melodicMinor:
            return [.La, .Ti, .Do, .Re, .Mi, .Fi, .Si, .La, .So, .Fa, .Mi, .Re, .Do, .Ti, .La]
        case .pentatonic(mode: let mode):
            let solFaPentatonic: [SolFa] = [.Do, .Re, .Mi, .So, .La, .Do, .La, .So, .Mi, .Re, .Do]
            return MusicArray.rotateScale(of: solFaPentatonic, by: mode.rawValue)
        default:
            return []
        }
    }
    
    var numbers: [NumberRepresentation] {
        switch self {
        case .major(mode: let mode):
            return mode.numbers
        case .naturalMinor:
            return [.One, .Two, .FlatThree, .Four, .Five, .FlatSix, .FlatSeven, .One, .FlatSeven, .FlatSix, .Five, .Four, .FlatThree, .Two, .One]
        case .harmonicMinor:
            return [.One, .Two, .FlatThree, .Four, .Five, .FlatSix, .Seven, .One, .Seven, .FlatSix, .Five, .Four, .FlatThree, .Two, .One]
        case .melodicMinor:
            return [.One, .Two, .FlatThree, .Four, .Five, .Six, .Seven, .One, .FlatSeven, .FlatSix, .Five, .Four, .FlatThree, .Two, .One]
        case .chromatic(alteration: let alteration):
            return []
        case .pentatonic(mode: let mode):
            return mode.numbers
        case .blues:
            return [.One, .FlatThree, .Four, .SharpFour, .Five, .FlatSeven, .One, .FlatSeven, .Five, .SharpFour, .Four, .FlatThree, .One]
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
