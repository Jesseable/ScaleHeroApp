//
//  SoundEnums.swift
//  ScaleHero
//
//  Created by Jesse Graf on 23/12/21.
//

import SwiftUI
import SwiftySound

enum Style {
    case scale
    case arpeggio
}

enum Tonality {
    case major
    case minor
    case phrygian // ect
    case chromatic
}

/**
 Class Play scales
 Returns the string representations of the sound files in an ordered array ready to be accessed for playing the scale
 */
struct PlayScales {
    
    let majorPattern = [2, 2, 1, 2, 2, 2, 1]
    let minorPattern = [2, 1, 2, 2, 1, 2, 2]
    
    var accendingNotes = [1: "1:A",
                          2: "1:A#/Bb",
                          3: "1:B",
                          4: "1:C",
                          5: "1:C#/Db",
                          6: "1:D",
                          7: "1:D#/Eb",
                          8: "1:E",
                          9: "1:F",
                          10: "1:F#/Gb",
                          11: "1:G",
                          12: "1:G#/Ab",
                          13: "2:A",
                          14: "2:A#/Bb",
                          15: "2:B",
                          16: "2:C",
                          17: "2:C#/Db",
                          18: "2:D",
                          19: "2:D#/Eb",
                          20: "2:E",
                          21: "2:F",
                          22: "2:F#/Gb",
                          23: "2:G",
                          24: "2:G#/Ab",
                          25: "3:A",
                          26: "3:A#/Bb",
                          27: "3:B",
                          28: "3:C",
                          29: "3:C#/Db",
                          30: "3:D",
                          31: "3:D#/Eb",
                          32: "3:E",
                          33: "3:F",
                          34: "3:F#/Gb",
                          35: "3:G",
                          36: "3:G#/Ab"]
    
    /**
     Returns the starting notes key in the musicNotes dictionary
     */
    func startingNoteKeyFinder(startingNote: String, octave: Int) -> Int {
        var key = -1 // stays -1 if unchanged
        
        for note in accendingNotes {
            let noteOctaveArr = note.value.components(separatedBy: ":")
            if (noteOctaveArr[1] == startingNote && noteOctaveArr[0] == "1") { // Optional to change octave here later on
                key = note.key
            }
        }
        return key
    }
    
    /**
     Returns an array of the notes to play in the specific scale
     */
    func ScaleNotes(startingNote: String, octave: Int, tonality: String) -> [String] { // Chnage to returning a array of string
        
        let startingKey = startingNoteKeyFinder(startingNote: startingNote, octave: octave)
        
        var ValueArray : [String] = []
        var keysArray = [startingKey]
        // if -1 needs an error image
        
        keysArray = dictKeysArray(startingKey: startingKey, tonality: tonality, keysArray: keysArray)
        
        for key in keysArray {
            guard let noteName = accendingNotes[key] else { return ["Failed"] }
//            let note = noteName.components(separatedBy: ":")
            ValueArray.append(noteName)
        }
        
        return ValueArray
    }
    
    /**
     returns an array of the keys for the relative scale in the accending notes dictionary
     */
    func dictKeysArray(startingKey: Int, tonality: String, keysArray: [Int]) -> [Int] {
        
        var startingNum = startingKey
        var dictKeysArray = keysArray
        
        switch tonality {
        case "major":
            for num in majorPattern {
                startingNum += num
                dictKeysArray.append(startingNum)
            }
        case "minor":
            for num in minorPattern {
                startingNum += num
                dictKeysArray.append(startingNum)
            }
        default:
            return [-1]
        }

        return dictKeysArray
    }
}
