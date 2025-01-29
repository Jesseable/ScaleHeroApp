//
//  SolFaNoteMapper.swift
//  ScaleHero
//
//  Created by Jesse Graf on 26/1/2025.
//

protocol NoteMapper {
    associatedtype Representation
    func getMapping(for note: Notes) throws -> Representation
}

struct SolFaNoteMapper: NoteMapper {
    typealias Representation = SolFa
    private var noteToSolFa: [Notes: SolFa]
    
    init(notesArray: [Notes], solFaArry: [SolFa]) {
        guard notesArray.count == solFaArry.count else {
            fatalError("Number of notes must equal number of SolFa")
        }
//        self.noteToSolFa = Dictionary(uniqueKeysWithValues: zip(notesArray, solFaArray))
        // Initialize the dictionary
        self.noteToSolFa = [:]
        
        // Populate the dictionary
        for (index, note) in notesArray.enumerated() {
            self.noteToSolFa[note] = solFaArry[index]
        }
    }
    
    // Function to get the connected SolFa for a given Note
    func getMapping(for note: Notes) throws -> SolFa {
        guard let solFa = noteToSolFa[note] else {
            // Throw an error if the note isn't found
            throw SolFaNoteMapperError.noteNotFound
        }
        return solFa
    }
}

enum SolFaNoteMapperError: Error {
    case noteNotFound
}
