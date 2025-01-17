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
        fileReaderAndWriter.writeNewTransposition(newTransposition: Notes.C.name)
    }
    
//    func testJsonFileReturnsScale_basic() {
//        let arpeggioConstructor = ArpeggioConstructor(startingNote: Notes.C, tonality: ArpeggioTonality.major)
//                
//        let expectedmajorArpeggioC: [Notes] = [.C, .E, .G, .C, .G, .E, .C]
//        
//        XCTAssertEqual(expectedmajorArpeggioC, arpeggioConstructor.noteNames?.getScale(), "jsonFile reading for C major scale failed")
//    }
//    
//    func testJsonFileReturnsScale_chromatic() {
//        let arpeggioConstructor = ArpeggioConstructor(startingNote: .D_FLAT, tonality: ArpeggioTonality.diminished7th)
//        let expectedDim7thArpeggioDb: [Notes] = [.D_FLAT, .F_FLAT, .A_DOUBLE_FLAT, .C_DOUBLE_FLAT, .D_FLAT, .C_DOUBLE_FLAT, .A_DOUBLE_FLAT, .F_FLAT, .D_FLAT]
//        
//        XCTAssertEqual(expectedDim7thArpeggioDb, arpeggioConstructor.noteNames?.getScale(), "jsonFile reading for C major scale failed")
//    }
}
