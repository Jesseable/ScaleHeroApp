//
//  NumbersNoteMapper.swift
//  ScaleHero
//
//  Created by Jesse Graf on 29/1/2025.
//

struct NumbersNoteMapper: NoteMapper {
    typealias Representation = NumberRepresentation
    private var noteNumbers: [Notes: NumberRepresentation]
    
    // Initializer to set up initial mappings
    init(notesArray: [Notes], solFaArry: [NumberRepresentation]) {
        guard notesArray.count == solFaArry.count else {
            fatalError("Number of notes must equal number of SolFa")
        }
//        self.noteNumbers = Dictionary(uniqueKeysWithValues: zip(notesArray, numberArray))

        // Initialize the dictionary
        self.noteNumbers = [:]
        
        // Populate the dictionary
        for (index, note) in notesArray.enumerated() {
            self.noteNumbers[note] = solFaArry[index]
        }
    }
    
    // Function to get the connected SolFa for a given Note
    func getMapping(for note: Notes) throws -> NumberRepresentation {
        guard let numbers = noteNumbers[note] else {
            // Throw an error if the note isn't found
            throw NumbersNoteMapperError.noteNotFound
        }
        return numbers
    }
}

enum NumbersNoteMapperError: Error {
    case noteNotFound
}
