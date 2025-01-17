//
//  AlterNotesTests.swift
//  ScaleHeroTests
//
//  Created by Jesse Graf on 25/6/2022.
//
//
//import XCTest
//@testable import ScaleHero
//
//
//class AlterNotesTests: XCTestCase {
//    
//    let alterNotes = AlterNotes()
//    
//    /*
//     Tests the modes of a Major scale wors correctly
//     */
//    func testGetIonianTonicMajorScaleModes() {
//        
//        let cIonian = alterNotes.getMajorIonianStartingNote(from: "C", in: .ionian)
//        let cMixolydian = alterNotes.getMajorIonianStartingNote(from: "C", in: .mixolydian)
//        let dLocrian = alterNotes.getMajorIonianStartingNote(from: "D", in: .locrian)
//        let bbphrygian = alterNotes.getMajorIonianStartingNote(from: "B-flat", in: .phrygian)
//        let aSharpAeolian = alterNotes.getMajorIonianStartingNote(from: "A-sharp", in: .aeolian)
//        let fSharpLydian = alterNotes.getMajorIonianStartingNote(from: "F-sharp", in: .lydian)
//        let gFlatDorian = alterNotes.getMajorIonianStartingNote(from: "G-flat", in: .dorian)
//        
//        let expected_cIonian = "C"
//        let expected_cMixolydian = "F"
//        let expected_dLocrian = "E-flat"
//        let expected_bbphrygian = "G-flat"
//        let expected_aSharpAeolian = "C-sharp"
//        let expected_fSharpLydian = "C-sharp"
//        let expected_gFlatDorian = "E" // NOT Fb THINK ABOUT THIS LATER
//        
//        XCTAssertEqual(cIonian, expected_cIonian, "expected cIonian is incorrect")
//        XCTAssertEqual(cMixolydian, expected_cMixolydian, "expected cMixolydian is incorrect")
//        XCTAssertEqual(dLocrian, expected_dLocrian, "expected dLocrian is incorrect")
//        XCTAssertEqual(bbphrygian, expected_bbphrygian, "expected bbPhrygian is incorrect")
//        XCTAssertEqual(aSharpAeolian, expected_aSharpAeolian, "expected aSharpAeolian is incorrect")
//        XCTAssertEqual(fSharpLydian, expected_fSharpLydian, "expected fSharpLydian is incorrect")
//        XCTAssertEqual(gFlatDorian, expected_gFlatDorian, "expected gFlatDorian is incorrect")
//    }
//
//    /*
//     Tests the modes of a pentatonic scale works correctly
//     */
//    func testGetMajorTonicPentatonicScaleModes() {
//        
//        let cMode1 = alterNotes.getMajorPentatonicStartingNote(from: "C", in: .mode1_major)
//        let bbMode2 = alterNotes.getMajorPentatonicStartingNote(from: "B-flat", in: .mode2_egyptian)
//        let aSharpMode3 = alterNotes.getMajorPentatonicStartingNote(from: "A-sharp", in: .mode3_manGong)
//        let gbMode4 = alterNotes.getMajorPentatonicStartingNote(from: "G-flat", in: .mode4_ritusen)
//        let fSharpMode5 = alterNotes.getMajorPentatonicStartingNote(from: "F-sharp", in: .mode5_minor)
//        
//        let expected_cMode1 = "C"
//        let expected_bbMode2 = "A-flat"
//        let expected_aSharpMode3 = "F-sharp"
//        let expected_gbMode4 = "B"
//        let expected_SharpMode5 = "A"
//        
//        XCTAssertEqual(cMode1, expected_cMode1, "expected cIonian is incorrect")
//        XCTAssertEqual(bbMode2, expected_bbMode2, "expected cMixolydian is incorrect")
//        XCTAssertEqual(aSharpMode3, expected_aSharpMode3, "expected dLocrian is incorrect")
//        XCTAssertEqual(gbMode4, expected_gbMode4, "expected bbPhrygian is incorrect")
//        XCTAssertEqual(fSharpMode5, expected_SharpMode5, "expected aSharpAeolian is incorrect")
//    }
//    
//    func testChangedOctaveNumber() {
//        var note1 = "1:C#|Db"
//        var note2 = "2:D#|Eb"
//        var note3 = "3:D"
//        
//        note1 = alterNotes.changeOctaveNumber(AlterAmount.increase, for: note1)
//        note2 = alterNotes.changeOctaveNumber(AlterAmount.increase, for: note2)
//        note3 = alterNotes.changeOctaveNumber(AlterAmount.decrease, for: note3)
//        
//        let expectedNote1 = "2:C#|Db"
//        let expectedNote2 = "3:D#|Eb"
//        let expectedNote3 = "2:D"
//        
//        XCTAssertEqual(note1, expectedNote1, "expected note1 is incorrect")
//        XCTAssertEqual(note2, expectedNote2, "expected note2 is incorrect")
//        XCTAssertEqual(note3, expectedNote3, "expected note3 is incorrect")
//    }
//    
//    // Test also for the edge cases of changed octave numbers
//}
