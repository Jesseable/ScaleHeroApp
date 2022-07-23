//
//  PlaySoundsTests.swift
//  ScaleHeroTests
//
//  Created by Jesse Graf on 17/4/2022.
//

import XCTest
@testable import ScaleHero

class PlaySoundsTests: XCTestCase {

    var playSounds = PlaySounds()
    
    override class func setUp() {
        let fileReaderAndWriter = FileReaderAndWriter()
        fileReaderAndWriter.writeScaleInstrument(newInstrument: "Strings")
        fileReaderAndWriter.writeNewTransposition(newTransposition: "D#/Eb")
    }

    /*
     Tests the toSoundFile method works
     */
    func testconvertToSoundFile() {
        let tempo = 60
        let scaleArrBluesG = ["1:G", "2:A#/Bb", "2:C", "2:C#/Db", "2:D", "2:F", "2:G", "2:F", "2:D", "2:C#/Db", "2:C", "2:A#/Bb", "1:G"]
        let melodicEb3actualTonic3 = ["1:D#/Eb", "1:F", "1:F#/Gb", "1:G#/Ab", "2:A#/Bb", "2:C", "2:D", "2:D#/Eb", "2:D#/Eb", "2:F", "2:F#/Gb", "2:G#/Ab", "3:A#/Bb", "3:C", "3:D", "3:D#/Eb", "3:D#/Eb", "3:F", "3:F#/Gb", "3:G#/Ab", "4:A#/Bb", "4:C", "4:D", "4:D#/Eb", "4:D#/Eb", "4:C#/Db", "4:B", "4:A#/Bb", "3:G#/Ab", "3:F#/Gb", "3:F", "3:D#/Eb", "3:D#/Eb", "3:C#/Db", "3:B", "3:A#/Bb", "2:G#/Ab", "2:F#/Gb", "2:F", "2:D#/Eb", "2:D#/Eb", "2:C#/Db", "2:B", "2:A#/Bb", "1:G#/Ab", "1:F#/Gb", "1:F", "1:D#/Eb"]
        
        let soundFileArrayBluesG = playSounds.convertToSoundFile(scaleInfoArray: scaleArrBluesG, tempo: tempo)
        let soundFileArrayMelodicEb3actualTonic3 = playSounds.convertToSoundFile(scaleInfoArray: melodicEb3actualTonic3, tempo: tempo)
        
        XCTAssertEqual(playSounds.instrument, "Strings", "instrument is incorrect")
        
        let expectedBluesGArr = ["Metronome", "Metronome", "Strings-1-G", "Strings-2-A#|Bb", "Strings-2-C", "Strings-2-C#|Db", "Strings-2-D", "Strings-2-F", "Strings-2-G", "Strings-2-F", "Strings-2-D", "Strings-2-C#|Db", "Strings-2-C", "Strings-2-A#|Bb", "Strings-1-G"]
        let expectedMelodicEb3actualTonic3 = ["Metronome", "Metronome", "Strings-1-D#|Eb", "Strings-1-F", "Strings-1-F#|Gb", "Strings-1-G#|Ab", "Strings-2-A#|Bb", "Strings-2-C", "Strings-2-D", "Strings-2-D#|Eb", "Strings-2-D#|Eb", "Strings-2-F", "Strings-2-F#|Gb", "Strings-2-G#|Ab", "Strings-3-A#|Bb", "Strings-3-C", "Strings-3-D", "Strings-3-D#|Eb", "Strings-3-D#|Eb", "Strings-3-F", "Strings-3-F#|Gb", "Strings-3-G#|Ab", "Strings-4-A#|Bb", "Strings-4-C", "Strings-4-D", "Strings-4-D#|Eb", "Strings-4-D#|Eb", "Strings-4-C#|Db", "Strings-4-B", "Strings-4-A#|Bb", "Strings-3-G#|Ab", "Strings-3-F#|Gb", "Strings-3-F", "Strings-3-D#|Eb", "Strings-3-D#|Eb", "Strings-3-C#|Db", "Strings-3-B", "Strings-3-A#|Bb", "Strings-2-G#|Ab", "Strings-2-F#|Gb", "Strings-2-F", "Strings-2-D#|Eb", "Strings-2-D#|Eb", "Strings-2-C#|Db", "Strings-2-B", "Strings-2-A#|Bb", "Strings-1-G#|Ab", "Strings-1-F#|Gb", "Strings-1-F", "Strings-1-D#|Eb"]
        
        XCTAssertEqual(soundFileArrayBluesG, expectedBluesGArr, "scaleNoteNames are incorrect")
        XCTAssertEqual(soundFileArrayMelodicEb3actualTonic3, expectedMelodicEb3actualTonic3, "scaleNoteNames are incorrect")
    }
    
