//
//  MusicNotes.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/2024.
//

struct Pitch: Equatable {
    let note: Notes
    let octave: NoteOctaveOption
    
    static func increaseOctave(octave: NoteOctaveOption) -> NoteOctaveOption {
        switch octave {
        case .one:
            return .two
        case .two:
            return .three
        case .three:
            return .four
        case .four:
            fatalError("CANNOT INCREASE OCTAVE FROM OCTAVE 4. TURN INTO A PROPER ERROR MESSAGE")
        }
    }
    
    static func decreaseOctave(octave: NoteOctaveOption) -> NoteOctaveOption {
        switch octave {
        case .one:
            fatalError("CANNOT DECREASE OCTAVE FROM OCTAVE 1. TURN INTO A PROPER ERROR MESSAGE")
        case .two:
            return .one
        case .three:
            return .two
        case .four:
            return .three
        }
    }
}

struct FilePitch: Equatable {
    let fileNote: FileNotes
    let octave: NoteOctaveOption
}

enum FileNotes: Equatable {
    case C, C_SHARP_D_FLAT, D, D_SHARP_E_FLAT, E, F, F_SHARP_G_FLAT, G, G_SHARP_A_FLAT, A, A_SHARP_B_FLAT, B
    
    var name: String {
        switch self {
        case .C: return "C"
        case .C_SHARP_D_FLAT: return "C#|Db"
        case .D: return "D"
        case .D_SHARP_E_FLAT: return "D#|Eb"
        case .E: return "E"
        case .F: return "F"
        case .F_SHARP_G_FLAT: return "F#|Gb"
        case .G: return "G"
        case .G_SHARP_A_FLAT: return "G#|Ab"
        case .A: return "A"
        case .A_SHARP_B_FLAT: return "A#|Bb"
        case .B: return "B"
        }
    }
    
    static func toFileNotes(stringNote: String) -> FileNotes? {
        switch stringNote {
        case "C": return .C
        case "C#|Db": return .C_SHARP_D_FLAT
        case "D": return .D
        case "D#|Eb": return .D_SHARP_E_FLAT
        case "E": return .E
        case "F": return .F
        case "F#|Gb": return .F_SHARP_G_FLAT
        case "G": return .G
        case "G#|Ab": return .G_SHARP_A_FLAT
        case "A": return .A
        case "A#|Bb": return .A_SHARP_B_FLAT
        case "B": return .B
        default: return nil
        }
    }
}

enum Notes: Codable, CaseIterable, Equatable { // TODO: I need to do other things with this functionality as wlel. What though I do not know.
    case A_DOUBLE_FLAT, A_FLAT, A, A_SHARP, A_DOUBLE_SHARP
    case B_DOUBLE_FLAT, B_FLAT, B, B_SHARP, B_DOUBLE_SHARP
    case C_DOUBLE_FLAT, C_FLAT, C, C_SHARP, C_DOUBLE_SHARP
    case D_DOUBLE_FLAT, D_FLAT, D, D_SHARP, D_DOUBLE_SHARP
    case E_DOUBLE_FLAT, E_FLAT, E, E_SHARP, E_DOUBLE_SHARP
    case F_DOUBLE_FLAT, F_FLAT, F, F_SHARP, F_DOUBLE_SHARP
    case G_DOUBLE_FLAT, G_FLAT, G, G_SHARP, G_DOUBLE_SHARP
        
