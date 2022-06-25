//
//  WriteScalesTests.swift
//  ScaleHeroTests
//
//  Created by Jesse Graf on 18/4/2022.
//

import XCTest
@testable import ScaleHero

class WriteScalesTests: XCTestCase {
    
    var writeScale = WriteScales(scaleOptions: ScaleOptions())
    
    /*
     Initialise the fileReaderAndWriter
     */
    override class func setUp() {
        let fileReaderAndWriter = FileReaderAndWriter()
        fileReaderAndWriter.writeNewTransposition(newTransposition: "C")
    }
    
    func testJsonFileReturnsScale() {
        let scaleArray1 : [String]
        let scaleArray2 : [String]
        scaleArray1 = writeScale.returnScaleNotesArray(for: Case.scale, startingAt: "C")
        scaleArray2 = writeScale.returnScaleNotesArray(for: Case.scale, startingAt: "A")
        
        let expectedScaleArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let expectedScaleArray2 = ["A", "B", "C#", "D", "E", "F#", "G#", "A", "G#", "F#", "E", "D", "C#", "B", "A"]
        
        XCTAssertEqual(scaleArray1, expectedScaleArray1, "jsonFile reading for C major scale failed")
        XCTAssertEqual(scaleArray2, expectedScaleArray2, "jsonFile reading for A major scale failed")
    }
    
    func testJsonFileReturnsArpeggio() {
        let arpeggioArray1 : [String]
        let arpeggioArray2 : [String]
        arpeggioArray1 = writeScale.returnScaleNotesArray(for: Case.arpeggio, startingAt: "C")
        arpeggioArray2 = writeScale.returnScaleNotesArray(for: Case.arpeggio, startingAt: "A")
        
        let expectedArpeggioArray1 = ["C", "E", "G", "C", "G", "E", "C"]
        let expectedArpeggioArray2 = ["A", "C#", "E", "A", "E", "C#", "A"]
        
        XCTAssertEqual(arpeggioArray1, expectedArpeggioArray1, "jsonFile reading for C major arpeggio failed")
        XCTAssertEqual(arpeggioArray2, expectedArpeggioArray2, "jsonFile reading for A major arpeggio failed")
    }
    
