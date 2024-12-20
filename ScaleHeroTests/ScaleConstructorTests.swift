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
        fileReaderAndWriter.writeNewTransposition(newTransposition: "C")
    }
    
    func testJsonFileReturnsScale_basic() {
        let scaleOptions = NoteOptions()
        let scaleConstructor = ScaleConstructor(startingNote: "C", tonality: ScaleTonality.major(mode: .ionian))
                
        let expectedMajorScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        
        XCTAssertEqual(expectedMajorScale, scaleConstructor.noteNames, "jsonFile reading for C major scale failed")
    }
    
    func testJsonFileReturnsScale_chromatic() {
        let scaleOptions = NoteOptions()
        let scaleConstructor = ScaleConstructor(startingNote: "D-flat", tonality: ScaleTonality.chromatic(alteration: .unchanged))
                
        let expectedDbChromatic = ["D-flat", "D", "E-flat", "E", "F", "G-flat", "G", "A-flat", "A", "B-flat", "B", "C", "D-flat", "C", "B", "B-flat", "A","A-flat", "G", "G-flat", "F", "E", "E-flat", "D", "D-flat"]
        
        XCTAssertEqual(expectedDbChromatic, scaleConstructor.noteNames, "jsonFile reading for C major scale failed")
    }
}