    static let orderedMusicAlphabet: BiMap<Int, FileNotes> = [0: FileNotes.C,
                                                           1: FileNotes.C_SHARP_D_FLAT,
                                                           2: FileNotes.D,
                                                           3: FileNotes.D_SHARP_E_FLAT,
                                                           4: FileNotes.E,
                                                           5: FileNotes.F,
                                                           6: FileNotes.F_SHARP_G_FLAT,
                                                           7: FileNotes.G,
                                                           8: FileNotes.G_SHARP_A_FLAT,
                                                           9: FileNotes.A,
                                                           10: FileNotes.A_SHARP_B_FLAT,
                                                           11: FileNotes.B]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let note = Notes.allCases.first(where: { $0.name == stringValue }) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid note: \(stringValue)")
        }
        self = note
    }
    
    // Custom initializer for converting a string into a Notes enum using the `name` property - I might want to use custom exceptions here...
    init?(noteName string: String) {
        for note in Notes.allCases {
            if (note.name.lowercased() == string.lowercased()) {
                self = note
                return
            }
        }
    
        
        print("The string note '\(string)' could not be converted into a Notes enum")
        return nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.name)
    }
    
    static func == (note1: Notes, note2: Notes) -> Bool {
        let firstNoteIndex = orderedMusicAlphabet.key(for: note1.fileName)
        let secondNoteIndex = orderedMusicAlphabet.key(for: note2.fileName)
        return firstNoteIndex == secondNoteIndex
    }
    
    func isIdentical(to note: Notes) -> Bool {
        return self.name == note.name
    }
    
    static func isOctaveStep(firstNote: Notes, secondNote: Notes, ascending: Bool) -> Bool {
        isOctaveStep(firstNote: firstNote.fileName, secondNote: secondNote.fileName, ascending: ascending)
    }
    
    static func isOctaveStep(firstNote: FileNotes, secondNote: FileNotes, ascending: Bool) -> Bool {
        let lowestSoundFileNote: FileNotes = .A
        guard let lsfnIndex = orderedMusicAlphabet.key(for: lowestSoundFileNote) else {
            return false
        }
        
        if (firstNote == secondNote) { return false }
        
        guard var index1 = orderedMusicAlphabet.key(for: firstNote),
              var index2 = orderedMusicAlphabet.key(for: secondNote) else {
            return false
        }
        
        if !ascending {
            let temp = index1
            index1 = index2
            index2 = temp
        }

        if index1 < lsfnIndex && index2 >= lsfnIndex {
            return true
        } else if index2 < index1 { // Wraps around the scale
            if (index1 < lsfnIndex && index2 <= lsfnIndex) {
                return true
            }
        }
        return false
    }
    
    var name: String {
        switch self {
        case .A_DOUBLE_FLAT: return "A-double-flat"
        case .A_FLAT: return "A-flat"
        case .A: return "A"
        case .A_SHARP: return "A-sharp"
        case .A_DOUBLE_SHARP: return "A-double-sharp"
        case .B_DOUBLE_FLAT: return "B-double-flat"
        case .B_FLAT: return "B-flat"
        case .B: return "B"
        case .B_SHARP: return "B-sharp"
        case .B_DOUBLE_SHARP: return "B-double-sharp"
        case .C_DOUBLE_FLAT: return "C-double-flat"
        case .C_FLAT: return "C-flat"
        case .C: return "C"
        case .C_SHARP: return "C-sharp"
        case .C_DOUBLE_SHARP: return "C-double-sharp"
        case .D_DOUBLE_FLAT: return "D-double-flat"
        case .D_FLAT: return "D-flat"
        case .D: return "D"
        case .D_SHARP: return "D-sharp"
        case .D_DOUBLE_SHARP: return "D-double-sharp"
        case .E_DOUBLE_FLAT: return "E-double-flat"
        case .E_FLAT: return "E-flat"
        case .E: return "E"
        case .E_SHARP: return "E-sharp"
        case .E_DOUBLE_SHARP: return "E-double-sharp"
        case .F_DOUBLE_FLAT: return "F-double-flat"
        case .F_FLAT: return "F-flat"
        case .F: return "F"
        case .F_SHARP: return "F-sharp"
        case .F_DOUBLE_SHARP: return "F-double-sharp"
        case .G_DOUBLE_FLAT: return "G-double-flat"
        case .G_FLAT: return "G-flat"
        case .G: return "G"
        case .G_SHARP: return "G-sharp"
        case .G_DOUBLE_SHARP: return "G-double-sharp"
        }
    }
    
    var readableString: String {
        var nameString = self.name
        nameString = nameString.replacingOccurrences(of: "-double-flat", with: "bb")
        nameString = nameString.replacingOccurrences(of: "-double-sharp", with: "##")
        nameString = nameString.replacingOccurrences(of: "-flat", with: "b")
        nameString = nameString.replacingOccurrences(of: "-sharp", with: "#")
        return nameString
    }
    
    var fileName: FileNotes {
        switch self {
        case .A, .G_DOUBLE_SHARP, .B_DOUBLE_FLAT: return FileNotes.A
        case .A_SHARP, .B_FLAT, .C_DOUBLE_FLAT: return FileNotes.A_SHARP_B_FLAT
        case .B, .C_FLAT, .A_DOUBLE_SHARP: return FileNotes.B
        case .C, .B_SHARP, .D_DOUBLE_FLAT: return FileNotes.C
        case .C_SHARP, .D_FLAT, .B_DOUBLE_SHARP: return FileNotes.C_SHARP_D_FLAT
        case .D, .C_DOUBLE_SHARP, .E_DOUBLE_FLAT: return FileNotes.D
        case .D_SHARP, .E_FLAT, .F_DOUBLE_FLAT: return FileNotes.D_SHARP_E_FLAT
        case .E, .F_FLAT, .D_DOUBLE_SHARP: return FileNotes.E
        case .F, .E_SHARP, .G_DOUBLE_FLAT: return FileNotes.F
        case .F_SHARP, .G_FLAT, .E_DOUBLE_SHARP: return FileNotes.F_SHARP_G_FLAT // This is where the sharps could go wrong. I need my enum to include double flats and sharps as well
        case .G, .F_DOUBLE_SHARP, .A_DOUBLE_FLAT: return FileNotes.G
        case .G_SHARP, .A_FLAT: return FileNotes.G_SHARP_A_FLAT
        }
    }
    
    static func returnPossibleNotes(for fileNote: FileNotes) -> [Notes] {
        switch fileNote {
        case .C: return [.C, .B_SHARP, .D_DOUBLE_FLAT]
        case .C_SHARP_D_FLAT: return [.C_SHARP, .D_FLAT, .B_DOUBLE_SHARP]
        case .D: return [.D, .C_DOUBLE_SHARP, .E_DOUBLE_FLAT]
        case .D_SHARP_E_FLAT: return [.D_SHARP, .E_FLAT, .F_DOUBLE_FLAT]
        case .E: return [.E, .F_FLAT, .D_DOUBLE_SHARP]
        case .F: return [.F, .E_SHARP, .G_DOUBLE_FLAT]
        case .F_SHARP_G_FLAT: return [.F_SHARP, .G_FLAT, .E_DOUBLE_SHARP]
        case .G: return [.G, .F_DOUBLE_SHARP, .A_DOUBLE_FLAT]
        case .G_SHARP_A_FLAT: return [.G_SHARP, .A_FLAT]
        case .A: return [.A, .G_DOUBLE_SHARP, .B_DOUBLE_FLAT]
        case .A_SHARP_B_FLAT: return [.A_SHARP, .B_FLAT, .C_DOUBLE_FLAT]
        case .B: return [.B, .C_FLAT, .A_DOUBLE_SHARP]
        }
    }
}

struct BiMap<K: Hashable, V: Hashable>: ExpressibleByDictionaryLiteral {
    private var forward: [K: V] = [:]
    private var reverse: [V: K] = [:]
    
    init(dictionaryLiteral elements: (K, V)...) {
        for (key, value) in elements {
            forward[key] = value
            reverse[value] = key
        }
    }

    func value(for key: K) -> V? {
        return forward[key]
    }

    func key(for value: V) -> K? {
        return reverse[value]
    }
    
    func size() -> Int {
        return forward.count
    }
}
