//
//  SolFaNoteMapper.swift
//  ScaleHero
//
//  Created by Jesse Graf on 26/1/2025.
//

struct SolFaNoteMapper {
    // A dictionary to map Notes to SolFa
    private var noteToSolFa: [Notes: SolFa]
    
    // Initializer to set up initial mappings
    init(notesArray: [Notes], solFaArry: [SolFa]) {
        guard notesArray.count == solFaArry.count else {
            fatalError("Number of notes must equal number of SolFa")
        }
        // Initialize the dictionary
        self.noteToSolFa = [:]
        
        // Populate the dictionary
        for (index, note) in notesArray.enumerated() {
            self.noteToSolFa[note] = solFaArry[index]
        }
    }
    
    // Function to get the connected SolFa for a given Note
    func getSolFa(for note: Notes) throws -> SolFa {
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
