//
//  ScaleConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/2024.
//

class ScaleConstructor : NotesConstructorBase<ScaleTonality> {
        
    required init(startingNote: Notes, tonality: ScaleTonality) throws {
        try super.init(startingNote: startingNote, tonality: tonality)
        try setScaleArray()
    }
    
    private func setScaleArray() throws {
        let scales = NoteOptions().scales
        
        let scaleStartingNote = self.getStartingNote()
        let modeProtocol : (any ModeProtocol)?

        if (self.tonality.hasModes) {
            modeProtocol = getModeProtocol()
            guard let validModeProtocol = modeProtocol else {
                throw ScalesError.modeNotFound(message: "The tonality '\(self.tonality)' does not have a mode but .hasModes was true")
            }
            if validModeProtocol.modeDegree == 0 {
                try setNotes(jsonScaleStartingNote: scaleStartingNote, notesSource: scales, retrieveNotes: self.retrieveScaleNotes)
                return
            }
            
            let possibleBaseStartingNotes = try returnBaseStartingNote(mode: validModeProtocol)
            try setNotes(jsonScaleStartingNotes: possibleBaseStartingNotes, notesSource: scales, modeStartingNote: scaleStartingNote, retrieveNotes: self.retrieveScaleNotes)
            self.noteNames?.rotateScale(by: modeProtocol!.rawValue)
            return
        }
        
        try setNotes(jsonScaleStartingNote: scaleStartingNote, notesSource: scales, retrieveNotes: self.retrieveScaleNotes)
    }
    
    private func getModeProtocol() -> (any ModeProtocol)? {
        switch self.tonality {
        case .major(mode: let mode):
            return mode
        case .pentatonic(mode: let mode):
            return mode
        default:
            return nil
        }
    }
    
    private func returnBaseStartingNote(mode : any ModeProtocol) throws -> [Notes] {
        let scaleStartingNote = self.getStartingNote()
        
        let modeDegree = mode.modeDegree
        let tonicNoteIndex : Int = Notes.orderedMusicAlphabet.key(for: scaleStartingNote.fileName)!
        if (tonicNoteIndex < 0 || tonicNoteIndex > 12) {
            throw IllegalNoteError.invalidValue(message: "The notes fileName '\(scaleStartingNote.fileName)' does not exist in the musical alphabet")
        }
        
        var baseStartingNoteIndex = tonicNoteIndex - modeDegree
        if (baseStartingNoteIndex < 1) {
            baseStartingNoteIndex = 12 + baseStartingNoteIndex
        }
        
        if let baseStartingNoteFileName = Notes.orderedMusicAlphabet.value(for: baseStartingNoteIndex) {
            return Notes.returnPossibleNotes(for: baseStartingNoteFileName)
        } else {
            fatalError("The base starting note is not found")
        }
    }
    
    func retrieveScaleNotes(for array: any NoteArrayBase, with tonality: ScaleTonality?) -> [Notes] {
        let scales = verifyScaleArrayType(array: array)
        
        // A default to return
        guard let unwrappedScaleTonality = tonality else { return scales.major }
        
        switch unwrappedScaleTonality {
        case .major:
            return scales.major
        case .naturalMinor:
            return scales.naturalMinor
        case .harmonicMinor:
            return scales.harmonicMinor
        case .melodicMinor:
            return scales.melodicMinor
        case .chromatic:
            return scales.chromatic
        case .pentatonic:
            return scales.pentatonic
        case .blues:
            return scales.blues
        }
    }
    
    private func verifyScaleArrayType(array: any NoteArrayBase) -> ScaleArray {
        guard let scaleArray = array as? ScaleArray else {
            fatalError("Expected a ScaleArray, but recieved '\(type(of: array))'")
        }
        return scaleArray
    }
}
