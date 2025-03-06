//
//  NotesConstructor.swift
//  ScaleHero
//
//  Created by Jesse Graf on 13/12/2024.
//

// Abstract-like base class for retrieving the scale notes
class NotesConstructorBase<T: TonalityProtocol> {
    
    // These two will be set in the getNotes class which is called in the subClasses
    public var musicArray: MusicArray?
    private var startingNote: Notes
    public var tonality: T
    
    // TODO: I might be abvle to delete the scaleOptions and tonality from being saved as a class parameter
    required init(startingNote: Notes, tonality: T) throws { // Maybe take in the MuscNote (In ScalesView).
        self.tonality = tonality
        self.startingNote = startingNote
    }
    
    func getStartingNote () -> Notes {
        return startingNote
    }
    
    func setNotes (
        jsonScaleStartingNote: Notes, // TODO: THis is a class variable atm. I should be able ot just remove it from this function parameters.
        notesSource: [any NotesBase], // This is an array of scales or arpeggios (you can adjust the type accordingly)
        retrieveNotes: (any NoteArrayBase, T?) -> [Notes] // Closure to retrieve notes based on tonality
    ) throws {
        try setNotes(jsonScaleStartingNotes: [jsonScaleStartingNote], notesSource: notesSource, retrieveNotes: retrieveNotes)
    }
    
    func setNotes (
        jsonScaleStartingNotes: [Notes],
        notesSource: [any NotesBase], // This is an array of scales or arpeggios (you can adjust the type accordingly)
        modeStartingNote: Notes? = nil,
        retrieveNotes: (any NoteArrayBase, T?) -> [Notes] // Closure to retrieve notes based on tonality
    ) throws {
        for item in notesSource {
            if item.name == "notes" {
                for array in item.noteArray {
                    if jsonScaleStartingNotes.contains(array.note) {
                        let noteArray = retrieveNotes(array, tonality)
                        musicArray = MusicArray(notes: noteArray)
                        
                        guard let unwrappedModeStartingNote = modeStartingNote else {
                            if jsonScaleStartingNotes.first!.isIdentical(to: array.note) {
                                return
                            }
                            continue
                        }
                        
                        // check if the modeStartingNote exists in the major scale:
                        let defaultNotes = retrieveNotes(array, nil)
                        if defaultNotes.first(where: { $0.isIdentical(to: unwrappedModeStartingNote) }) != nil {
                            return
                        }
                    }
                }
            }
        }
        throw IllegalNoteError.invalidValue(message: "Notes: '\(jsonScaleStartingNotes.map { $0.name }.joined(separator: ", "))' not found in \(tonality.name) json options")
    }
}
