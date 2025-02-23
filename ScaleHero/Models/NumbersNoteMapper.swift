//
//  NumbersNoteMapper.swift
//  ScaleHero
//
//  Created by Jesse Graf on 29/1/2025.
//

struct NumbersNoteMapper: NoteMapper {
    typealias Representation = NumberRepresentation
    private var noteNumbers: [Notes: NumberRepresentation]
    
    init(notesArray: [Notes], numberArray: [NumberRepresentation]) {
        guard notesArray.count == numberArray.count else {
            fatalError("Number of notes must equal number of numberArray")
        }

        self.noteNumbers = [:]
        
        // Populate the dictionary
        for (index, note) in notesArray.enumerated() {
            self.noteNumbers[note] = numberArray[index]
        }
    }
    
    func getMapping(for note: Notes) throws -> NumberRepresentation {
        guard let numbers = noteNumbers[note] else {
            throw NumbersNoteMapperError.noteNotFound
        }
        return numbers
    }
}

enum NumbersNoteMapperError: Error {
    case noteNotFound
}
