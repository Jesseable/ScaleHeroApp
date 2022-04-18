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
    
    //let type : String
    var fileReaderAndWriter = FileReaderAndWriter()
    
    private let accendingNotes = [1: "1:A",
                          2: "1:A#|Bb",
                          3: "1:B",
                          4: "1:C",
                          5: "1:C#|Db",
                          6: "1:D",
                          7: "1:D#|Eb",
                          8: "1:E",
                          9: "1:F",
                          10: "1:F#|Gb",
                          11: "1:G",
                          12: "1:G#|Ab",
                          13: "2:A",
                          14: "2:A#|Bb",
                          15: "2:B",
                          16: "2:C",
                          17: "2:C#|Db",
                          18: "2:D",
                          19: "2:D#|Eb",
                          20: "2:E",
                          21: "2:F",
                          22: "2:F#|Gb",
                          23: "2:G",
                          24: "2:G#|Ab",
                          25: "3:A",
                          26: "3:A#|Bb",
                          27: "3:B",
                          28: "3:C",
                          29: "3:C#|Db",
                          30: "3:D",
                          31: "3:D#|Eb",
                          32: "3:E",
                          33: "3:F",
                          34: "3:F#|Gb",
                          35: "3:G",
                          36: "3:G#|Ab",
                          37: "4:A",
                          38: "4:A#|Bb",
                          39: "4:B",
                          40: "4:C",
                          41: "4:C#|Db",
                          42: "4:D",
                          43: "4:D#|Eb",
                          44: "4:E",
                          45: "4:F",
                          46: "4:F#|Gb",
                          47: "4:G",
                          48: "4:G#|Ab"]
    
    /*
     Just a tester to be deleted
     */
    func getJsonScale(stringArr: [String]) {
        for string in stringArr {
            print("\(string)")
        }
    }
    
    /*
     Return the correct octave size
     ----------------
     @param arrayOfNotes: the notes held in the array
     @param numOctaves: an integer of the number of octaves to make the scale
     */
    private func convertToOctaveSize(arrayOfNotes: [String], numOctaves: Int) -> [String] {
        
        // Split the array into two halves
        var octavesArray: [String]
        let splitArr = arrayOfNotes.split()
        var firstHalfArr = splitArr.left
        let secondhalfArr = splitArr.right
        // Add first half of the scale to the array to be retrued
        octavesArray = firstHalfArr
        
        
        // Remove first element in firstHalfArr so as to not have repeating tonics
        firstHalfArr.remove(at: 0)
    
        // Loop through number of octaves and add to the array accordingly accending
        let times = numOctaves - 1
        times.times {
            octavesArray.append(contentsOf: firstHalfArr)
        }
        
        // decending adding
        numOctaves.times {
            octavesArray.append(contentsOf: secondhalfArr)
        }
        
        return octavesArray
    }
    
    /*
     Return an Array of strings with the tonics repeating as desired.
     ----------------
     @param scaleArray: the notes held in the array (with the octaves implemented)
     @param tonicOption: Whether the tonic note will be repeated or note. Cases are; 1: never, 2: always, 3: always/first
     */
    private func convertToTonicOptions(scaleArray: [String], tonicOption: Int) -> [String] {
        var valueArr = scaleArray
        let tonic = valueArr[0]
        var itr = 0
    
        // repeat all tonics
        for note in scaleArray {
            if (note == tonic) {
                valueArr.insert(note, at: itr)
                itr += 1 // so it increments by 2 on this round
            }
            itr += 1
        }
        
        // remove first and last tonics if specified
        if (tonicOption == 3) {
            valueArr.removeFirst()
            valueArr.removeLast()
        }
        return valueArr
    }
    
    /*
     Retruns a scale array that has the characteristics required
     ----------------
     @param baseScale: An array of strings contsining one octave of the scale accending and decending. Only one note per index
     @param octavesToPlay: The number of octaves in the scale. From 1 to 3
     @param tonicOption: Whether the tonic note will be repeated or note. Cases are; 1: never, 2: always, 3: always/first
     @param initialOctave: The octave the scale will start at.
     @param scaleMode: ......
     */
    func convertToScaleArray(baseScale: [String], octavesToPlay: Int, tonicOption: Int, scaleMode: String) -> [String] {
        var alteredScale = baseScale
        
        // Check if it is in a mode of wholetone scale
        if (!scaleMode.isEmpty) {
            // convert to the scale specified
            return ["Was not empty"] /// HAVE TO EDIT THIS SECTION
        }
        
        // Make the scale the desired length from octaves
        if (octavesToPlay > 1) {
            alteredScale = convertToOctaveSize(arrayOfNotes: alteredScale, numOctaves: octavesToPlay)
        }
        
        // Make the scale the desired tonic options
        if (tonicOption > 1) {
            alteredScale = convertToTonicOptions(scaleArray: alteredScale, tonicOption: tonicOption)
        }

        return alteredScale
    }
    
    /*
     Converts the scaleArray into a file readable by playSounds class. e.g. "1:C#|Db", "1:D#|Eb" etc
     ----------------
     @param scaleArray: An Array of String that has all of the notes of the scale in order
     @param initialOctave: The octave the scale will start at.
     @param octavesToPlay: The number of octaves in the scale. From 1 to 3
     */
    func createScaleInfoArray(scaleArray: [String], initialOctave: Int) -> [String] {
        
        // convert the notes into Full name. e.g. A# = A#|Bb
        var scaleInfoArray = scaleArray
        var itr = 0
        var fullNote : String
        
        for note in scaleArray {
            if (note.count > 1) {
                fullNote = getFullNote(singularNote: note)
                scaleInfoArray[itr] = fullNote
            }
            itr += 1
        }
        
        // Add the correct octave number next to the note. e.g. 1:A#|Bb
        scaleInfoArray = appendOctaveNumberToArray(scaleArray: scaleInfoArray, initialOctave: initialOctave)
        
        return scaleInfoArray
    }
    
    /*
     Returns the array with the octave numbers added. e.g. A -> 1:A
     ----------------
     @param scaleArray: An Array of String that has all of the notes of the scale in order
     @param initialOctave: The octave the scale will start at.
     @param octavesToPlay: The number of octaves in the scale. From 1 to 3
     */
    private func appendOctaveNumberToArray(scaleArray: [String], initialOctave: Int) -> [String] {
        
        var scaleArrayWithOctaves : [String]
        var octaveProgressionAscending: [Int] = []
        
        // Split the array into two halves. If there is an uneven number the first half will contain the middle array
        let splitArr = scaleArray.split()
        var firstHalfArr = splitArr.left
        var secondhalfArr = splitArr.right
        
        var octaveNumber = initialOctave
        var previousKey = -1
        var newNoteString : String
        var itr = 0
        
        // Add the correct octave number next to the first half of strings
        for note in firstHalfArr {
            newNoteString = "\(octaveNumber):\(note)"
            previousKey = noteKeyFinder(noteSelected: newNoteString, previousKey: previousKey)
            
            if (previousKey == 100) {
                octaveNumber += 1
                newNoteString = "\(octaveNumber):\(note)"
            }
            octaveProgressionAscending.append(octaveNumber)
            firstHalfArr[itr] = newNoteString
            itr += 1
        }
        
        // reset itr
        itr = 0
        var octavesItr = 0
        // Add the octaves from the octaveProgressionsAscendignArray in reverse order to the secondHalfArray
        if (firstHalfArr.count > secondhalfArr.count) {
            octavesItr = 1
        }
        let reveresedOctaveNumsArr: [Int] = octaveProgressionAscending.reversed()
        
        for note in secondhalfArr {
            octaveNumber = reveresedOctaveNumsArr[octavesItr]
            newNoteString = "\(octaveNumber):\(note)"
            secondhalfArr[itr] = newNoteString
            itr  += 1
            octavesItr += 1
        }
        
        // combine the first and second half arrays 
        scaleArrayWithOctaves = firstHalfArr
        scaleArrayWithOctaves.append(contentsOf: secondhalfArr)
        
        return scaleArrayWithOctaves
    }
    
    /*
     Returns the starting notes key in the musicNotes dictionary
     */
    private func noteKeyFinder(noteSelected: String, previousKey: Int) -> Int { /// MAYBE WILL NEED AN ACCENDING DECENDING CHECK
        
        let selectedNotesKey = accendingNotes.key(from: noteSelected) ?? -1
        if (selectedNotesKey < previousKey && previousKey != 100) {
            return 100; // since 100 is not a valid key and is greater than any previousKey
        } else {
            return selectedNotesKey
        }
    }
    
    /*
     Returns the sound file identifiable note from a signle note
     */
    private func getFullNote(singularNote: String) -> String{
        switch singularNote {
        case "F#", "Gb":
            return "F#|Gb"
        case "C#", "Db":
            return "C#|Db"
        case "G#", "Ab":
            return "G#|Ab"
        case "D#", "Eb":
            return "D#|Eb"
        case "A#", "Bb":
            return "A#|Bb"
        default:
            return singularNote
        }
    }
    
    /*
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
     */
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

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2 + ct % 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