    /*
     Tests the toSoundFile method works with larger tempo
     */
    func testconvertToSoundFileTempoHigh() {
        let tempo = 100
        let scaleArrBluesG = ["1:G", "2:A#/Bb", "2:C", "2:C#/Db", "2:D", "2:F", "2:G", "2:F", "2:D", "2:C#/Db", "2:C", "2:A#/Bb", "1:G"]
        let melodicEb3actualTonic3 = ["1:D#/Eb", "1:F", "1:F#/Gb", "1:G#/Ab", "2:A#/Bb", "2:C", "2:D", "2:D#/Eb", "2:D#/Eb", "2:F", "2:F#/Gb", "2:G#/Ab", "3:A#/Bb", "3:C", "3:D", "3:D#/Eb", "3:D#/Eb", "3:F", "3:F#/Gb", "3:G#/Ab", "4:A#/Bb", "4:C", "4:D", "4:D#/Eb", "4:D#/Eb", "4:C#/Db", "4:B", "4:A#/Bb", "3:G#/Ab", "3:F#/Gb", "3:F", "3:D#/Eb", "3:D#/Eb", "3:C#/Db", "3:B", "3:A#/Bb", "2:G#/Ab", "2:F#/Gb", "2:F", "2:D#/Eb", "2:D#/Eb", "2:C#/Db", "2:B", "2:A#/Bb", "1:G#/Ab", "1:F#/Gb", "1:F", "1:D#/Eb"]
        
        let soundFileArrayBluesG = playSounds.convertToSoundFile(scaleInfoArray: scaleArrBluesG, tempo: tempo)
        let soundFileArrayMelodicEb3actualTonic3 = playSounds.convertToSoundFile(scaleInfoArray: melodicEb3actualTonic3, tempo: tempo)
        
        XCTAssertEqual(playSounds.instrument, "Strings", "instrument is incorrect")
        
        let expectedBluesGArr = ["Metronome", "Metronome", "Metronome", "Metronome", "Strings-1-G", "Strings-2-A#|Bb", "Strings-2-C", "Strings-2-C#|Db", "Strings-2-D", "Strings-2-F", "Strings-2-G", "Strings-2-F", "Strings-2-D", "Strings-2-C#|Db", "Strings-2-C", "Strings-2-A#|Bb", "Strings-1-G"]
        let expectedMelodicEb3actualTonic3 = ["Metronome", "Metronome", "Metronome", "Metronome", "Strings-1-D#|Eb", "Strings-1-F", "Strings-1-F#|Gb", "Strings-1-G#|Ab", "Strings-2-A#|Bb", "Strings-2-C", "Strings-2-D", "Strings-2-D#|Eb", "Strings-2-D#|Eb", "Strings-2-F", "Strings-2-F#|Gb", "Strings-2-G#|Ab", "Strings-3-A#|Bb", "Strings-3-C", "Strings-3-D", "Strings-3-D#|Eb", "Strings-3-D#|Eb", "Strings-3-F", "Strings-3-F#|Gb", "Strings-3-G#|Ab", "Strings-4-A#|Bb", "Strings-4-C", "Strings-4-D", "Strings-4-D#|Eb", "Strings-4-D#|Eb", "Strings-4-C#|Db", "Strings-4-B", "Strings-4-A#|Bb", "Strings-3-G#|Ab", "Strings-3-F#|Gb", "Strings-3-F", "Strings-3-D#|Eb", "Strings-3-D#|Eb", "Strings-3-C#|Db", "Strings-3-B", "Strings-3-A#|Bb", "Strings-2-G#|Ab", "Strings-2-F#|Gb", "Strings-2-F", "Strings-2-D#|Eb", "Strings-2-D#|Eb", "Strings-2-C#|Db", "Strings-2-B", "Strings-2-A#|Bb", "Strings-1-G#|Ab", "Strings-1-F#|Gb", "Strings-1-F", "Strings-1-D#|Eb"]
        
        XCTAssertEqual(soundFileArrayBluesG, expectedBluesGArr, "scaleNoteNames are incorrect")
        XCTAssertEqual(soundFileArrayMelodicEb3actualTonic3, expectedMelodicEb3actualTonic3, "scaleNoteNames are incorrect")
    }

    /*
     Tests the toSoundFile method works with an empty filee
     */
    func testconvertToSoundFileIncorrectInstrument() {
        let tempo = 60
        let smallArr = ["1:D#/Eb"]
        
        let soundFileArray = playSounds.convertToSoundFile(scaleInfoArray: smallArr, tempo: tempo)
        
        XCTAssertEqual(playSounds.instrument, "Strings", "instrument is incorrect")
        
        let expectedArr = ["Metronome", "Metronome", "Strings-1-D#|Eb"]
        
        XCTAssertEqual(soundFileArray, expectedArr, "expected array is incorrect")
    }
    
    ///TEST TRANSPOSED NOTES
    /*
     Test transposition on D#/Eb file transposition
     */
    func testGetTransposedNote() {
        let noteToTranspose1 = "C";
        let noteToTranspose2 = "G";
        let noteToTranspose3 = "A#|Bb";
        let noteToTranspose4 = "D#/Eb"; // Tests the old versions method
        let transposedNote1 = playSounds.getTransposedNote(selectedNote: noteToTranspose1)
        let transposedNote2 = playSounds.getTransposedNote(selectedNote: noteToTranspose2)
        let transposedNote3 = playSounds.getTransposedNote(selectedNote: noteToTranspose3)
        let transposedNote4 = playSounds.getTransposedNote(selectedNote: noteToTranspose4)
        
        let expectedTransposedNote1 = "D#|Eb"
        let expectedTransposedNote2 = "A#|Bb"
        let expectedTransposedNote3 = "C#|Db"
        let expectedTransposedNote4 = "F#|Gb"
        
        XCTAssertEqual(transposedNote1, expectedTransposedNote1, "transposition of C failed")
        XCTAssertEqual(transposedNote2, expectedTransposedNote2, "transposition of G failed")
        XCTAssertEqual(transposedNote3, expectedTransposedNote3, "transposition of A#/Bb failed")
        XCTAssertEqual(transposedNote4, expectedTransposedNote4, "transposition of D#/Eb failed")
    }
}
