//
//  AlterNotes.swift
//  ScaleHero
//
//  Created by Jesse Graf on 25/6/2022.
//

import Foundation

/**
 Class  AlterNotes
 Retrives tonic notes of major/ionion scales and converts scales into intervals, e.g. 3rds
 */
struct AlterNotes {
    
    /*
     AscendingNotes of a scale. If flat or sharp, then the note takes the form [sharp_varient]|[flat_varient]
     */
    private let ascendingNotes = [1: "A",
                          2: "A#|Bb", // generally Bb
                          3: "B",
                          4: "C",
                          5: "C#|Db", // generally Db
                          6: "D",
                          7: "D#|Eb", // generally Eb
                          8: "E",
                          9: "F",
                          10: "F#|Gb", // generally Gb
                          11: "G",
                          12: "G#|Ab"] // generally Ab
    
    func getMajorPentatonicStartingNote(from tonicNote : String, in mode : PentatonicScaleMode) -> String {
        let modeDegree = calculatePentatonicModeDegree(mode: mode) // degree away from tonic note in semitones
        
        let tonicNoteIndex = returnNoteIndex(for: tonicNote)
        if (tonicNoteIndex < 0) {
            return "FAILED TO GET THE TONIC NOTE INDEX IN ALTERNOTES"
        }
        
        // get the new index for the majorModeTonic note
        var majorTonicIndex = tonicNoteIndex - modeDegree
        if (majorTonicIndex < 1) {
            majorTonicIndex = 12 + majorTonicIndex // the ionianTonicIndex is negative
        }
        
        if var majorTonicNote = ascendingNotes[majorTonicIndex] {
            majorTonicNote = checkSharpFlat(for: majorTonicNote, oldTonicNote: tonicNote)
            majorTonicNote = sanitiseNoteName(note: majorTonicNote)
            return majorTonicNote
        } else {
            return "FAILED to find IonianTonicNote in AlterNotes"
        }
    }
    
    func getMajorIonianStartingNote(from tonicNote : String, in mode : MajorScaleMode) -> String {
        let modeDegree = calculateMajorModeDegree(mode: mode) // degree away from tonic note in semitones
        
        let tonicNoteIndex = returnNoteIndex(for: tonicNote)
        if (tonicNoteIndex < 0) {
            return "FAILED TO GET THE TONIC NOTE INDEX IN ALTERNOTES"
        }
        
        // get the new index for the ionianModeTonic note
        var ionianTonicIndex = tonicNoteIndex - modeDegree
        if (ionianTonicIndex < 1) {
            ionianTonicIndex = 12 + ionianTonicIndex // the ionianTonicIndex is negative
        }
        
        if var ionianTonicNote = ascendingNotes[ionianTonicIndex] {
            ionianTonicNote = checkSharpFlat(for: ionianTonicNote, oldTonicNote: tonicNote)
            ionianTonicNote = sanitiseNoteName(note: ionianTonicNote)
            return ionianTonicNote
        } else {
            return "FAILED to find IonianTonicNote in AlterNotes"
        }
    }
    
    private func checkSharpFlat(for tonicNote: String, oldTonicNote: String) -> String {
        var newTonicNote = tonicNote
        let hasSharpOrFlat = newTonicNote.contains("|")
        
        if (hasSharpOrFlat) {
            let notesArr = newTonicNote.components(separatedBy: "|")
            let isSharp = oldTonicNote.contains("sharp")
            if (isSharp) { // Will need to sanitise the opposite way here
                newTonicNote = notesArr[0] // return sharp
            } else {
                newTonicNote = notesArr[1] // return flat
            }
        }
        return newTonicNote
    }
    
    private func sanitiseNoteName(note: String) -> String { // TODO: This could be removed when I create my better classes amd archetecture.
        var sanitizedNote = note
        
        if (note.contains("#")) {
            sanitizedNote = sanitizedNote.replacingOccurrences(of: "##", with: "-double-sharp")
            sanitizedNote = sanitizedNote.replacingOccurrences(of: "#", with: "-sharp")
        }
        if (note.contains("b")) {
            sanitizedNote = sanitizedNote.replacingOccurrences(of: "bb", with: "-double-flat")
            sanitizedNote = sanitizedNote.replacingOccurrences(of: "b", with: "-flat")
        }
        return sanitizedNote
    }
    
    private func calculateMajorModeDegree(mode: MajorScaleMode) -> Int {
        switch mode {
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
    
    private func calculatePentatonicModeDegree(mode: PentatonicScaleMode) -> Int {
        switch mode {
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
    
    /*
     Finds the index for the note.
     ----------------
     @param note: the note, in "Eb" or "D#" form, not "D#|Eb
     Returns: an integer containing the index of the ascending notes array
     */
    private func returnNoteIndex(for note : String) -> Int {
        let modifiedNote : String
        // TODO: Add code to shift double flats to the readable sound file note as well. need to rename my classes I suppose. 
        if (note.contains("sharp") || note.contains("flat")) { // Maybe I need to sanitise here??? What is going on here
            switch note {
            case "A-sharp", "B-flat":
                modifiedNote = "A#|Bb"
            case "C-sharp", "D-flat":
                modifiedNote = "C#|Db"
            case "D-sharp", "E-flat":
                modifiedNote = "D#|Eb"
            case "F-sharp", "G-flat":
                modifiedNote = "F#|Gb"
            case "G-sharp", "A-flat":
                modifiedNote = "G#|Ab"
            default:
                return -1
            }
        } else {
            modifiedNote = note
        }
        return ascendingNotes.key(from: modifiedNote) ?? -1
    }
    
    /*
     Changes the octave number of a sound file readable note e.g. "2:C#|Db" -> "1:C#|Db" etc
     ----------------
     @param amount: The amount to increase or decrease the value (can be negative)
     @param initialOctave: The octave the scale will start at.
     Returns: a string array containing the sound file readable format: "[octave_num]:[note_name]"
     */
    func changeOctaveNumber(_ amount: AlterAmount, for note: String) -> String {
        //var newNote = note
        let initialOctaveNumChar = note.first
        var newOctaveNum : Int
        
        if let intValue = initialOctaveNumChar?.wholeNumberValue {
            if (intValue  < 1 || intValue > 3) {
                return "is not a valid octave number"
            }
            newOctaveNum = intValue + amount.rawValue
        } else {
            return "Not a valid integer"
        }
        
        let newNote = "\(newOctaveNum)" + note.dropFirst()
        
        return newNote
    }
}
