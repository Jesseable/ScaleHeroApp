//
//  MusicArray.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/2024.
//

import Foundation

class MusicArray {
    private var initialStartingNote: Notes
    private var transposedStartingFileNote: FileNotes?
    private var notesArr: [Notes]
    private var transposedNotesArr: [FileNotes]
    private var pitchArr: [Pitch]?
    private var transposedPitchesArr: [FilePitch]? // TODO: Make this when everything is changes and modified.

    init(note: Notes) {
        self.initialStartingNote = note
        self.notesArr = [note]
        transposedNotesArr = []
        transposedStartingFileNote = transposeNote(note: self.initialStartingNote)
        
        self.transposedNotesArr = [transposeNote(note: note)]
    }

    init(notes: [Notes]) {
        self.initialStartingNote = notes.first!
        self.notesArr = notes
        transposedNotesArr = []
        transposedStartingFileNote = transposeNote(note: self.initialStartingNote)

        self.transposedNotesArr = notesArr.map { transposeNote(note: $0) }
    }
    
    func getNotes() -> [Notes] {
        guard let pitchArr = pitchArr else {
            return notesArr
        }

        var notes: [Notes] = []
        for pitch in pitchArr {
            notes.append(pitch.note)
        }
        return notes
    }
    
    func getPitches() -> [Pitch] {
        // create an error to be thrown here is pitches is still null
        return pitchArr!
    }
    
    func getTransposedPitches() -> [FilePitch] {
        // create an error to be thrown here is transposedPitches is still null
        return transposedPitchesArr!
    }
    
    func getTransposedStartingNote() -> FileNotes {
        return transposedStartingFileNote ?? initialStartingNote.fileName
    }
    
    func applyModifications(musicNotes: MusicNotes) {
        convertToOctaveSize(numOctaves: musicNotes.octaves)
        applyPitches(with: musicNotes.startingOctave)
        // Everything from here on can use Pitches instead of Notes. TODO: Somehow make this cleaner later
        
        // if octaveNumber doesn't equal one but invervals are set, then throw an error (I should create a good error for this)
        setIntervaloptions(interval: musicNotes.intervalOption, options: musicNotes.intervalType)
        
        if (musicNotes.tonicMode != .noRepeatedTonic) {
            convertToTonicOptions(tonicOption: musicNotes.tonicMode)

        }
        if (musicNotes.repeatNotes) {
            repeateAllNotes()
        }
    }
    
    private func applyPitches(with startingOctave: OctaveNumber) {
        func processNotes<T: PitchType>(notes: [T.NoteType], into array: inout [T], startingOctave: inout NoteOctaveOption)
        where T.NoteType: NoteTypeProtocol {
            var previousNote: T.NoteType? = nil
            
            for (index, currentNote) in notes.enumerated() {
                let isAscending = index < notes.count / 2 + 1
                
                if let prev = previousNote, T.NoteType.isOctaveStep(firstNote: prev, secondNote: currentNote, ascending: isAscending) {
                    isAscending ? startingOctave.increment() : startingOctave.decrement()
                }
                
                array.append(T(note: currentNote, octave: startingOctave as! T.NoteOctaveOption)) // TODO: What is this. And how is this the function???
                previousNote = currentNote
            }
        }

        var curOctave = octaveNumToNotesOctaveNum(octavesNum: startingOctave)
        var curTransposedOctave = curOctave

        pitchArr = []
        transposedPitchesArr = []

        processNotes(notes: notesArr, into: &pitchArr!, startingOctave: &curOctave)
        processNotes(notes: transposedNotesArr, into: &transposedPitchesArr!, startingOctave: &curTransposedOctave)
    }
    
    private func octaveNumToNotesOctaveNum(octavesNum: OctaveNumber) -> NoteOctaveOption {
        switch octavesNum {
        case .one: return .one
        case .two: return .two
        case .three: return .three
        }
    }
    
    private func setIntervaloptions(interval: Interval, options: IntervalOption) {
        self.pitchArr = addIntervalOption(interval: interval, options: options, pitchArray: pitchArr!)
        self.transposedPitchesArr = addIntervalOption(interval: interval, options: options, pitchArray: transposedPitchesArr!)
    }
        
