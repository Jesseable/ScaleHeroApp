//
//  ArpeggioConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 15/12/2024.
//

class ArpeggioConstructor : NotesConstructorBase<ArpeggioTonality> {
            
    override init(startingNote: String, tonality: ArpeggioTonality) {
        super.init(startingNote: startingNote, tonality: tonality)
        let arpeggios = NoteOptions().arpeggios
        noteNames = getNotes(startingNote: startingNote, notesSource: arpeggios, retrieveNotes: retrieveScaleNotes)
    }

    func retrieveScaleNotes(for array: any NoteArrayBase, with tonality: ArpeggioTonality) -> [String] {
        let arpeggios = verifyArpeggioArrayType(array: array)
        
        switch tonality {
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
