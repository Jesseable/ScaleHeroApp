//
//  ScaleConstructorTests.swift
//  ScaleHero
//
//  Created by Jesse Graf on 20/12/2024.
//

import XCTest
@testable import ScaleHero

class ScaleConstructorTests: XCTestCase {
    
    let scaleOptions = NoteOptions()

    /*
     Initialise the fileReaderAndWriter
     */
    override class func setUp() {
        let fileReaderAndWriter = FileReaderAndWriter()
        fileReaderAndWriter.writeNewTransposition(newTransposition: Notes.C.name)
    }
    
    func testJsonFileReturnsScale_basic() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.major(mode: .ionian))
            
            let expectedMajorScale: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
            
            XCTAssertEqual(expectedMajorScale, scaleConstructor.musicArray?.getNotes(), "jsonFile reading for C major scale failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testJsonFileReturnsScale_chromatic() throws {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.D_FLAT, tonality: ScaleTonality.chromatic(alteration: .unchanged))
            
            let expectedDbChromatic: [Notes] = [
                .D_FLAT, .D, .E_FLAT, .E, .F, .G_FLAT, .G, .A_FLAT, .A, .B_FLAT, .B, .C,
                .D_FLAT, .C, .B, .B_FLAT, .A, .A_FLAT, .G, .G_FLAT, .F, .E, .E_FLAT, .D, .D_FLAT
            ]
            
            XCTAssertEqual(expectedDbChromatic, scaleConstructor.musicArray?.getNotes(), "jsonFile reading for C major scale failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testJsonFileReturnsScale_allNotes() {
        let notes = setValidAndInvalidNoteNames()
        
        for note in notes.validNoteNames {
            do {
                let scaleConstructor = try ScaleConstructor(startingNote: note, tonality: ScaleTonality.major(mode: .ionian))
                if (scaleConstructor.musicArray?.getNotes() == nil) {
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
                let scaleConstructor = try ScaleConstructor(startingNote: note, tonality: ScaleTonality.major(mode: .ionian))
                // The note of the returned array should not match the actuall note name. But they will be identical file names
                if (scaleConstructor.musicArray?.getNotes() != nil && scaleConstructor.musicArray?.getNotes().first?.name == note.name) {
                    XCTFail("ScaleConstructor for '\(note)' was set. But this note should be illegal. \n"
                            + "The scale returned is: '\(String(describing: scaleConstructor.musicArray?.getNotes().first?.name))'")
                }
            } catch IllegalNoteError.invalidValue(let message) {
                XCTAssertEqual("Notes: '\(note.name)' not found in Ionian json options", message)
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
            } else {
                validNoteNames.append(note)
            }
        }
        
        return (validNoteNames: validNoteNames, invalidNoteNames: invalidNoteNames)
    }
    
    func testDorianModeScale() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.F_SHARP, tonality: ScaleTonality.major(mode: .dorian))
            
            let expectedMajorScale: [Notes] = [.F_SHARP, .G_SHARP, .A, .B, .C_SHARP, .D_SHARP, .E, .F_SHARP, .E, .D_SHARP, .C_SHARP, .B, .A, .G_SHARP, .F_SHARP]
            
            XCTAssertEqual(expectedMajorScale, scaleConstructor.musicArray?.getNotes(), "Converting F_Sharp to Dorian Mode Scale failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFsharpLocrianModeScale() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.F_SHARP, tonality: ScaleTonality.major(mode: .locrian))
            
            let expectedMajorScale: [Notes] = [.F_SHARP, .G, .A, .B, .C, .D, .E, .F_SHARP, .E, .D, .C, .B, .A, .G, .F_SHARP]
            
            XCTAssertEqual(expectedMajorScale, scaleConstructor.musicArray?.getNotes(), "Converting F_Sharp to Locrian Mode Scale failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testBLydianModeScale() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.B, tonality: ScaleTonality.major(mode: .lydian))
            
            let expectedMajorScale: [Notes] = [.B, .C_SHARP, .D_SHARP, .E_SHARP, .F_SHARP, .G_SHARP, .A_SHARP, .B, .A_SHARP, .G_SHARP, .F_SHARP, .E_SHARP, .D_SHARP, .C_SHARP, .B]
            
            XCTAssertEqual(expectedMajorScale, scaleConstructor.musicArray?.getNotes(), "Converting B to Lydian Mode Scale failed")
            
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testModePentatonic_major() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.pentatonic(mode: .mode1_major))
            
            let expectedMajorPentatonic: [Notes] = [.C, .D, .E, .G, .A, .C, .A, .G, .E, .D, .C]
            
            XCTAssertEqual(expectedMajorPentatonic, scaleConstructor.musicArray?.getNotes(), "Converting C pentatonic to major Mode failed")
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testModePentatonic_egyptian() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.pentatonic(mode: .mode2_egyptian))
            
            let expectedMajorPentatonic: [Notes] = [.C, .D, .F, .G, .B_FLAT, .C, .B_FLAT, .G, .F, .D, .C]
            
            XCTAssertEqual(expectedMajorPentatonic, scaleConstructor.musicArray?.getNotes(), "Converting C pentatonic to egyptian Mode failed")
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testModePentatonic_monGong() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.pentatonic(mode: .mode3_manGong))
            
            let expectedMajorPentatonic: [Notes] = [.C, .E_FLAT, .F, .A_FLAT, .B_FLAT, .C, .B_FLAT, .A_FLAT, .F, .E_FLAT, .C]
            
            XCTAssertEqual(expectedMajorPentatonic, scaleConstructor.musicArray?.getNotes(), "Converting C pentatonic to manGong Mode failed")
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testModePentatonic_ritusen() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.pentatonic(mode: .mode4_ritusen))
            
            let expectedMajorPentatonic: [Notes] = [.C, .D, .F, .G, .A, .C, .A, .G, .F, .D, .C]
            
            XCTAssertEqual(expectedMajorPentatonic, scaleConstructor.musicArray?.getNotes(), "Converting C pentatonic to ritusen Mode failed")
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testModePentatonic_minor() {
        let scaleConstructor: ScaleConstructor
        do {
            scaleConstructor = try ScaleConstructor(startingNote: Notes.C, tonality: ScaleTonality.pentatonic(mode: .mode5_minor))
            
            let expectedMajorPentatonic: [Notes] = [.C, .E_FLAT, .F, .G, .B_FLAT, .C, .B_FLAT, .G, .F, .E_FLAT, .C]
            
            XCTAssertEqual(expectedMajorPentatonic, scaleConstructor.musicArray?.getNotes(), "Converting C pentatonic to minor Mode failed")
        } catch IllegalNoteError.invalidValue(let message) {
            XCTFail(message)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