    /*
     Tests the basic case when the scale is not altered in any way
     */
    func testConvertToScaleArrayBasic() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let octavesToPlay = 1
        let tonicOption = 1
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: octavesToPlay, tonicOption: tonicOption)
        
        let expectedNotesArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect")
    }
    
    /*
     Tests the returned array when octaves are different
     */
    func testConvertToScaleArrayOctaves() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let baseScale2 = ["D", "E", "F#", "A", "B", "D", "B", "A", "F#", "E", "D"]
        var octavesToPlay = 2
        let tonicOption = 1
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: octavesToPlay, tonicOption: tonicOption)
        octavesToPlay = 3
        let notesArray2 = writeScale.convertToScaleArray(baseScale: baseScale2, octavesToPlay: octavesToPlay, tonicOption: tonicOption)
        
        let expectedNotesArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C", "B", "A", "G", "F", "E", "D", "C"]
        let expectedNotesArray2 = ["D", "E", "F#", "A", "B", "D", "E", "F#", "A", "B", "D", "E", "F#", "A", "B", "D", "B", "A", "F#", "E", "D", "B", "A", "F#", "E", "D", "B", "A", "F#", "E", "D"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect with octave 2")
        XCTAssertEqual(notesArray2, expectedNotesArray2, "expected array2 is incorrect with ocatve 3")
    }
    
    /*
     Tests the returned array when tonic options are different
     */
    func testConvertToScaleArrayTonics() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let baseScale2 = ["D", "E", "F#", "A", "B", "D", "B", "A", "F#", "E", "D"]
        var octavesToPlay = 2
        var tonicOption = 2
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: octavesToPlay, tonicOption: tonicOption)
        octavesToPlay = 3
        tonicOption = 3
        let notesArray2 = writeScale.convertToScaleArray(baseScale: baseScale2, octavesToPlay: octavesToPlay, tonicOption: tonicOption)
        
        let expectedNotesArray1 = ["C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C"]
        let expectedNotesArray2 = ["D", "E", "F#", "A", "B", "D", "D", "E", "F#", "A", "B", "D", "D", "E", "F#", "A", "B", "D", "D", "B", "A", "F#", "E", "D", "D", "B", "A", "F#", "E", "D", "D", "B", "A", "F#", "E", "D"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect with tonicOption 2")
        XCTAssertEqual(notesArray2, expectedNotesArray2, "expected array2 is incorrect with tonicOption 3")
    }
    
    /*
     Tests theInfoScales method
     */
    func testCreateScaleInfoArrayBasic() {
        let basicScale1 = ["D", "E", "F#", "A", "B", "D", "B", "A", "F#", "E", "D"]
        let basicScale2 = ["C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C"]
        let initialOctave = 1
        
        let scaleInfoArray1 = writeScale.createScaleInfoArray(scaleArray: basicScale1, initialOctave: initialOctave)
        let scaleInfoArray2 = writeScale.createScaleInfoArray(scaleArray: basicScale2, initialOctave: initialOctave)
        
        let expectedNotesArray1 = ["1:D", "1:E", "1:F#|Gb", "2:A", "2:B", "2:D", "2:B", "2:A", "1:F#|Gb", "1:E", "1:D"]
        let expectedNotesArray2 = ["1:C", "1:C", "1:D", "1:E", "1:F", "1:G", "2:A", "2:B", "2:C", "2:C", "2:D", "2:E", "2:F", "2:G", "3:A", "3:B", "3:C", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D", "2:C", "2:C", "2:B", "2:A", "1:G", "1:F", "1:E", "1:D", "1:C", "1:C"]
        
        XCTAssertEqual(scaleInfoArray1, expectedNotesArray1, "expected array1 is incorrect with infoScale 1")
        XCTAssertEqual(scaleInfoArray2, expectedNotesArray2, "expected array2 is incorrect with InfoScale 2")
    }
    
    /*
     Tests the whole tone scale works
     */
    func testWholeToneScale() {
        let chromaticC = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "B", "Bb", "A", "Ab", "G", "Gb", "F", "E", "Eb", "D", "Db", "C"]
        let chromaticD = ["D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "Db", "C", "B", "Bb", "A", "Ab", "G", "Gb", "F", "E", "Eb", "D"]
        
        let wholeToneCScale = writeScale.convertToWholeToneScale(scaleArray: chromaticC)
        let wholeToneDScale = writeScale.convertToWholeToneScale(scaleArray: chromaticD)
        
        let expectedChromaticC = ["C", "D", "E", "F#", "G#", "A#", "C", "Bb", "Ab","Gb", "E", "D", "C"]
        let expectedChromaticD = ["D", "E", "F#","G#", "A#", "C", "D", "C", "Bb", "Ab", "Gb", "E", "D"]
        
        XCTAssertEqual(wholeToneCScale, expectedChromaticC, "expected chromaticC is incorrect")
        XCTAssertEqual(wholeToneDScale, expectedChromaticD, "expected chromaticD is incorrect")
    }
    
    /*
     Tests the whole tone scale adequetly exits when not given a chromatic array
     */
    func testWholeToneScaleError() {
        let chromaticC = ["C", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C", "B", "Bb", "A", "Ab", "G", "Gb", "F", "E", "Eb", "D", "Db", "C"]
        let chromaticD = ["D", "F#", "G", "G#", "A", "A#", "B", "C", "C#", "D", "Db", "C", "B", "Bb", "A", "Ab", "G", "Gb", "D"]
        
        let wholeToneCScale = writeScale.convertToWholeToneScale(scaleArray: chromaticC)
        let wholeToneDScale = writeScale.convertToWholeToneScale(scaleArray: chromaticD)
        
        let expectedChromaticC = ["Whole Tone Scale Failed, Invalid Input"]
        let expectedChromaticD = ["Whole Tone Scale Failed, Invalid Input"]
        
        XCTAssertEqual(wholeToneCScale, expectedChromaticC, "expected chromaticC error is incorrect")
        XCTAssertEqual(wholeToneDScale, expectedChromaticD, "expected chromaticD error is incorrect")
    }
    
    func testModeMajorScale() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        
        let ionian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.ionian)
        let dorian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.dorian)
        let phrygian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.phrygian)
        let lydian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.lydian)
        let mixolydian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.mixolydian)
        let aeolian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.aeolian)
        let locrian = writeScale.convertToScaleMode(scaleArray: baseScale, mode: MajorScaleMode.locrian)
        
        let ionianExpected = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let dorianExpected = ["C", "D", "Eb", "F", "G", "A", "Bb", "C", "Bb", "A", "G", "F", "Eb", "D", "C"]
        let phrygianExpected = ["C", "Db", "Eb", "F", "G", "Ab", "Bb", "C", "Bb", "Ab", "G", "F", "Eb", "Db", "C"]
        let lydianExpected = ["C", "D", "E", "F#", "G", "A", "B", "C", "B", "A", "G", "F#", "E", "D", "C"]
        let mixolydianExpected = ["C", "D", "E", "F", "D", "A", "Bb", "C", "Bb", "A", "D", "F", "E", "D", "C"]
        let aeolianExpected = ["C", "D", "Eb", "F", "G", "Ab", "Bb", "C", "Bb", "Ab", "G", "F", "Eb", "D", "C"]
        let locrianExpected = ["C", "Db", "Eb", "F", "Gb", "Ab", "Bb", "C", "Bb", "Ab", "Gb", "F", "Eb", "Db", "C"]
        
        XCTAssertEqual(ionian, ionianExpected, "ionian is incorrect")
        XCTAssertEqual(dorian, dorianExpected, "dorian is incorrect")
        XCTAssertEqual(phrygian, phrygianExpected, "phrygian is incorrect")
        XCTAssertEqual(lydian, lydianExpected, "lydian is incorrect")
        XCTAssertEqual(mixolydian, mixolydianExpected, "mixolydian is incorrect")
        XCTAssertEqual(aeolian, aeolianExpected, "aeolian is incorrect")
        XCTAssertEqual(locrian, locrianExpected, "locrian is incorrect")
    }
}
