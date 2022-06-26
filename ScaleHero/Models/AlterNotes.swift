//
//  AlterNotes.swift
//  ScaleHero
//
//  Created by Jesse Graf on 25/6/2022.
//

import Foundation

/**
 Class  AlterNotes
 Allows scale notes to be altered and shifted easily up or down the scale
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
            let isSharp = oldTonicNote.contains("#")
            if (isSharp) {
                newTonicNote = notesArr[0] // return sharp
            } else {
                newTonicNote = notesArr[1] // return flat
            }
        }
        
        return newTonicNote
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
        if (note.contains("#") || note.contains("b")) {
            switch note {
            case "A#", "Bb":
                modifiedNote = "A#|Bb"
            case "C#", "Db":
                modifiedNote = "C#|Db"
            case "D#", "Eb":
                modifiedNote = "D#|Eb"
            case "F#", "Gb":
                modifiedNote = "F#|Gb"
            case "G#", "Ab":
                modifiedNote = "G#|Ab"
            default:
                return -1
            }
        } else {
            modifiedNote = note
        }
        return ascendingNotes.key(from: modifiedNote) ?? -1
    }
    
}
