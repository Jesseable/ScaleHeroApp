//
//  Write.swift
//  ScaleHero
//
//  Created by Jesse Graf on 23/12/21.
//

import UIKit

/**
 Class  Writescales
 Returns the string representations of the sound files in an ordered array ready to be accessed for playing the scale
 */
struct WriteScales {
    
    let type : String
    var fileReaderAndWriter = FileReaderAndWriter()
    var scaleNoteNames : [String] = []
    
    // Sets the major pattern for differnet types of scales. Measured in semitones
    lazy var majorPattern : [Int] = {
        [self] in
        switch self.type.lowercased() {
        case "arpeggio":
            return [4, 3, 5]
        case "scale":
            return [2, 2, 1, 2, 2, 2, 1]
        case "mode":
            return [2, 2, 1, 2, 2, 2, 1]
//        case "pentatonic":
//            return [2, 2, 3, 2, 3]
        default:
            return[-1]
        }
    }()
    
    lazy var minorPattern : [Int] = {
        [self] in
        switch self.type.lowercased() {
        case "arpeggio":
            return [3, 4, 5]
        case "scale":
            return [2, 1, 2, 2, 1, 2, 2]
        case "harmonic":
            return [2, 1, 2, 2, 1, 3, 1]
        case "melodic":
            return [2, 1, 2, 2, 2, 2, 1]
        default:
            return [-1]
        }
    }()
    
    lazy var tetradsPattern : [Int] = {
        [self] in
        switch self.type.lowercased() {
        case "dominant-seventh":
            return [4, 3, 3, 2]
        case "major-seventh":
            return [4, 3, 4, 1]
        case "minor-seventh":
            return [3, 4, 3, 2]
        case "diminished-seventh":
            return [3, 3, 3, 3]
        default:
            return[-1]
        }
    }()
    
    lazy var otherPattern : [Int] = {
        switch self.type.lowercased() {
        case "chromatic-scale":
            return [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        case "whole-tone-scale":
            return [2, 2, 2, 2, 2, 2]
        case "major-pentatonic-scale":
            return [2, 2, 3, 2, 3]
        case "minor-pentatonic-scale":
            return [3, 2, 2, 3, 2]
        case "blues-scale":
            return [3, 2, 1, 1, 3, 2]
        default:
            return[-1]
        }
    }()
    
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
                          36: "3:G#/Ab",
                          37: "4:A",
                          38: "4:A#/Bb",
                          39: "4:B",
                          40: "4:C",
                          41: "4:C#/Db",
                          42: "4:D",
                          43: "4:D#/Eb",
                          44: "4:E",
                          45: "4:F",
                          46: "4:F#/Gb",
                          47: "4:G",
                          48: "4:G#/Ab"]
    
    /**
     Return the scale Note Names
     */
    func getScaleNoteNames() -> [String] {
        return scaleNoteNames
    }
    
    /**
     Returns the starting notes key in the musicNotes dictionary
     */
    private func startingNoteKeyFinder(startingNote: String, startingOctave: Int) -> Int {
        var key = -1 // stays -1 if unchanged
        
        for note in accendingNotes {
            let noteOctaveArr = note.value.components(separatedBy: ":")
            if (noteOctaveArr[1] == startingNote && noteOctaveArr[0] == String(startingOctave)) {
                key = note.key
            }
        }
        return key
    }
    
    private func getFullNote(singularNote: String) -> String{
        switch singularNote {
        case "F#", "Gb":
            return "F#/Gb"
        case "C#", "Db":
            return "C#/Db"
        case "G#", "Ab":
            return "G#/Ab"
        case "D#", "Eb":
            return "D#/Eb"
        case "A#", "Bb":
            return "A#/Bb"
        default:
            return singularNote
        }
    }
    
