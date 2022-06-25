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
    
    // Need getMinor starting notes as well
    
    func getMajorIonianStartingNote(from tonicNote : String, in mode : MajorScaleMode) -> String {
        let modeDegree = calculateModeDegree(mode: mode) // degree away from tonic note in semitones
        
        let tonicNoteIndex = returnNoteIndex(for: tonicNote)
        if (tonicNoteIndex < 0) {
            print("FAILED TO GET THE TONIC NOTE INDEX IN ALTERNOTES")
            return "FAILED TO GET THE TONIC NOTE INDEX IN ALTERNOTES"
        }
        
        // get the new index for the ionianModeTonic note
        var ionianTonicIndex = tonicNoteIndex - modeDegree
        if (ionianTonicIndex < 1) {
            ionianTonicIndex = 12 + ionianTonicIndex // the ionianTonicIndex is negative
        }
        
        if var ionianTonicNote = ascendingNotes[ionianTonicIndex] {
            let SharpOrFlat = ionianTonicNote.contains("|")
            
            if (SharpOrFlat) {
                let notesArr = ionianTonicNote.components(separatedBy: "|")
                let isSharp = tonicNote.contains("#")
                if (isSharp) {
                    ionianTonicNote = notesArr[0]
                } else {
                    ionianTonicNote = notesArr[1]
                }
            }
            
            return ionianTonicNote
        } else {
            return "FAILED to find IonianTonicNote in AlterNotes"
        }
    }
    
    private func calculateModeDegree(mode: MajorScaleMode) -> Int {
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