    private func addIntervalOption<T: PitchType>(interval: Interval, options: IntervalOption, pitchArray: [T]) -> [T] where T.NoteOctaveOption: AdjustableOcataves {
        if (interval == Interval.none) {
            return pitchArray
        }
        
        var resultArr: [T]
        
        switch options {
        case .allUp:
            resultArr = toIntervalOption(interval: interval, isAllUp: true, notesArray: pitchArray)
        case .allDown:
            resultArr = toIntervalOption(interval: interval, isAllUp: false, notesArray: pitchArray)
        case .oneUpOneDown:
            resultArr = toOneUpOneDown(interval: interval, notesArray: pitchArray)
        case .oneDownOneUp:
            resultArr = toOneDownOneUp(interval: interval, notesArray: pitchArray)
        }
        return resultArr
    }
    
    private func toIntervalOption<T: PitchType>(interval: Interval, isAllUp: Bool, notesArray: [T]) -> [T] where T.NoteOctaveOption: AdjustableOcataves {
        var result: [T] = []
        let splitArr = notesArray.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        for ascendingNote in ascendingScale {
            if isAllUp {
                result.append(ascendingNote)
                let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
                result.append(nextNote)
            } else {
                let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
                result.append(nextNote)
                result.append(ascendingNote)
            }
        }
        for descendingNote in descendingScale {
            if isAllUp {
                result.append(descendingNote)
                let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
                result.append(nextNote)
            } else {
                let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
                result.append(nextNote)
                result.append(descendingNote)
            }
        }
        result.append(ascendingScale.first!)
        return result
    }

    private func toOneUpOneDown<T: PitchType>(interval: Interval, notesArray: [T]) -> [T] where T.NoteOctaveOption: AdjustableOcataves {
        return toAlternating(interval: interval, isUpFirst: true, notesArray: notesArray)
    }

    private func toOneDownOneUp<T: PitchType>(interval: Interval, notesArray: [T]) -> [T] where T.NoteOctaveOption: AdjustableOcataves {
        return toAlternating(interval: interval, isUpFirst: false, notesArray: notesArray)
    }

    private func toAlternating<T: PitchType>(interval: Interval, isUpFirst: Bool, notesArray: [T]) -> [T] where T.NoteOctaveOption: AdjustableOcataves {
        var result: [T] = []
        let splitArr = notesArray.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        var toggleState: Bool = isUpFirst
        for (ascendingNote) in ascendingScale {
            if toggleState { result.append(ascendingNote) }
            let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
            result.append(nextNote)
            if !toggleState { result.append(ascendingNote) }
            toggleState.toggle()
        }
        for (descendingNote) in descendingScale {
            if toggleState { result.append(descendingNote) }
            let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
            result.append(nextNote)
            if !toggleState { result.append(descendingNote) }
            toggleState.toggle()
        }
        result.append(ascendingScale.first!)
        return result
    }

    private func calculatePitch<T: PitchType>(from pitch: T, distance: Interval, in scale: [T], isAscending: Bool) -> T where T.NoteOctaveOption: AdjustableOcataves {
        var hasOctaveIncreaseChange = false
        let fromPitchIndex = scale.firstIndex(of: pitch)!
        var nextPitchIndex = 0
        
        if isAscending {
            nextPitchIndex = fromPitchIndex + (distance.rawValue - 1)
            if nextPitchIndex >= scale.count {
                nextPitchIndex = (nextPitchIndex % scale.count) + 1 // Tonic at start and end
                hasOctaveIncreaseChange = true
            }
        } else {
            nextPitchIndex = fromPitchIndex - (distance.rawValue - 1)
            if nextPitchIndex < 0 {
                nextPitchIndex = (elementAtNegativeIndex(array: scale, negativeIndex: nextPitchIndex) ?? 0) - 1
                hasOctaveIncreaseChange = true
            }
        }
        
        var calculatedPitch: T
        if hasOctaveIncreaseChange {
            let nextPitch = scale[nextPitchIndex]
            var octave = nextPitch.getOctave()
            octave.increment()
            calculatedPitch = T(note: nextPitch.getNote(), octave: octave) // Adjust for octave change
        } else {
            calculatedPitch = scale[nextPitchIndex]
        }
        
        return calculatedPitch
    }
    
    private func adjustDescendingScale<T: PitchType>(descendingScale: inout [T]) where T.NoteOctaveOption: AdjustableOcataves {
        guard let firtNote = descendingScale.first else { return }
        var octave = firtNote.getOctave()
        octave.decrement()
        let adjustedPitch = T(note: firtNote.getNote(), octave: octave)
        descendingScale.append(adjustedPitch)
    }
    