    /**
     Returns an array of the notes to play in the specific scale
     */
    mutating func ScaleNotes(startingNote: String, octave: Int, tonality: String, tonicOption: Int, startingOctave: Int) -> [String] {
        var startingKey = startingNoteKeyFinder(startingNote: startingNote, startingOctave: startingOctave)
        let originalStartingKey = startingKey
        let noteCKey = startingNoteKeyFinder(startingNote: "C", startingOctave: startingOctave)
        
        // Does the transposition
        var transpositionNote = fileReaderAndWriter.readTransposition()
        if (transpositionNote.components(separatedBy: " ").count > 1) {
            transpositionNote = transpositionNote.components(separatedBy: " ")[2]
            transpositionNote = getFullNote(singularNote: transpositionNote)
        }
        let transpositionKey = startingNoteKeyFinder(startingNote: transpositionNote, startingOctave: startingOctave)
        let difference = noteCKey - transpositionKey
        startingKey -= difference
        
        // Makes sure the octave is correct
        let oneOctave = 12
        if (Int(accendingNotes[startingKey]?.components(separatedBy: ":")[0] ?? "-1") != startingOctave) {
            startingKey -= oneOctave
        }
        
        var valueArray : [String] = []
        var noteNameValueArray : [String] = []
        
        var reversedValuesArr: [String] = []
        var noteNameReversedValuesArr: [String] = []
        
        var keysArray = [startingKey]
        var noteNameKeysArray = [(originalStartingKey)]
        // if -1 needs an error image
        
        keysArray = dictKeysArray(startingKey: startingKey, tonality: tonality, octave: octave, keysArray: keysArray)
        noteNameKeysArray = dictKeysArray(startingKey: (originalStartingKey), tonality: tonality, octave: octave, keysArray: noteNameKeysArray)
        
        for key in keysArray {
            guard let noteName = accendingNotes[key] else { return ["Getting string access from key for music dictionary has failed"] }
            valueArray.append(noteName)
        }
        
        for key in noteNameKeysArray {
            guard let noteName = accendingNotes[key] else { return ["Getting string access from key for music dictionary has failed"] }
            noteNameValueArray.append(noteName)
        }
        
        if (self.type != "melodic") {
            reversedValuesArr = valueArray.reversed()
            noteNameReversedValuesArr = noteNameValueArray.reversed()
            
            // removed a value so as to not repeat the tonic
            reversedValuesArr.removeFirst()
            noteNameReversedValuesArr.removeFirst()
            
            valueArray.append(contentsOf: reversedValuesArr)
            noteNameValueArray.append(contentsOf: noteNameReversedValuesArr)
        } else {
            // Needs to be altered to do multiple octaves as well. Should create another function for this purpose!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            reversedValuesArr = valueArray.reversed()
            noteNameReversedValuesArr = noteNameValueArray.reversed()
            reversedValuesArr = melodicMinorDecendingAlterations(on: reversedValuesArr, for: octave)
            noteNameReversedValuesArr = melodicMinorDecendingAlterations(on: noteNameReversedValuesArr, for: octave)
            
            // removed a value so as to not repeat the tonic
            reversedValuesArr.removeFirst()
            noteNameReversedValuesArr.removeFirst()
            valueArray.append(contentsOf: reversedValuesArr)
            noteNameValueArray.append(contentsOf: noteNameReversedValuesArr)
        }
        
        let scaleArray = addRepeatingTonics(for: valueArray, tonicOption: tonicOption)
        let noteNameScaleArray = addRepeatingTonics(for: noteNameValueArray, tonicOption: tonicOption)
        
        self.scaleNoteNames = noteNameScaleArray
        return scaleArray
    }
    
    /**
     If the repeating tonic buttons are selected than the array repeats the neccessary tonic notes
     */
    private func addRepeatingTonics(for scaleArr: [String], tonicOption: Int) -> [String] {
        var valueArr = scaleArr
        
        if (tonicOption >= 2) {
            // repeat all
            let startingNote = scaleArr[0].components(separatedBy: ":")[1]
            var firstHalf = true
            
            for note in valueArr {

                let currentNote = note.components(separatedBy: ":")[1]
                if (currentNote == startingNote) {
                    let index : Int
                    if (firstHalf) {
                        index = valueArr.firstIndex(of: note)!
                    } else {
                       index = valueArr.lastIndex(of: note)!
                    }

                    valueArr.insert(note, at: index)
                    if (index >= scaleArr.count/2) {
                        firstHalf = false
                    }
                }
            }
            
            if (tonicOption == 3) {
                // Reapeat all/First
                valueArr.removeFirst()
                valueArr.removeLast()
            }
        }
        // Else: repeat none
        return valueArr
    }
        
