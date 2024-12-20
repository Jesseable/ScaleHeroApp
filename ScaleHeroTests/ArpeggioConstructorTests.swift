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

    /*
     Initialise the fileReaderAndWriter
     */
    override class func setUp() {
        let fileReaderAndWriter = FileReaderAndWriter()
        fileReaderAndWriter.writeNewTransposition(newTransposition: "C")
    }
    
    func testJsonFileReturnsScale_basic() {
        let arpeggioConstructor = ArpeggioConstructor(startingNote: "C", tonality: ArpeggioTonality.major)
                
        let expectedmajorArpeggioC = ["C", "E", "G", "C", "G", "E", "C"]
        
        XCTAssertEqual(expectedmajorArpeggioC, arpeggioConstructor.noteNames, "jsonFile reading for C major scale failed")
    }
    
    func testJsonFileReturnsScale_chromatic() {
        let arpeggioConstructor = ArpeggioConstructor(startingNote: "D-flat", tonality: ArpeggioTonality.diminished7th)
        let expectedDim7thArpeggioDb = ["D-flat", "F-flat", "A-double-flat", "C-double-flat", "D-flat", "C-double-flat", "A-double-flat", "F-flat", "D-flat"]
        
        XCTAssertEqual(expectedDim7thArpeggioDb, arpeggioConstructor.noteNames, "jsonFile reading for C major scale failed")
    }
}
