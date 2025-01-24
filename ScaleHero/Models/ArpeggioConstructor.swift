//
//  ArpeggioConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/2024.
//

class ArpeggioConstructor : NotesConstructorBase<ArpeggioTonality> {
            
    required init(startingNote: Notes, tonality: ArpeggioTonality) throws {
        try super.init(startingNote: startingNote, tonality: tonality)
        try setApreggioArray()
    }
    
    private func setApreggioArray() throws {
        let arpeggios = NoteOptions().arpeggios
        
        let startingNote = self.getStartingNote()
//        let modeProtocol : (any ModeProtocol)?         // TODO: Allow modes in arpeggios as well
        
        try setNotes(jsonScaleStartingNote: startingNote, notesSource: arpeggios, retrieveNotes: self.retrieveScaleNotes)
    }

    func retrieveScaleNotes(for array: any NoteArrayBase, with tonality: ArpeggioTonality?) -> [Notes] {
        let arpeggios = verifyArpeggioArrayType(array: array)
        
        // A default to return
        guard let unwrappedArpeggioTonality = tonality else { return arpeggios.major }
        
        switch unwrappedArpeggioTonality {
        case .major:
            return arpeggios.major
        case .minor:
            return arpeggios.minor
        case .dominant7th:
            return arpeggios.dominant7th
        case .diminished7th:
            return arpeggios.diminished7th
        case .major7th:
            return arpeggios.major7th
        case .minor7th:
            return arpeggios.minor7th
        }
    }

    private func verifyArpeggioArrayType(array: any NoteArrayBase) -> ArpeggioArray {
        guard let scaleArray = array as? ArpeggioArray else {
            fatalError("Expected a ArpeggioArray, but got something else.")
        }
        return scaleArray
    }
}