    private func elementAtNegativeIndex<T> (array: [T], negativeIndex: Int) -> Int? {
        guard negativeIndex < 0, abs(negativeIndex) <= array.count else { return nil } // TODO: Turn into an excpetion so that it doesn't return T?, but instead just T
        return array.count + negativeIndex
    }
    
    private func convertToOctaveSize(numOctaves: OctaveNumber) {
        self.notesArr = convertToOctaveSize(array: self.notesArr, numOctaves: numOctaves)
        self.transposedNotesArr = convertToOctaveSize(array: self.transposedNotesArr, numOctaves: numOctaves)
    }
    
    private func convertToOctaveSize<T>(array: [T], numOctaves: OctaveNumber) -> [T] {
        var resultArr: [T]
        let splitArr = array.split()
        var firstHalfArr = splitArr.left
        let secondHalfArr = splitArr.right
        resultArr = firstHalfArr
        
        // Remove first element in firstHalfArr so as to not have repeating tonics
        firstHalfArr.remove(at: 0)
    
        // Loop through number of octaves and add to the array accordingly accending
        let times = numOctaves.rawValue - 1
        times.times {
            resultArr.append(contentsOf: firstHalfArr)
        }
        
        // decending adding
        numOctaves.rawValue.times {
            resultArr.append(contentsOf: secondHalfArr)
        }
        
        return resultArr
    }
    
    private func convertToTonicOptions(tonicOption: TonicOption) {
        self.pitchArr = convertToTonicOptions(tonicOption: tonicOption, noteArray: self.pitchArr!)
        self.transposedPitchesArr = convertToTonicOptions(tonicOption: tonicOption, noteArray: self.transposedPitchesArr!)
    }
    
    private func convertToTonicOptions<T: PitchType>(tonicOption: TonicOption, noteArray: [T]) -> [T] {
        var resultArr: [T] = []
        
        for pitchType in noteArray {
            resultArr.append(pitchType)
            if pitchType.isEqual(to: self.initialStartingNote) {
                resultArr.append(pitchType)
            }
        }
        
        if tonicOption == .repeatedTonicAll {
            return resultArr
        }
        
        // Remove the first and last tonic
        resultArr.removeFirst()
        resultArr.removeLast()
        
        return resultArr
    }
    
    private func repeateAllNotes() {
        self.pitchArr = repeatAllNotes(noteArray: self.pitchArr!)
        self.transposedPitchesArr = repeatAllNotes(noteArray: self.transposedPitchesArr!)
    }
    
    private func repeatAllNotes<T: PitchType>(noteArray: [T]) -> [T] {
        var resultArr: [T] = []
        for note in noteArray {
            resultArr.append(note)
            resultArr.append(note)
        }
        return resultArr
    }
    
    private func retrieveTranspositionNote() -> FileNotes {
        let frw = FileReaderAndWriter()
        return frw.readTranspositionNote()
    }
    
    private func transposeNote(note: Notes) -> FileNotes {
        let orderedMusicAlphabet = Notes.orderedMusicAlphabet
        let transpositionNote = retrieveTranspositionNote()
        
        guard let noteIndex = orderedMusicAlphabet.key(for: note.fileName),
              let transpositionIndex = orderedMusicAlphabet.key(for: transpositionNote) else {
            fatalError("Invalid note: \(note.fileName) or transposition note: \(transpositionNote)")
        }

        let newIndex = (noteIndex + transpositionIndex) % orderedMusicAlphabet.size()
        let fileNote = orderedMusicAlphabet.value(for: (newIndex + orderedMusicAlphabet.size()) % orderedMusicAlphabet.size())
        
        return fileNote!
    }
    
    static func rotateScale<T>(of array: [T], by modeDegree: Int) -> [T] {
        guard !array.isEmpty else { return [] }
        
        let ascending = array.prefix((array.count / 2) + 1)
        
        let offset = modeDegree % ascending.count
        let rotatedAscending = Array(ascending[offset...] + ascending[1..<(offset + 1)])
        let rotatedDescending = rotatedAscending.dropLast().reversed()
        
        return Array(rotatedAscending + rotatedDescending)
    }
    
    // Rotates the scale into the correct mode.
    func rotateNotes(by modeDegree: Int) {
        self.notesArr = Self.rotateScale(of: self.notesArr, by: modeDegree)
        self.transposedNotesArr = Self.rotateScale(of: self.transposedNotesArr, by: modeDegree)
        self.initialStartingNote = self.notesArr.first!
        self.transposedStartingFileNote = self.transposedNotesArr.first!
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

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2 + ct % 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
