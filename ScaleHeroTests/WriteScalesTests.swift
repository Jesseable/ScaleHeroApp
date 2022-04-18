//
//  WriteScalesTests.swift
//  ScaleHeroTests
//
//  Created by Jesse Graf on 18/4/2022.
//

import XCTest
@testable import ScaleHero

class WriteScalesTests: XCTestCase {
    
    var writeScale = WriteScales(type: "doesn't matter")
    
    /*
     Tests the basic case when the scale is not altered in any way
     */
    func testconvertToScaleArray() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let octavesToPlay = 1
        let tonicOption = 1
        let startingOctave = 1
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: octavesToPlay, tonicOption: tonicOption, startingOctave: startingOctave)
        
        let expectedNotesArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect")
    }
}
