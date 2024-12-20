//
//  NotesConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 13/12/2024.
//

// Abstract-like base class for retrieving the scale notes
class NotesConstructorBase<T: TonalityProtocol> {
    
    public var noteNames: [String]
    private var noteNamesFileReadable: [String]
    private var startingNote: String
    private var tonality: T
    
    // TODO: I might be abvle to delete the scaleOptions and tonality from being saved as a class parameter
    init(startingNote: String, tonality: T) {
        self.tonality = tonality
        self.startingNote = startingNote
        
        self.noteNames = []
        self.noteNamesFileReadable = []
    }
    
    func calculateScale() {
        // This is just an example of how to make override work for the subclasses I'll make
        fatalError("Subclasses must implement the 'calculateScale' method.")
    }
    
    // This is awesome. good job
    func getNotes ( // TODO: Tonality is an enum as well. I should be able to chnage this accordingly therefore
        startingNote: String,
        notesSource: [any NotesBase], // This is an array of scales or arpeggios (you can adjust the type accordingly)
        retrieveNotes: (any NoteArrayBase, T) -> [String] // Closure to retrieve notes based on tonality
    ) -> [String] {
        for item in notesSource {
            if item.name == "notes" {
                for array in item.noteArray { // possibly rename it noteArrays. Then I can work with that.
                    if array.note == startingNote {
                        return retrieveNotes(array, tonality)
                    }
                }
            }
        }
        fatalError("Failed to find matching note in data source.")
    }
}
