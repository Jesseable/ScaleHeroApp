//
//  MusicArray.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/2024.
//

import Foundation

class MusicArray {
    private let initialStartingNote: Notes
    // TODO: This isn't good atm. I need to make this correct and based off of the initial startingNote. I should be able to do this.
    private lazy var transposedStartingFileNote: FileNotes = {
        var state = TranspositionState.firstTime
        return transposePitch(pitch: Pitch(note: initialStartingNote, octave: NoteOctaveOption.one),
                       to: retrieveTranspositionNote(),
                       isAscending: true,
                       transpositionState: &state).fileNote
    }()
    private var notesArr: [Notes]
    private var pitchArr: [Pitch]?
//    private var solFaArr: [SolFa]? TODO: !!!!!!!!!!!!!!!
//    private var fileNotesArr: [FileNotes]?
    private enum TranspositionState { case firstTime, hasInitialOctaveChange, hasNoInitialOctaveChange }

    init(note: Notes) {
        self.initialStartingNote = note
        self.notesArr = [note]
    }

    init(notes: [Notes]) {
        self.initialStartingNote = notes.first!
        self.notesArr = notes
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
    
    // TODO: Why am I createing and doing this
//    func getFileNotes() -> [FileNotes] {
//        guard fileNotesArr != nil else {
//            return []
//        }
//        return 
//    }
    
    func getPitches() -> [Pitch] {
        // create an error to be thrown here is pitches is still null
        return pitchArr!
    }
    
    func getTransposedStartingNote() -> FileNotes {
        return transposedStartingFileNote
    }
    
    func applyModifications(musicNotes: MusicNotes) {
        // If has Sol-Fa
        
        convertToOctaveSize(numOctaves: musicNotes.octaves)
        applyPitches(with: musicNotes.startingOctave)
        // Everything from here on can use Pitches instead of Notes. TODO:  Somehow make this cleaner later
        
        // if octaveNumber doesn't equal one but invervals are set, then throw an error (I should create a good error for this)
        addIntervalOption(interval: musicNotes.intervalOption, options: musicNotes.intervalType) // TODO: I think they need some renaming...
        
        if (musicNotes.tonicMode != .noRepeatedTonic) {
            convertToTonicOptions(tonicOption: musicNotes.tonicMode)

        }
        if (musicNotes.repeatNotes) {
            repeateAllNotes()
        }
    }
    
    private func applyPitches(with startingOctave: OctaveNumber) {
        var curOctave: NoteOctaveOption = octaveNumToNotesOctaveNum(octavesNum: startingOctave)
        pitchArr = []
        var previousNote: Notes? = nil
        
        for (index, currentNote) in notesArr.enumerated() {
            let isAscending = index < notesArr.count / 2 + 1
            
            if Notes.isOctaveStep(firstNote: previousNote ?? currentNote, secondNote: currentNote, ascending: isAscending) {
                if isAscending {
                    curOctave.increment()
                } else {
                    curOctave.decrement()
                }
            }
            
            pitchArr!.append(Pitch(note: currentNote, octave: curOctave))
            
            previousNote = currentNote
        }
    }
    
    private func octaveNumToNotesOctaveNum(octavesNum: OctaveNumber) -> NoteOctaveOption {
        switch octavesNum {
        case .one: return .one
        case .two: return .two
        case .three: return .three
        }
    }
        
    private func addIntervalOption(interval: Interval, options: IntervalOption) {
        if (interval == Interval.none) {
            return
        }
        
        var resultArr: [Pitch]
        
        switch options {
        case .allUp:
            resultArr = toAllUp(interval: interval)
        case .allDown:
            resultArr = toAllDown(interval: interval)
        case .oneUpOneDown:
            resultArr = toOneUpOneDown(interval: interval)
        case .oneDownOneUp:
            resultArr = toOneDownOneUp(interval: interval)
        }
        pitchArr = resultArr
    }
    
    private func toAllUp(interval: Interval) -> [Pitch] {
        var result: [Pitch] = []
        let splitArr = self.pitchArr!.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        for ascendingNote in ascendingScale {
            result.append(ascendingNote)
            let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
            result.append(nextNote)
        }
        for descendingNote in descendingScale {
            result.append(descendingNote)
            let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
            result.append(nextNote)
        }
        // Add the final Tonic
        result.append(ascendingScale.first!)
        return result
    }
    
    private func toAllDown(interval: Interval) -> [Pitch] {
        var result: [Pitch] = []
        let splitArr = self.pitchArr!.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        for ascendingNote in ascendingScale {
            let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
            result.append(nextNote)
            result.append(ascendingNote)
        }
        for descendingNote in descendingScale {
            let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
            result.append(nextNote)
            result.append(descendingNote)
        }
        // Add the final Tonic
        result.append(ascendingScale.first!)
        return result
    }
    
    private func toOneUpOneDown(interval: Interval) -> [Pitch] {
        var result: [Pitch] = []
        let splitArr = self.pitchArr!.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        for (count, ascendingNote) in ascendingScale.enumerated() {
            if count % 2 == 0 { result.append(ascendingNote) }
            let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
            result.append(nextNote)
            if count % 2 == 1 { result.append(ascendingNote) }
        }
        for (count, descendingNote) in descendingScale.enumerated() {
            if count % 2 == 0 { result.append(descendingNote) }
            let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
            result.append(nextNote)
            if count % 2 == 1 { result.append(descendingNote) }
        }
        // Add the final Tonic
        result.append(ascendingScale.first!)
        return result
    }
    
    private func toOneDownOneUp(interval: Interval) -> [Pitch] {
        var result: [Pitch] = []
        let splitArr = self.pitchArr!.split()
        let ascendingScale = splitArr.left
        var descendingScale = splitArr.right
        adjustDescendingScale(descendingScale: &descendingScale)
        
        for (count, ascendingNote) in ascendingScale.enumerated() {
            if count % 2 == 1 { result.append(ascendingNote) }
            let nextNote = calculatePitch(from: ascendingNote, distance: interval, in: ascendingScale, isAscending: true)
            result.append(nextNote)
            if count % 2 == 0 { result.append(ascendingNote) }
        }
        for (count, descendingNote) in descendingScale.enumerated() {
            if count % 2 == 1 { result.append(descendingNote) }
            let nextNote = calculatePitch(from: descendingNote, distance: interval, in: descendingScale, isAscending: false)
            result.append(nextNote)
            if count % 2 == 0 { result.append(descendingNote) }
        }
        // Add the final Tonic
        result.append(ascendingScale.first!)
        return result
    }
    
    private func adjustDescendingScale(descendingScale: inout [Pitch]) {
        guard let firtNote = descendingScale.first else { return }
        let adjustedPitch = Pitch(note: firtNote.note, octave: Pitch.decreaseOctave(octave: firtNote.octave))
        descendingScale.append(adjustedPitch)
    }
    
    private func calculatePitch(from pitch: Pitch, distance: Interval, in scale: [Pitch], isAscending: Bool) -> Pitch {
        var hasOctaveIncreaseChange = false
        let fromPitchIndex = scale.firstIndex(of: pitch)!
        var nextPitchIndex = 0
        
        if isAscending {
            nextPitchIndex = fromPitchIndex + (distance.rawValue - 1)
            if nextPitchIndex >= (scale.count) {
                nextPitchIndex = (nextPitchIndex % (scale.count)) + 1 // Because there is tonic at the start and end of the scale
                hasOctaveIncreaseChange = true
            }
        } else {
            nextPitchIndex = fromPitchIndex - (distance.rawValue - 1)
            if nextPitchIndex < 0 {
                nextPitchIndex = (elementAtNegativeIndex(array: scale, negativeIndex: nextPitchIndex) ?? 0) - 1 // TODO: Turn into a exception later on... -1 is because of the added B
                hasOctaveIncreaseChange = true
            }
        }
        
        var calculatedPitch: Pitch
        if hasOctaveIncreaseChange {
            let nextPitch = scale[nextPitchIndex]
            calculatedPitch = Pitch(note: nextPitch.note, octave: Pitch.increaseOctave(octave: nextPitch.octave))
        } else {
            calculatedPitch = scale[nextPitchIndex]
        }
        
        return calculatedPitch
    }
    
    // TODO: Rename to finding the index
    private func elementAtNegativeIndex<T> (array: [T], negativeIndex: Int) -> Int? {
        guard negativeIndex < 0, abs(negativeIndex) <= array.count else { return nil } // TODO: Turn into an excpetion so that it doesn't return T?, but instead just T
        return array.count + negativeIndex
    }
    
    // TODO: I will need to add in the octave info here as well. I do not save that at all atm
    private func convertToOctaveSize(numOctaves: OctaveNumber) {
        var resultArr: [Notes]
        let splitArr = self.notesArr.split()
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
        
        self.notesArr = resultArr
    }
    
    private func convertToTonicOptions(tonicOption: TonicOption) {
        var newPitchArr : [Pitch] = []
        for pitch in self.pitchArr! {
            newPitchArr.append(pitch)
            if (pitch.note == initialStartingNote) {
                newPitchArr.append(pitch)
            }
        }
        if (tonicOption == .repeatedTonicAll) {
            self.pitchArr = newPitchArr
            return
        }
        // remove the first and last tonic
        newPitchArr.removeFirst()
        newPitchArr.removeLast()
        
        self.pitchArr = newPitchArr
    }
    
    private func repeateAllNotes() {
        var newPitchArr : [Pitch] = []

        var itr = 0;
        while itr < self.pitchArr!.count {
            newPitchArr.append(self.pitchArr![itr])
            newPitchArr.append(self.pitchArr![itr])
            itr += 1
        }
        self.pitchArr = newPitchArr
    }
    
    func constructTransposedSoundFileArray() -> [FilePitch] {
        let transpositionNote = retrieveTranspositionNote()
        var transpositionState: TranspositionState = .firstTime
        
        var transposedResult: [FilePitch] = []
        
        if (transpositionNote == FileNotes.C) {
            transposedResult = self.pitchArr!.map { pitch in
                FilePitch(fileNote: pitch.note.fileName, octave: pitch.octave)
            }
            return transposedResult
        }
        
        for (index, pitch) in pitchArr!.enumerated() {
            // TODO: Make this a single function that takes an individual note.
            let isAscending = index < pitchArr!.count / 2 + 1
            let transposedFilePitch: FilePitch = transposePitch(pitch: pitch, to: transpositionNote, isAscending: isAscending, transpositionState: &transpositionState)
            transposedResult.append(transposedFilePitch)
        }
        
        return transposedResult
    }
    
    private func retrieveTranspositionNote() -> FileNotes {
        let frw = FileReaderAndWriter()
        return frw.readTranspositionNote()
    }
    
    private func transposePitch(pitch: Pitch, to transpositionNote: FileNotes, isAscending: Bool, transpositionState: inout TranspositionState) -> FilePitch {
        let orderedMusicAlphabet = Notes.orderedMusicAlphabet

        var curOctave = pitch.octave
        if let index = orderedMusicAlphabet.key(for: pitch.note.fileName) {
            if let tnIndex = orderedMusicAlphabet.key(for: transpositionNote) {
                let newIndex = (index + tnIndex) % orderedMusicAlphabet.size()
                let fileNote = orderedMusicAlphabet.value(for: (newIndex + orderedMusicAlphabet.size()) % orderedMusicAlphabet.size())

                if (Notes.isOctaveStep(firstNote: pitch.note.fileName, secondNote: fileNote!, ascending: isAscending)) {
                    switch transpositionState {
                    case .firstTime:
                        // TODO: Ensure that the first oine is still changed
                        transpositionState = .hasInitialOctaveChange
                        
                    case .hasInitialOctaveChange:
                        if !isAscending {
                            curOctave.decrement()
                        }
                    case .hasNoInitialOctaveChange:
                        if isAscending {
                            curOctave.increment()
                        }
                    }
                } else {
                    switch transpositionState {
                    case .firstTime:
                        // TODO: Ensure this still works for the first one...
                        transpositionState = .hasNoInitialOctaveChange

                    case .hasInitialOctaveChange:
                        if isAscending {
                            curOctave.decrement()
                        }
                    case .hasNoInitialOctaveChange:
                        if !isAscending {
                            curOctave.increment()
                        }
                    }
                }
                return FilePitch(fileNote: fileNote!, octave: curOctave)
            }
            // TODO: These need to throw errors instead
            fatalError("The transpisition note was not in the music alphabet")
        }
        fatalError("The pitch was not in the music alphabet")
    }
    
    // TODO: Maybe move this into scaleConstructor... I NEED THIS FOR ENUMS VALUES AS WELL NOW
    // TODO: Add into notes contructor and make it a static method to be used anywhere...
    func rotateScale(by modeDegree: Int) {
        guard !notesArr.isEmpty else { return }
        
        let ascending = notesArr.prefix(notesArr.count / 2 + 1)
        
        let offset = modeDegree % ascending.count
        let rotatedAscending = Array(ascending[offset...] + ascending[1..<(offset + 1)]) // Possibly .reverse fopr the second part
        let rotatedDescending = rotatedAscending.dropLast().reversed()
        
        notesArr = Array(rotatedAscending + rotatedDescending)
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
