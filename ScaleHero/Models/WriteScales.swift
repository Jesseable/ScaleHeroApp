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
    
    // constants required
    let INVALID_KEY = 100 // since 100 is not a valid key and is greater than any previousKey
    
    //let type : String
    var scaleOptions: ScaleOptions
    
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
     Queries the json file scale-data to get the scale data for the starting note
     ----------------
     @param startingNote: the tonic of the scale
     Returns: a string array containing the scale notes to be outputted (1 octave with no repeating tonics)
     */
    private func getScale(startingNote: String, tonality: ScaleTonality) -> [String] {
        let scales = scaleOptions.scales
        
        for scale in scales {
            if (scale.name.elementsEqual("notes")) {
                for scaleArray in scale.scaleArrays {
                    if (scaleArray.note.elementsEqual(startingNote)) {
                        let baseScaleNotes = retrieveScaleRawNotes(for: scaleArray, with: tonality)
                        return baseScaleNotes
                    }
                }
            }
        }
        fatalError("failed due to not being able to read base scale notes from the json file")
    }
    
    /*
     Queries the json file scale-data to get the arpeggio data for the starting note
     ----------------
     @param startingNote: the tonic of the scale
     Returns: a string array containing the arpeggio notes to be outputted (1 octave with no repeating tonics)
     */
    private func getArpeggio(startingNote: String, tonality: ArpeggioTonality) -> [String] {
        let arpeggios = scaleOptions.arpeggios
        
        for arpeggio in arpeggios {
            if (arpeggio.name.elementsEqual("notes")) {
                for arpeggioArray in arpeggio.arpeggioArrays {
                    if (arpeggioArray.note.elementsEqual(startingNote)) {
                        let baseArpeggioNotes = retrieveArpeggioRawNotes(for: arpeggioArray, with: tonality)
                        return baseArpeggioNotes
                    }
                }
            }
        }
        fatalError("failed due to not being able to read base arpeggio notes from the json file")
    }
    
    /*
     Retrieves the arpeggio array from the ArpeggioArrays struct (read from the json file scale-data)
     ----------------
     @param array: the array of arpeggios to select from
     @param tonality: The arpeggio type/tonality to select
     Returns: a string array containing the arpeggio notes
     */
    private func retrieveArpeggioRawNotes(for array: ArpeggioArrays, with tonality: ArpeggioTonality) -> [String] {
        switch tonality {
        case .major:
            return array.major
        case .minor:
            return array.minor
        case .dominant7th:
            return array.dominant7th
        case .diminished7th:
            return array.diminished7th
        case .major7th:
            return array.major7th
        case .minor7th:
            return array.minor7th
        }
    }
    
    /*
     Retrieves the scale array from the ScaleArrays struct (read from the json file scale-data)
     ----------------
     @param array: the array of scales to select from
     @param tonality: The scale type/tonality to select
     Returns: a string array containing the scale notes
     */
    private func retrieveScaleRawNotes(for array: ScaleArrays, with tonality: ScaleTonality) -> [String] {
        switch tonality {
        case .major:
            return array.major
        case .naturalMinor:
            return array.naturalMinor
        case .harmonicMinor:
            return array.harmonicMinor
        case .melodicMinor:
            return array.melodicMinor
        case .chromatic:
            return array.chromatic
        case .pentatonic:
            return array.pentatonic
        case .blues:
            return array.blues
        }
    }
    
    /*
     From the starting note and type of scale (arpeggio or scale), the scale is returned from the json file scale-data
     ----------------
     @param type: enum Case, containing either arpeggio or scale
     @param firstNote: the tonic of the scale
     Returns: a string array containing the notes to be outputted (1 octave with no repeating tonics)
     */
    func returnScaleNotesArray(for type: Case, startingAt firstNote: String) -> [String] {
        switch type {
        case .arpeggio(let tonality):
            return getArpeggio(startingNote: firstNote, tonality: tonality)
        case .scale(let tonality):
            return getScale(startingNote: firstNote, tonality: tonality)
        }
    }
    
    /*
     Alters a string array of notes (symbolising one octave) to contain
         the number of octaves specified in the function.
     ----------------
     @param arrayOfNotes: the notes held in the array
     @param numOctaves: an integer of the number of octaves to make the scale
     Returns: a string array containing the notes to be outputted in order with
         the correct number of octaves
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
     Alters an array of notes to repeat tonics.
     ----------------
     @param scaleArray: the notes held in the array (with the octaves implemented)
     @param tonicOption: Whether the tonic note will be repeated or note.
         Cases are; 1: never, 2: always, 3: always/first
     Returns: an Array of strings with the tonics repeating as desired.
     */
    private func convertToTonicOptions(scaleArray: [String], tonicOption: TonicOption) -> [String] {
        var valueArr = scaleArray
        let tonic = valueArr[0]
        var itr = 0
    
        // repeat all tonics
        for note in scaleArray {
            if (note == tonic) {
                valueArr.insert(note, at: itr)
                itr += 1 // Jumps over the added tonic
            }
            itr += 1
        }
        
        // remove first and last tonics if specified
        if (tonicOption == TonicOption.repeatedTonic) {
            valueArr.removeFirst()
            valueArr.removeLast()
        }
        return valueArr
    }
    
    /*
     Takes in a string array of a 1 octave scale and alters it depending on the inputted arguments.
     ----------------
     @param baseScale: An array of strings contsining one octave of the scale accending and decending. Only one note per index
     @param octavesToPlay: The number of octaves in the scale. From 1 to 3
     @param tonicOption: Whether the tonic note will be repeated or note. Cases are; 1: never, 2: always, 3: always/first
     @param initialOctave: The octave the scale will start at.
     @param scaleMode: ......
     Retruns: a string array containing a scale array that has the required characteristics
     */
    func convertToScaleArray(baseScale: [String], octavesToPlay: Int, tonicOption: TonicOption, scaleType: ScaleType? = nil) -> [String] {
        var alteredScale : [String]
        
        // convert to the scale specified
        switch scaleType {
        case .wholetone:
            alteredScale = convertToWholeToneScale(scaleArray: baseScale)
        case .majorMode(mode: let mode):
            alteredScale = convertToScaleMode(scaleArray: baseScale, mode: mode)
        case .pentatonicMode(mode: let mode):
            alteredScale = convertToPentatonicMode(scaleArray: baseScale, mode: mode)
        case .none:
            alteredScale = baseScale
        }
        
        // Make the scale the desired length from octaves
        if (octavesToPlay > 1) {
            alteredScale = convertToOctaveSize(arrayOfNotes: alteredScale, numOctaves: octavesToPlay)
        }
        
        // Make the scale the desired tonic options
        if (tonicOption != TonicOption.noRepeatedTonic) {
            alteredScale = convertToTonicOptions(scaleArray: alteredScale, tonicOption: tonicOption)
        }

        return alteredScale
    }
    
    /*
     Converts a major scale to the modal scale specified
     ----------------
     @param scaleArray: An array of strings containing one octave of scale notes (ascending and descending).
     @param scaleArray: A ScaleMode, e.g. dorian, phrygian, ionian etc
     Retruns: a string array containing a scale array that has the modified mode
     */
    func convertToScaleMode(scaleArray: [String], mode: MajorScaleMode) -> [String] {
        if (scaleArray.count != 15) {
            return ["Major scale not used when playing a major mode"]
        }
        let tonicNote = scaleArray[0]
        let startingIonianNote = AlterNotes().getMajorIonianStartingNote(from: tonicNote, in: mode)

        var scaleModeArr = returnScaleNotesArray(for: .scale(tonality: .major), startingAt: startingIonianNote)
        // rotate this scale to the appropriate tonic note for the scale
        MajorScaleMode.allCases.forEach {
            if ($0 == mode) {
                $0.rawValue.times {
                    scaleModeArr = rotateScale(scaleArray: scaleModeArr)
                }
            }
        }
        return scaleModeArr
    }
    
    /*
     Converts a major scale to the modal scale specified
     ----------------
     @param scaleArray: An array of strings containing one octave of scale notes (ascending and descending).
     @param scaleArray: A ScaleMode, e.g. dorian, phrygian, ionian etc
     Retruns: a string array containing a scale array that has the modified mode
     */
    func convertToPentatonicMode(scaleArray: [String], mode: PentatonicScaleMode) -> [String] {
        if (scaleArray.count != 11) {
            return ["Pentatonic scale not used when playing a pentatonic mode"]
        }
        let tonicNote = scaleArray[0]
        let startingMajorPentatonicNote = AlterNotes().getMajorPentatonicStartingNote(from: tonicNote, in: mode)

        var scaleModeArr = returnScaleNotesArray(for: .scale(tonality: .pentatonic), startingAt: startingMajorPentatonicNote)
        // rotate this scale to the appropriate tonic note for the scale
        PentatonicScaleMode.allCases.forEach {
            if ($0 == mode) {
                $0.rawValue.times {
                    scaleModeArr = rotateScale(scaleArray: scaleModeArr)
                }
            }
        }
        return scaleModeArr
    }
    
    private func rotateScale(scaleArray: [String]) -> [String] {

        var rotatedScaleArr = scaleArray
        var i = 0
        var j = 0
        let newMiddleNoteIndex = scaleArray.count / 2 - 1
        let finalIndex = scaleArray.count - 1
        
        while (i < finalIndex) {

            rotatedScaleArr[i] = scaleArray[j + 1]
            i += 1
            j += 1
            
            if (i == newMiddleNoteIndex) { // The first note
                rotatedScaleArr[i] = scaleArray[j + 1]
                rotatedScaleArr[i + 1] = rotatedScaleArr[0]
                rotatedScaleArr[i + 2] = rotatedScaleArr[j + 1]
                i += 2
            }
        }
        // first note and last note are both the tonic
        rotatedScaleArr[finalIndex] = rotatedScaleArr[0]
        
        return rotatedScaleArr
    }
    
    func convertToWholeToneScale(scaleArray: [String]) -> [String] {
        // check it has a chromatic scale given (only chromatic scales can be turned into wholetone
        if (scaleArray.count != 25) {
            return ["Whole Tone Scale Failed, Invalid Input"]
        }
        let newCount = scaleArray.count/2 + 1 // avoid odd numbers
        let scaleWholeToneArray = (0..<newCount).map { scaleArray[$0 + $0] }
        return scaleWholeToneArray
    }
    
    /*
     Converts the scaleArray into a file readable by playSounds class. e.g. "1:C#|Db", "1:D#|Eb" etc
     ----------------
     @param scaleArray: An Array of String that has all of the notes of the scale in order
     @param initialOctave: The octave the scale will start at.
     Returns: a string array containing the sound file readable format: "[octave_num]:[note_name]"
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
     Inserts the octave numbers beside each note in the scale array
     ----------------
     @param scaleArray: An Array of String that has all of the notes of the scale in order
     @param initialOctave: The octave the scale will start at
     Returns: A string array of the notes with the addition of octave numbers beside them. e.g. A -> 1:A
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
            
            if (previousKey == INVALID_KEY) {
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
    private func noteKeyFinder(noteSelected: String, previousKey: Int) -> Int {
        
        let selectedNotesKey = accendingNotes.key(from: noteSelected) ?? -1
        if (selectedNotesKey < previousKey && previousKey != 100) {
            return INVALID_KEY;
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
     Converts the scale array of one octave notes with octave numbers into a scale pattern with a specified
         interval (e.g. 3rds) and style (e.g. One up One down)
     ----------------
     @param interval: An enum containing all interval options
     @param option: An enum containing the style of the intervals (OneUpOneDown, AllUp, AllDown, OneDownOneUp)
     @param scale: An array of strings that contain all notes in the scale ascending order (1 octave) and octave numbers
     Returns: A string array of the notes in the correct inerval pattern with the chosen style
     */
    func convertToIntervals(of interval: Interval, with option: IntervalOption, for scale: [String]) -> [String] {
        let newArraySize = scale.count * 2 - 1
        var intervalsAddedArray : [String]
        
        switch option {
        case .allUp:
            intervalsAddedArray = allUp(for: scale, with: interval, arraySize: newArraySize)
        case .allDown:
            intervalsAddedArray = allDown(for: scale, with: interval, arraySize: newArraySize)
        case .oneUpOneDown:
            intervalsAddedArray = oneUpOneDown(for: scale, with: interval, arraySize: newArraySize)
        case .oneDownOneUp:
            intervalsAddedArray = oneDownOneUp(for: scale, with: interval, arraySize: newArraySize)
        }
        
        return intervalsAddedArray
    }
    
    /*
     Retrieves the element from the notes array with the correct octave number
     ----------------
     @param scale: An array of strings that contain all notes in the scale ascending order (1 octave) and octave numbers
     @param indexNum: The index number (from 1) of the new element
     @param topTonicPosition: The index position of the top tonic number (from 1)
     Returns: A string containing a sound file readable note
     */
    private func getNoteElement(from scale: [String], for indexNum: Int, with topTonicPosition: Int) -> String {
        let alterNotes = AlterNotes()
        var newElement : String
        
        if (indexNum > topTonicPosition) {
            newElement = scale[indexNum - topTonicPosition]
            newElement = alterNotes.changeOctaveNumber(AlterAmount.increase, for: newElement)
            
        } else if (indexNum <= 0) {
            newElement = scale[indexNum + (topTonicPosition - 2)]
            newElement = alterNotes.changeOctaveNumber(AlterAmount.decrease, for: newElement)
            
        } else {
            newElement = scale[indexNum - 1]
        }
        
        return newElement
    }
    
    // Could change these all to one function taking an enum
    private func allUp(for scale: [String], with interval: Interval, arraySize: Int) -> [String] {
        var newArray = Array(repeating: "", count: arraySize)
        let topTonicScaleNotePos = scale.count / 2 + 1
        var ascending = true
        var secondTime = false
        var i = 0
        var j = 1
        
        while (i < arraySize) {
            
            if (j == topTonicScaleNotePos && ascending == true) {
                if (secondTime) {
                    ascending = false // start descending in the scale
                } else {
                    secondTime = true
                }
            }
            newArray[i] = getNoteElement(from: scale, for: j, with: topTonicScaleNotePos)
            
            if (ascending) {
                (i % 2 == 0) ? (j = j + interval.rawValue - 1) : (j = j - (interval.rawValue - 2))
            } else {
                (i % 2 == 0) ? (j = j - (interval.rawValue - 1)) : (j = j + (interval.rawValue - 2))
            }
            i += 1
        }
        
        return newArray
    }
    
    func allDown(for scale: [String], with interval: Interval, arraySize: Int) -> [String] {
        var newArray = Array(repeating: "", count: arraySize)
        let topTonicScaleNotePos = scale.count / 2 + 1
        var ascending = true
        var i = 0
        var j = interval.rawValue
        
        while (i < arraySize) {
            
            if ((j - (interval.rawValue - 1)) == topTonicScaleNotePos && ascending == true) {
                j -= (interval.rawValue - 1)
                ascending = false // start descending in the scale
            }
            newArray[i] = getNoteElement(from: scale, for: j, with: topTonicScaleNotePos)
            
            if (ascending) {
                (i % 2 == 1) ? (j = j + interval.rawValue) : (j = j - (interval.rawValue - 1))
            } else {
                (i % 2 == 1) ? (j = j - (interval.rawValue)) : (j = j + (interval.rawValue - 1))
            }
            i += 1
        }
        
        return newArray
    }
    
    func oneUpOneDown(for scale: [String], with interval: Interval, arraySize: Int) -> [String] {
        var newArray = Array(repeating: "", count: arraySize + 1)
        let topTonicScaleNotePos = scale.count / 2 + 1
        var ascending = true
        var i = 0
        var j = 1
        
        while (i < arraySize + 1) {
            
            if ((j - (interval.rawValue - 1)) == topTonicScaleNotePos && ascending == true) {
                j -= (interval.rawValue - 1)
                ascending = false // start descending in the scale
            }
            newArray[i] = getNoteElement(from: scale, for: j, with: topTonicScaleNotePos)
            
            if (ascending) {
                if (i % 2 == 0) {
                    (i % 4 == 0) ? (j = j + (interval.rawValue - 1)) : (j = j - (interval.rawValue - 1))
                } else {
                    j = j + 1
                }
            } else {
                if (i % 2 == 0) {
                    (i % 4 == 0) ? (j = j - (interval.rawValue - 1)) : (j = j + (interval.rawValue - 1))
                } else {
                    j = j - 1
                }
            }
            i += 1
        }
        return newArray
    }
    
    func oneDownOneUp(for scale: [String], with interval: Interval, arraySize: Int) -> [String] {
        let numArraySize : Int
        switch interval {
        case .thirds:
            numArraySize = arraySize
        case .fourths:
            numArraySize = arraySize - 1
        case .fifths:
            numArraySize = arraySize + 5
        }
        var newArray = Array(repeating: "", count: numArraySize)
        let topTonicScaleNotePos = scale.count / 2 + 1
        var ascending = true
        var secondTime = false
        var i = 0
        var j = interval.rawValue
        
        while (i < numArraySize) {
            
            if (j - 1 == topTonicScaleNotePos && ascending == true) {
                if (secondTime) {
                    ascending = false // start descending in the scale
                } else {
                    secondTime = true
                }
            }
            newArray[i] = getNoteElement(from: scale, for: j, with: topTonicScaleNotePos)
            
            if (ascending) {
                if (i % 2 == 0) {
                    (i % 4 == 0) ? (j = j - (interval.rawValue - 1)) : (j = j + (interval.rawValue - 1))
                } else {
                    j = j + 1
                }
            } else {
                if (i % 2 == 0) {
                    (i % 4 == 0) ? (j = j + (interval.rawValue - 1)) : (j = j - (interval.rawValue - 1))
                } else {
                    j = j - 1
                }
            }
            i += 1
        }
        return newArray
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

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2 + ct % 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