    /**
     If a melodic minor scale has been chosen than this allows it to be altered to a natural minor scale when decending.
     */
    private func melodicMinorDecendingAlterations(on reversedValuesArr: [String], for octave: Int) -> [String] {
        var reversedValues = reversedValuesArr
        let seventhNote = reversedValues.remove(at: 1)
        let sixthNote = reversedValues.remove(at: 1)
        let firstSeventhNoteKey = accendingNotes.key(from: seventhNote)
        let firstSixthNoteKey = accendingNotes.key(from: sixthNote)
        
        if (octave > 1) {
            reversedValues.remove(at: 6)
            reversedValues.remove(at: 6)
        }
        if (octave > 2) {
            reversedValues.remove(at: 11)
            reversedValues.remove(at: 11)
        }
        var seventhIndexPos = 1
        var sixthIndexPos = 2
        var newSeventhNotesKey = (firstSeventhNoteKey! - 1)
        var newSixthhNotesKey = (firstSixthNoteKey! - 1)
        
        octave.times {
            reversedValues.insert(accendingNotes[newSeventhNotesKey]!, at: seventhIndexPos)
            seventhIndexPos += 6
            newSeventhNotesKey -= 12
        }
        octave.times {
            reversedValues.insert(accendingNotes[newSixthhNotesKey]!, at: sixthIndexPos)
            sixthIndexPos += 7
            newSixthhNotesKey -= 12
        }
        
        return reversedValues
    }
    
    /**
     Returns an array of the keys for the relative scale in the accending notes dictionary
     */
    private mutating func dictKeysArray(startingKey: Int, tonality: String, octave: Int, keysArray: [Int]) -> [Int] {
        
        var startingNum = startingKey
        var dictKeysArray = keysArray
        var curruntOctave = 1
        
        while !(curruntOctave > octave) {
            switch tonality.lowercased() {
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
            case "ionian":
                for num in majorPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "dorian":
                var dorianPattern = majorPattern
                let firstNum = dorianPattern.removeFirst()
                dorianPattern.append(firstNum)
                for num in dorianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "phrygian":
                var phrygianPattern = majorPattern
                2.times {
                    let content = phrygianPattern.removeFirst()
                    phrygianPattern.append(content)
                }

                for num in phrygianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "lydian":
                var lydianPattern = majorPattern
                3.times {
                    let content = lydianPattern.removeFirst()
                    lydianPattern.append(content)
                }

                for num in lydianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "mixolydian":
                var mixolydianPattern = majorPattern
                4.times {
                    let content = mixolydianPattern.removeFirst()
                    mixolydianPattern.append(content)
                }

                for num in mixolydianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "aeolian":
                var aeolianPattern = majorPattern
                5.times {
                    let content = aeolianPattern.removeFirst()
                    aeolianPattern.append(content)
                }

                for num in aeolianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "locrian":
                var locrianPattern = majorPattern
                6.times {
                    let content = locrianPattern.removeFirst()
                    locrianPattern.append(content)
                }

                for num in locrianPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "others":
                for num in otherPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            case "tetrad":
                for num in tetradsPattern {
                    startingNum += num
                    dictKeysArray.append(startingNum)
                }
            default:
                print("dictionary of notes failed")
                return [-1]
            }
            curruntOctave += 1
        }
        return dictKeysArray
    }
}

/**
 Used to minimise code in the for loop when changing between modes
 */
extension Int {
    func times(_ f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
    func times(_ f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
    
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}
