//
//  ScaleConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/2024.
//

class ScaleConstructor : NotesConstructorBase<ScaleTonality> {
        
    override init(startingNote: String, tonality: ScaleTonality) {
        super.init(startingNote: startingNote, tonality: tonality)
        let scales = NoteOptions().scales
        noteNames = getNotes(startingNote: startingNote, notesSource: scales, retrieveNotes: retrieveScaleNotes)
    }
    
    func retrieveScaleNotes(for array: any NoteArrayBase, with tonality: ScaleTonality) -> [String] {
        let scales = verifyScaleArrayType(array: array)
        
        switch tonality {
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
            fatalError("Expected a ScaleArray, but got something else.")
        }
        return scaleArray
    }
}
