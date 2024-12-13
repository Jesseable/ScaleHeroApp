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
        scaleArray1 = writeScale.returnScaleNotesArray(for: Case.scale(tonality: .major(mode: .ionian)), startingAt: "C")
        scaleArray2 = writeScale.returnScaleNotesArray(for: Case.scale(tonality: .major(mode: .ionian)), startingAt: "A")
        
        let expectedScaleArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let expectedScaleArray2 = ["A", "B", "C-sharp", "D", "E", "F-sharp", "G-sharp", "A", "G-sharp", "F-sharp", "E", "D", "C-sharp", "B", "A"]
        
        XCTAssertEqual(scaleArray1, expectedScaleArray1, "jsonFile reading for C major scale failed")
        XCTAssertEqual(scaleArray2, expectedScaleArray2, "jsonFile reading for A major scale failed")
    }
    
    func testJsonFileReturnsArpeggio() {
        let arpeggioArray1 : [String]
        let arpeggioArray2 : [String]
        arpeggioArray1 = writeScale.returnScaleNotesArray(for: Case.arpeggio(tonality: .major), startingAt: "C")
        arpeggioArray2 = writeScale.returnScaleNotesArray(for: Case.arpeggio(tonality: .diminished7th), startingAt: "A")
        
        let expectedArpeggioArray1 = ["C", "E", "G", "C", "G", "E", "C"]
        let expectedArpeggioArray2 = ["A", "C", "E-flat", "G-flat", "A", "G-flat", "E-flat", "C", "A"]
        
        XCTAssertEqual(arpeggioArray1, expectedArpeggioArray1, "jsonFile reading for C major arpeggio failed")
        XCTAssertEqual(arpeggioArray2, expectedArpeggioArray2, "jsonFile reading for A diminished7th arpeggio failed")
    }
    
    /*
     Tests the basic case when the scale is not altered in any way
     */
    func testConvertToScaleArrayBasic() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let octavesToPlay = 1
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: octavesToPlay, tonicOption: TonicOption.noRepeatedTonic)
        
        let expectedNotesArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect")
    }
    
    /*
     Tests the returned array when octaves are different
     */
    func testConvertToScaleArrayOctaves() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let baseScale2 = ["D", "E", "F-sharp", "A", "B", "D", "B", "A", "F-sharp", "E", "D"]
        let baseScale3 = ["A", "C-sharp", "E", "A", "E", "C-sharp", "A"]
        var octavesToPlay = 2
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale,
                                                         octavesToPlay: octavesToPlay, tonicOption: TonicOption.noRepeatedTonic)
        octavesToPlay = 3
        let notesArray2 = writeScale.convertToScaleArray(baseScale: baseScale2,
                                                         octavesToPlay: octavesToPlay, tonicOption: TonicOption.noRepeatedTonic)
        let notesArray3 = writeScale.convertToScaleArray(baseScale: baseScale3,
                                                         octavesToPlay: octavesToPlay, tonicOption: TonicOption.noRepeatedTonic)
        
        let expectedNotesArray1 = ["C", "D", "E", "F", "G", "A", "B", "C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C", "B", "A", "G", "F", "E", "D", "C"]
        let expectedNotesArray2 = ["D", "E", "F-sharp", "A", "B", "D", "E", "F-sharp", "A", "B", "D", "E", "F-sharp", "A", "B", "D", "B", "A", "F-sharp", "E", "D", "B", "A", "F-sharp", "E", "D", "B", "A", "F-sharp", "E", "D"]
        let expectedNotesArray3 = ["A", "C-sharp", "E", "A", "C-sharp", "E", "A", "C-sharp", "E", "A", "E", "C-sharp", "A", "E", "C-sharp", "A", "E", "C-sharp", "A"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect with octave 2")
        XCTAssertEqual(notesArray2, expectedNotesArray2, "expected array2 is incorrect with ocatve 3")
        XCTAssertEqual(notesArray3, expectedNotesArray3, "expected array3 is incorrect with ocatve 3")
    }
    
    /*
     Tests the returned array when tonic options are different
     */
    func testConvertToScaleArrayTonics() {
        let baseScale = ["C", "D", "E", "F", "G", "A", "B", "C", "B", "A", "G", "F", "E", "D", "C"]
        let baseScale2 = ["D", "E", "F-sharp", "A", "B", "D", "B", "A", "F-sharp", "E", "D"]
        var octavesToPlay = 2
        
        let notesArray1 = writeScale.convertToScaleArray(baseScale: baseScale,
                                                         octavesToPlay: octavesToPlay, tonicOption: TonicOption.repeatedTonicAll)
        octavesToPlay = 3
        let notesArray2 = writeScale.convertToScaleArray(baseScale: baseScale2,
                                                         octavesToPlay: octavesToPlay, tonicOption: TonicOption.repeatedTonic)
        
        let expectedNotesArray1 = ["C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "D", "E", "F", "G", "A", "B", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C", "B", "A", "G", "F", "E", "D", "C", "C"]
        let expectedNotesArray2 = ["D", "E", "F-sharp", "A", "B", "D", "D", "E", "F-sharp", "A", "B", "D", "D", "E", "F-sharp", "A", "B", "D", "D", "B", "A", "F-sharp", "E", "D", "D", "B", "A", "F-sharp", "E", "D", "D", "B", "A", "F-sharp", "E", "D"]
        
        XCTAssertEqual(notesArray1, expectedNotesArray1, "expected array1 is incorrect with tonicOption 2")
        XCTAssertEqual(notesArray2, expectedNotesArray2, "expected array2 is incorrect with tonicOption 3")
    }
    
    /*
     Tests theInfoScales method
     */
    func testCreateScaleInfoArrayBasic() {
        let basicScale1 = ["D", "E", "F-sharp", "A", "B", "D", "B", "A", "F-sharp", "E", "D"]
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
        let chromaticC = ["C", "C-sharp", "D", "D-sharp", "E", "F", "F-sharp", "G", "G-sharp", "A", "A-sharp", "B", "C", "B", "B-flat", "A", "A-flat", "G", "G-flat", "F", "E", "E-flat", "D", "D-flat", "C"]
        let chromaticD = ["D", "D-sharp", "E", "F", "F-sharp", "G", "G-sharp", "A", "A-sharp", "B", "C", "C-sharp", "D", "D-flat", "C", "B", "B-flat", "A", "A-flat", "G", "G-flat", "F", "E", "E-flat", "D"]
        
        let wholeToneCScale = writeScale.convertToWholeToneScale(scaleArray: chromaticC)
        let wholeToneDScale = writeScale.convertToWholeToneScale(scaleArray: chromaticD)
        
        let expectedChromaticC = ["C", "D", "E", "F-sharp", "G-sharp", "A-sharp", "C", "B-flat", "A-flat","G-flat", "E", "D", "C"]
        let expectedChromaticD = ["D", "E", "F-sharp","G-sharp", "A-sharp", "C", "D", "C", "B-flat", "A-flat", "G-flat", "E", "D"]
        
        XCTAssertEqual(wholeToneCScale, expectedChromaticC, "expected chromaticC is incorrect")
        XCTAssertEqual(wholeToneDScale, expectedChromaticD, "expected chromaticD is incorrect")
    }
    
    /*
     Tests the whole tone scale adequetly exits when not given a chromatic array
     */
    func testWholeToneScaleError() {
        let chromaticC = ["C", "D", "D-sharp", "E", "F", "F-sharp", "G", "G-sharp", "A", "A-sharp", "B", "C", "B", "B-flat", "A", "A-flat", "G", "G-flat", "F", "E", "E-flat", "D", "D-flat", "C"]
        let chromaticD = ["D", "F-sharp", "G", "G-sharp", "A", "A-sharp", "B", "C", "C-sharp", "D", "D-flat", "C", "B", "B-flat", "A", "A-flat", "G", "G-flat", "D"]
        
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
        let dorianExpected = ["C", "D", "E-flat", "F", "G", "A", "B-flat", "C", "B-flat", "A", "G", "F", "E-flat", "D", "C"]
        let phrygianExpected = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]
        let lydianExpected = ["C", "D", "E", "F-sharp", "G", "A", "B", "C", "B", "A", "G", "F-sharp", "E", "D", "C"]
        let mixolydianExpected = ["C", "D", "E", "F", "G", "A", "B-flat", "C", "B-flat", "A", "G", "F", "E", "D", "C"]
        let aeolianExpected = ["C", "D", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D", "C"]
        let locrianExpected = ["C", "D-flat", "E-flat", "F", "G-flat", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G-flat", "F", "E-flat", "D-flat", "C"]
        
        XCTAssertEqual(ionian, ionianExpected, "ionian is incorrect")
        XCTAssertEqual(dorian, dorianExpected, "dorian is incorrect")
        XCTAssertEqual(phrygian, phrygianExpected, "phrygian is incorrect")
        XCTAssertEqual(lydian, lydianExpected, "lydian is incorrect")
        XCTAssertEqual(mixolydian, mixolydianExpected, "mixolydian is incorrect")
        XCTAssertEqual(aeolian, aeolianExpected, "aeolian is incorrect")
        XCTAssertEqual(locrian, locrianExpected, "locrian is incorrect")
    }
    
    // test one with doubel flats incldued
    
    func testModePentatonic() {
        let baseScale = ["C", "D", "E", "G", "A", "C", "A", "G", "E", "D", "C"]
        
        let mode1 = writeScale.convertToPentatonicMode(scaleArray: baseScale, mode: PentatonicScaleMode.mode1_major)
        let mode2 = writeScale.convertToPentatonicMode(scaleArray: baseScale, mode: PentatonicScaleMode.mode2_egyptian)
        let mode3 = writeScale.convertToPentatonicMode(scaleArray: baseScale, mode: PentatonicScaleMode.mode3_manGong)
        let mode4 = writeScale.convertToPentatonicMode(scaleArray: baseScale, mode: PentatonicScaleMode.mode4_ritusen)
        let mode5 = writeScale.convertToPentatonicMode(scaleArray: baseScale, mode: PentatonicScaleMode.mode5_minor)
        
        let mode1Expected = ["C", "D", "E", "G", "A", "C", "A", "G", "E", "D", "C"]
        let mode2Expected = ["C", "D", "F", "G", "B-flat", "C", "B-flat", "G", "F", "D", "C"]
        let mode3Expected = ["C", "E-flat", "F", "A-flat", "B-flat", "C", "B-flat", "A-flat", "F", "E-flat", "C"]
        let mode4Expected = ["C", "D", "F", "G", "A", "C", "A", "G", "F", "D", "C"]
        let mode5Expected = ["C", "E-flat", "F", "G", "B-flat", "C", "B-flat", "G", "F", "E-flat", "C"]
        
        XCTAssertEqual(mode1, mode1Expected, "ionian is incorrect")
        XCTAssertEqual(mode2, mode2Expected, "dorian is incorrect")
        XCTAssertEqual(mode3, mode3Expected, "phrygian is incorrect")
        XCTAssertEqual(mode4, mode4Expected, "lydian is incorrect")
        XCTAssertEqual(mode5, mode5Expected, "mixolydian is incorrect")
    }
    
    func testConvertToIntervalsAllUp() {
        let baseScale = ["2:C", "2:D", "2:E", "3:F", "2:G", "3:A", "3:B", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D", "2:C"]
        let baseScale2 = ["2:C", "2:D", "2:E", "2:G", "3:A", "3:C", "3:A", "2:G", "2:E", "2:D", "2:C"]
        let phrygian = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]

        let allUpThirds = writeScale.convertToIntervals(of: Interval.thirds, with: IntervalOption.allUp, for: baseScale)
        let allUpFourths = writeScale.convertToIntervals(of: Interval.fourths, with: IntervalOption.allUp, for: baseScale2)
        let allUpFifths = writeScale.convertToIntervals(of: Interval.fifths, with: IntervalOption.allUp, for: baseScale)
        let allUpThirdsWithoutOctave = writeScale.convertToIntervals(of: Interval.thirds,
                                                                     with: IntervalOption.allUp, for: phrygian, withoutOctave: true)
        
        let allUpThirdsExpected = ["2:C", "2:E", "2:D", "3:F", "2:E", "2:G", "3:F", "3:A", "2:G", "3:B", "3:A", "3:C", "3:B", "3:D", "3:C", "3:A", "3:B", "2:G", "3:A", "3:F", "2:G", "2:E", "3:F", "2:D", "2:E", "2:C", "2:D", "2:B", "2:C"]
        let allUpFourthsExpected = ["2:C", "2:G", "2:D", "3:A", "2:E", "3:C", "2:G", "3:D", "3:A", "3:E", "3:C", "2:E", "3:A", "2:D", "2:G", "2:C", "2:E", "2:A", "2:D", "1:G", "2:C"]
        let allUpFifthsExpected = ["2:C", "2:G", "2:D", "3:A", "2:E", "3:B", "3:F", "3:C", "2:G", "3:D", "3:A", "3:E", "3:B", "4:F", "3:C", "3:F", "3:B", "2:E", "3:A", "2:D", "2:G", "2:C", "3:F", "2:B", "2:E", "2:A", "2:D", "1:G", "2:C"]
        let allUpThirdsWithoutOctaveExpected = ["C", "E-flat", "D-flat", "F", "E-flat", "G", "F", "A-flat", "G", "B-flat", "A-flat", "C", "B-flat", "D-flat", "C", "A-flat", "B-flat", "G", "A-flat", "F", "G", "E-flat", "F", "D-flat", "E-flat", "C", "D-flat", "B-flat", "C"]
        
        XCTAssertEqual(allUpThirds, allUpThirdsExpected, "allupthirds is incorrect")
        XCTAssertEqual(allUpFourths, allUpFourthsExpected, "allupthirdsPentatonic is incorrect")
        XCTAssertEqual(allUpFifths, allUpFifthsExpected, "allupfifths is incorrect")
        XCTAssertEqual(allUpThirdsWithoutOctave, allUpThirdsWithoutOctaveExpected, "allupthirdswithoutoctave is incorrect")
    }
    
    func testConvertToIntervalsAllDowm() {
        let baseScale = ["2:C", "2:D", "2:E", "3:F", "2:G", "3:A", "3:B", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D", "2:C"]
        let baseScale2 = ["2:C", "2:D", "2:E", "2:G", "3:A", "3:C", "3:A", "2:G", "2:E", "2:D", "2:C"]
        let phrygian = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]

        let allDownThirds = writeScale.convertToIntervals(of: Interval.thirds, with: IntervalOption.allDown, for: baseScale)
        let allDownFourths = writeScale.convertToIntervals(of: Interval.fourths, with: IntervalOption.allDown, for: baseScale2)
        let allDownFifths = writeScale.convertToIntervals(of: Interval.fifths, with: IntervalOption.allDown, for: baseScale)
        let alldownThirdsWithoutOctave = writeScale.convertToIntervals(of: Interval.thirds,
                                                                     with: IntervalOption.allDown, for: phrygian, withoutOctave: true)
        
        let allDownThirdsExpected = ["2:E", "2:C", "3:F", "2:D", "2:G", "2:E", "3:A", "3:F", "3:B", "2:G", "3:C", "3:A", "3:D", "3:B", "3:C", "3:E", "3:B", "3:D", "3:A", "3:C", "2:G", "3:B", "3:F", "3:A", "2:E", "2:G", "2:D", "3:F", "2:C"]
        let allDownFourthsExpected = ["2:G", "2:C", "3:A", "2:D", "3:C", "2:E", "3:D", "2:G", "3:E", "3:A", "3:C", "3:G", "3:A", "3:E", "2:G", "3:D", "2:E", "3:C", "2:D", "3:A", "2:C"]
        let allDownFifthsExpected = ["2:G", "2:C", "3:A", "2:D", "3:B", "2:E", "3:C", "3:F", "3:D", "2:G", "3:E", "3:A", "4:F", "3:B", "3:C", "3:G", "3:B", "4:F", "3:A", "3:E", "2:G", "3:D", "3:F", "3:C", "2:E", "3:B", "2:D", "3:A", "2:C"]
        let alldownThirdsWithoutOctaveExpected = ["E-flat", "C", "F", "D-flat", "G", "E-flat", "A-flat", "F", "B-flat", "G", "C", "A-flat", "D-flat", "B-flat", "C", "E-flat", "B-flat", "D-flat", "A-flat", "C", "G", "B-flat", "F", "A-flat", "E-flat", "G", "D-flat", "F", "C"]
        
        XCTAssertEqual(allDownThirds, allDownThirdsExpected, "alldownthirds is incorrect")
        XCTAssertEqual(allDownFourths, allDownFourthsExpected, "alldownthirdsPentatonic is incorrect")
        XCTAssertEqual(allDownFifths, allDownFifthsExpected, "alldownfifths is incorrect")
        XCTAssertEqual(alldownThirdsWithoutOctave, alldownThirdsWithoutOctaveExpected, "alldownthirdswithoutoctave is incorrect")
    }
    
    func testConvertToIntervalsOneUpOneDowm() {
        let baseScale = ["2:D", "2:E", "2:F", "2:G", "3:A", "3:B", "3:C", "3:D", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D"]
        let baseScale2 = ["2:C", "2:D", "2:E", "2:G", "3:A", "3:C", "3:A", "2:G", "2:E", "2:D", "2:C"]
        let phrygian = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]

        let oneUpOneDownThirds = writeScale.convertToIntervals(of: Interval.thirds, with: IntervalOption.oneUpOneDown, for: baseScale)
        let oneUpOneDownFourths = writeScale.convertToIntervals(of: Interval.fourths, with: IntervalOption.oneUpOneDown, for: baseScale2)
        let oneUpOneDownFifths = writeScale.convertToIntervals(of: Interval.fifths, with: IntervalOption.oneUpOneDown, for: baseScale)
        let oneUpOneDownThirdsWithoutOctave = writeScale.convertToIntervals(of: Interval.thirds,
                                                                     with: IntervalOption.oneUpOneDown, for: phrygian, withoutOctave: true)
        
        let oneUpOneDownThirdsExpected = ["2:D", "2:F", "2:G", "2:E", "2:F", "3:A", "3:B", "2:G", "3:A", "3:C", "3:D", "3:B", "3:C", "3:E", "3:D", "3:F", "3:E", "3:C", "3:B", "3:D", "3:C", "3:A", "2:G", "3:B", "3:A", "2:F", "2:E", "2:G", "2:F", "2:D"]
        let oneUpOneDownFourthsExpected = ["2:C", "2:G", "3:A", "2:D", "2:E", "3:C", "3:D", "2:G", "3:A", "3:E", "3:C", "3:G", "3:E", "3:A", "2:G", "3:D", "3:C", "2:E", "2:D", "3:A", "2:G", "2:C"]
        let oneUpOneDownFifthsExpected = ["2:D", "3:A", "3:B", "2:E", "2:F", "3:C", "3:D", "2:G", "3:A", "3:E", "3:F", "3:B", "3:C", "3:G", "3:D", "4:A", "3:G", "3:C", "3:B", "3:F", "3:E", "3:A", "2:G", "3:D", "3:C", "2:F", "2:E", "3:B", "3:A", "2:D"]
        let oneUpOneDownThirdsWithoutOctaveExpected = ["C", "E-flat", "F", "D-flat", "E-flat", "G", "A-flat", "F", "G", "B-flat", "C", "A-flat", "B-flat", "D-flat", "C", "E-flat", "D-flat", "B-flat", "A-flat", "C", "B-flat", "G", "F", "A-flat", "G", "E-flat", "D-flat", "F", "E-flat", "C"]
        
        XCTAssertEqual(oneUpOneDownThirds, oneUpOneDownThirdsExpected, "oneUpOneDownthirds is incorrect")
        XCTAssertEqual(oneUpOneDownFourths, oneUpOneDownFourthsExpected, "oneUpOneDownthirdsPentatonic is incorrect")
        XCTAssertEqual(oneUpOneDownFifths, oneUpOneDownFifthsExpected, "oneUpOneDownfifths is incorrect")
        XCTAssertEqual(oneUpOneDownThirdsWithoutOctave, oneUpOneDownThirdsWithoutOctaveExpected, "oneUpOneDownthirdswithoutoctave is incorrect")
    }
    
    func testConvertToIntervalsOneDownOneUp() {
        let baseScale = ["2:D", "2:E", "2:F", "2:G", "3:A", "3:B", "3:C", "3:D", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D"]
        let baseScale2 = ["2:C", "2:D", "2:E", "2:G", "3:A", "3:C", "3:A", "2:G", "2:E", "2:D", "2:C"]
        let phrygian = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]

        let oneDownOneUpThirds = writeScale.convertToIntervals(of: Interval.thirds, with: IntervalOption.oneDownOneUp, for: baseScale)
        let oneDownOneUpFourths = writeScale.convertToIntervals(of: Interval.fourths, with: IntervalOption.oneDownOneUp, for: baseScale2)
        let oneDownOneUpFifths = writeScale.convertToIntervals(of: Interval.fifths, with: IntervalOption.oneDownOneUp, for: baseScale)
        let oneDownOneUpThirdsWithoutOctave = writeScale.convertToIntervals(of: Interval.thirds,
                                                                     with: IntervalOption.oneDownOneUp, for: phrygian, withoutOctave: true)
        
        let oneDownOneUpThirdsExpected = ["2:F", "2:D", "2:E", "2:G", "3:A", "2:F", "2:G", "3:B", "3:C", "3:A", "3:B", "3:D", "3:E", "3:C", "3:D", "3:F", "3:G", "3:E", "3:D", "3:B", "3:A", "3:C", "3:B", "2:G", "2:F", "3:A", "2:G", "2:E", "2:D"]
        let oneDownOneUpFourthsExpected = ["2:G", "2:C", "2:D", "3:A", "3:C", "2:E", "2:G", "3:D", "3:E", "3:A", "3:C", "3:G", "4:A", "3:D", "3:C", "2:E", "2:D", "3:A", "2:G", "2:C"]
        let oneDownOneUpFifthsExpected = ["3:A", "2:D", "2:E", "3:B", "3:C", "2:F", "2:G", "3:D", "3:E", "3:A", "3:B", "3:F", "3:G", "3:C", "3:D", "4:A", "4:B", "3:E", "3:D", "2:G", "2:F", "3:C", "3:B", "2:E", "2:D", "3:A", "2:G", "2:C", "2:B", "2:F", "2:E", "2:A", "1:G", "2:D"]
        let oneDownOneUpThirdsWithoutOctaveExpected = ["E-flat", "C", "D-flat", "F", "G", "E-flat", "F", "A-flat", "B-flat", "G", "A-flat", "C", "D-flat", "B-flat", "C", "E-flat", "F", "D-flat", "C", "A-flat", "G", "B-flat", "A-flat", "F", "E-flat", "G", "F", "D-flat", "C"]
        
        XCTAssertEqual(oneDownOneUpThirds, oneDownOneUpThirdsExpected, "oneDownOneUpthirds is incorrect")
        XCTAssertEqual(oneDownOneUpFourths, oneDownOneUpFourthsExpected, "oneDownOneUpthirdsPentatonic is incorrect")
        XCTAssertEqual(oneDownOneUpFifths, oneDownOneUpFifthsExpected, "oneDownOneUpfifths is incorrect")
        XCTAssertEqual(oneDownOneUpThirdsWithoutOctave, oneDownOneUpThirdsWithoutOctaveExpected, "oneDownOneUpthirdswithoutoctave is incorrect")
    }
    
    func testRepeatEveryNote() {
        let baseScale = ["2:D", "2:E", "2:F", "2:G", "3:A", "3:B", "3:C", "3:D", "3:C", "3:B", "3:A", "2:G", "2:F", "2:E", "2:D"]
        let baseScale2 = ["C", "D-flat", "E-flat", "F", "G", "A-flat", "B-flat", "C", "B-flat", "A-flat", "G", "F", "E-flat", "D-flat", "C"]

        let baseScaleDoubled = writeScale.repeatAllNotes(in: baseScale)
        let baseScale2Doubled = writeScale.repeatAllNotes(in: baseScale2)
        
        let baseScaleDoubledExpected = ["2:D", "2:D", "2:E", "2:E", "2:F", "2:F", "2:G", "2:G", "3:A", "3:A", "3:B", "3:B", "3:C", "3:C", "3:D", "3:D", "3:C", "3:C", "3:B", "3:B", "3:A", "3:A", "2:G", "2:G", "2:F", "2:F", "2:E", "2:E", "2:D", "2:D"]
        let baseScale2DoubledExpected = ["C", "C", "D-flat", "D-flat", "E-flat", "E-flat", "F", "F", "G", "G", "A-flat", "A-flat", "B-flat", "B-flat", "C", "C", "B-flat", "B-flat", "A-flat", "A-flat", "G", "G", "F", "F", "E-flat", "E-flat", "D-flat", "D-flat", "C", "C"]

        
        XCTAssertEqual(baseScaleDoubled, baseScaleDoubledExpected, "base scale doubled is incorrect")
        XCTAssertEqual(baseScale2Doubled, baseScale2DoubledExpected, "base scale 2 doubled is incorrect")
    }
}
