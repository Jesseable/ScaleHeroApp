//
//  AlterNotesTests.swift
//  ScaleHeroTests
//
//  Created by Jesse Graf on 25/6/2022.
//

import XCTest
@testable import ScaleHero


class AlterNotesTests: XCTestCase {
    
    let alterNotes = AlterNotes()
    
    /*
     Tests the whole tone scale adequetly exits when not given a chromatic array
     */
    func testGetIonianTonicMajorScaleModes() {
        
        let cIonian = alterNotes.getMajorIonianStartingNote(from: "C", in: .ionian)
        let cMixolydian = alterNotes.getMajorIonianStartingNote(from: "C", in: .mixolydian)
        let dLocrian = alterNotes.getMajorIonianStartingNote(from: "D", in: .locrian)
        let bbphrygian = alterNotes.getMajorIonianStartingNote(from: "Bb", in: .phrygian)
        let aSharpAeolian = alterNotes.getMajorIonianStartingNote(from: "A#", in: .aeolian)
        let fSharpLydian = alterNotes.getMajorIonianStartingNote(from: "F#", in: .lydian)
        let gFlatDorian = alterNotes.getMajorIonianStartingNote(from: "Gb", in: .dorian)
        
        let expected_cIonian = "C"
        let expected_cMixolydian = "F"
        let expected_dLocrian = "Eb"
        let expected_bbphrygian = "Gb"
        let expected_aSharpAeolian = "C#"
        let expected_fSharpLydian = "C#"
        let expected_gFlatDorian = "E" // NOT Fb THINK ABOUT THIS LATER
        
        XCTAssertEqual(cIonian, expected_cIonian, "expected cIonian is incorrect")
        XCTAssertEqual(cMixolydian, expected_cMixolydian, "expected cMixolydian is incorrect")
        XCTAssertEqual(dLocrian, expected_dLocrian, "expected dLocrian is incorrect")
        XCTAssertEqual(bbphrygian, expected_bbphrygian, "expected bbPhrygian is incorrect")
        XCTAssertEqual(aSharpAeolian, expected_aSharpAeolian, "expected aSharpAeolian is incorrect")
        XCTAssertEqual(fSharpLydian, expected_fSharpLydian, "expected fSharpLydian is incorrect")
        XCTAssertEqual(gFlatDorian, expected_gFlatDorian, "expected gFlatDorian is incorrect")
    }

}
