//
//  ArpeggioConstructorTests.swift
//  ScaleHero
//
//  Created by Jesse Graf on 20/12/2024.
//

import XCTest
@testable import ScaleHero

class ArpeggioConstructorTests: XCTestCase {
    
    let scaleOptions = NoteOptions()
    var arpeggioConstructor: ArpeggioConstructor?

    /*
     Initialise the fileReaderAndWriter
     */
    override class func setUp() {
        let fileReaderAndWriter = FileReaderAndWriter()
        fileReaderAndWriter.writeNewTransposition(newTransposition: Notes.C.name)
    }
    
    func testJsonFileReturnsArpeggio_basic() {
        do {
            self.arpeggioConstructor = try ArpeggioConstructor(startingNote: Notes.C, tonality: ArpeggioTonality.major)
            
            let expectedMajorArpeggio: [Notes] = [.C, .E, .G, .C, .G, .E, .C]
            
            XCTAssertEqual(expectedMajorArpeggio, self.arpeggioConstructor!.musicArray?.getNotes(), "jsonFile reading for C major arpeggio failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testJsonFileReturnsArpeggio_diminished7th() throws {
        do {
            self.arpeggioConstructor = try ArpeggioConstructor(startingNote: Notes.D_FLAT, tonality: ArpeggioTonality.diminished7th)
            
            let expectedDbDiminished7th: [Notes] = [.D_FLAT, .F_FLAT, .A_DOUBLE_FLAT, .C_DOUBLE_FLAT, .D_FLAT, .C_DOUBLE_FLAT, .A_DOUBLE_FLAT, .F_FLAT, .D_FLAT]

            
            XCTAssertEqual(expectedDbDiminished7th, self.arpeggioConstructor!.musicArray?.getNotes(), "jsonFile reading for Db diminished 7th failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testJsonFileReturnsArpeggio_allNotes() {
        let notes = setValidAndInvalidNoteNames()
        
        for note in notes.validNoteNames {
            do {
                arpeggioConstructor = try ArpeggioConstructor(startingNote: note, tonality: ArpeggioTonality.minor)
                if (arpeggioConstructor!.musicArray?.getNotes() == nil) {
                    XCTFail("ScaleConstructor for '\(note)' was empty")
                }
            } catch IllegalNoteError.invalidValue(let message) {
                XCTFail(message)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        for note in notes.invalidNoteNames {
            do {
                self.arpeggioConstructor = try ArpeggioConstructor(startingNote: note, tonality: ArpeggioTonality.minor)
                // The note of the returned array should not match the actuall note name. But they will be identical file names
                if (self.arpeggioConstructor!.musicArray?.getNotes() != nil && self.arpeggioConstructor!.musicArray?.getNotes().first?.name == note.name) {
                    XCTFail("ArpeggioConstructor for '\(note)' was set. But this note should be illegal. \n"
                            + "The scale returned is: '\(String(describing: self.arpeggioConstructor!.musicArray?.getNotes().first?.name))'")
                }
            } catch IllegalNoteError.invalidValue(let message) {
                XCTAssertEqual("Notes: '\(note.name)' not found in Minor Arpeggio json options", message)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    private func setValidAndInvalidNoteNames() -> (validNoteNames: [Notes], invalidNoteNames: [Notes]) {
        var validNoteNames: [Notes] = []
        var invalidNoteNames: [Notes] = []
        
        for note in Notes.allCases {
            if note.name.contains("double") {
                invalidNoteNames.append(note)
            } else if note.isIdentical(to: .C_FLAT) || note.isIdentical(to: .E_SHARP) || note.isIdentical(to: .F_FLAT) || note.isIdentical(to: .B_SHARP) {
                invalidNoteNames.append(note)
            } else {
                validNoteNames.append(note)
            }
        }
        
        return (validNoteNames: validNoteNames, invalidNoteNames: invalidNoteNames)
    }
}
