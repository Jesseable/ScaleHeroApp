//
//  MuscArrayTest.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/2024.
//

import XCTest
@testable import ScaleHero

class MusicArrayTests: XCTestCase {
    let fileReaderAndWriter = FileReaderAndWriter()
    
    /*
     Initialise the fileReaderAndWriter
     */
    override func setUp() {
        self.fileReaderAndWriter.writeNewTransposition(newTransposition: Notes.C.name)
    }
    
    func testConvertToOctaveSize_cArpeggio() {
        let cArpeggio: [Notes] = [.C, .E, .G, .C, .G, .E, .C]
        let numOctaves = OctaveNumber.three
        let musicArray = MusicArray(notes: cArpeggio)
        let musicNotes = MusicNotes()
        musicNotes.octaves = numOctaves
        
        musicArray.applyModifications(musicNotes: musicNotes)
                
        let expectedOutput: [Notes] = [
            .C, .E, .G, .C, .E, .G, .C, .E, .G, .C, .G, .E, .C, .G, .E, .C, .G, .E, .C
        ]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "increasing the C major arpeggios octave size to 3 has failed")
    }
    
    func testConvertToOctaveSize_chromatic() {
        let chromaticScale: [Notes] = [
            .C, .C_SHARP, .D, .D_SHARP, .E, .F, .F_SHARP, .G, .G_SHARP, .A, .A_SHARP, .B, .C,
            .B, .B_FLAT, .A, .A_FLAT, .G, .G_FLAT, .F, .E, .E_FLAT, .D, .D_FLAT, .C
        ]
        let numOctaves = OctaveNumber.two
        let musicArray = MusicArray(notes: chromaticScale)
        let musicNotes = MusicNotes()
        musicNotes.octaves = numOctaves
        
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [Notes] = [
            .C, .C_SHARP, .D, .D_SHARP, .E, .F, .F_SHARP, .G, .G_SHARP, .A, .A_SHARP, .B, .C,
            .C_SHARP, .D, .D_SHARP, .E, .F, .F_SHARP, .G, .G_SHARP, .A, .A_SHARP, .B, .C,
            .B, .B_FLAT, .A, .A_FLAT, .G, .G_FLAT, .F, .E, .E_FLAT, .D, .D_FLAT, .C,
            .B, .B_FLAT, .A, .A_FLAT, .G, .G_FLAT, .F, .E, .E_FLAT, .D, .D_FLAT, .C
        ]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "increasing the C chromatic octave size to 3 has failed")
    }
    
    func testRotateScale_ionian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.ionian.rawValue)
        
        XCTAssertEqual(cMajor, musicArray.getNotes(), "rotation to D dorian failed")
    }
    
    func testRotateScale_dorian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.dorian.rawValue)

        let expectedOutput: [Notes] = [.D, .E, .F, .G, .A, .B, .C, .D, .C, .B, .A, .G, .F, .E, .D]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to D dorian failed")
    }
    
    func testRotateScale_phrygian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.phrygian.rawValue)

        let expectedOutput: [Notes] = [.E, .F, .G, .A, .B, .C, .D, .E, .D, .C, .B, .A, .G, .F, .E]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to E Phrygian failed")
    }
    
    func testRotateScale_lydian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.lydian.rawValue)

        let expectedOutput: [Notes] = [.F, .G, .A, .B, .C, .D, .E, .F, .E, .D, .C, .B, .A, .G, .F]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to F Lydian failed")
    }
    
    func testRotateScale_mixolydian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.mixolydian.rawValue)

        let expectedOutput: [Notes] = [.G, .A, .B, .C, .D, .E, .F, .G, .F, .E, .D, .C, .B, .A, .G]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to G Mixolydian failed")
    }
    
    func testRotateScale_aeolian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.aeolian.rawValue)

        let expectedOutput: [Notes] = [.A, .B, .C, .D, .E, .F, .G, .A, .G, .F, .E, .D, .C, .B, .A]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to A Aeolian failed")
    }
    
    func testRotateScale_locrian() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        musicArray.rotateScale(by: MajorScaleMode.locrian.rawValue)

        let expectedOutput: [Notes] = [.B, .C, .D, .E, .F, .G, .A, .B, .A, .G, .F, .E, .D, .C, .B]
        
        XCTAssertEqual(expectedOutput, musicArray.getNotes(), "rotation to B Locrian failed")
    }
    
    func testApplyModification_applyPitches_scale() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cMajor)
        
        let musicNotes = MusicNotes()
        musicNotes.startingOctave = OctaveNumber.one
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [Pitch] = [Pitch(note: .C, octave: .one), Pitch(note: .D, octave: .one), Pitch(note: .E, octave: .one),
                                       Pitch(note: .F, octave: .one), Pitch(note: .G, octave: .one), Pitch(note: .A, octave: .two),
                                       Pitch(note: .B, octave: .two), Pitch(note: .C, octave: .two), Pitch(note: .B, octave: .two),
                                       Pitch(note: .A, octave: .two), Pitch(note: .G, octave: .one), Pitch(note: .F, octave: .one),
                                       Pitch(note: .E, octave: .one), Pitch(note: .D, octave: .one), Pitch(note: .C, octave: .one)]
        XCTAssertEqual(expectedOutput, musicArray.getPitches(), "apply pitches failed for c major scale")
    }
    
    func testApplyModification_applyPitches_arpeggio() {
        let cMajorArpeggio: [Notes] = [.C, .E, .G, .C, .G, .E, .C]
        
        let musicArray = MusicArray(notes: cMajorArpeggio)
        
        let musicNotes = MusicNotes()
        musicNotes.startingOctave = OctaveNumber.one
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [Pitch] = [Pitch(note: .C, octave: .one), Pitch(note: .E, octave: .one), Pitch(note: .G, octave: .one),
                                       Pitch(note: .C, octave: .two), Pitch(note: .G, octave: .one), Pitch(note: .E, octave: .one),
                                       Pitch(note: .C, octave: .one)]
        XCTAssertEqual(expectedOutput, musicArray.getPitches(), "apply pitches failed for c major arpeggio")
    }
    
    // TODO: I should have a test checking that an erro is thrown when starting octave is not two and no. octaves is not one
    
    func testApplyModification_addIntervalOption_toAllUp_thirds() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allUp, intervalOption: .thirds)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "E:2", "D:2", "F:2", "E:2", "G:2", "F:2", "A:3", "G:2", "B:3", "A:3", "C:3", "B:3", "D:3", "C:3",
                                        "E:3", "B:3", "D:3", "A:3", "C:3",  "G:2", "B:3", "F:2", "A:3", "E:2", "G:2", "D:2", "F:2", "C:2", "E:2", "B:2", "D:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toAllUp_fourths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allUp, intervalOption: .fourths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "F:2", "D:2", "G:2", "E:2", "A:3", "F:2", "B:3", "G:2", "C:3", "A:3", "D:3", "B:3", "E:3", "C:3",
                                        "F:3", "B:3", "E:3", "A:3", "D:3", "G:2", "C:3", "F:2", "B:3", "E:2", "A:3", "D:2", "G:2", "C:2", "F:2", "B:2", "E:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in fourths")
    }
    
    func testApplyModification_addIntervalOption_toAllUp_fifths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allUp, intervalOption: .fifths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "G:2", "D:2", "A:3", "E:2", "B:3", "F:2", "C:3", "G:2", "D:3", "A:3", "E:3", "B:3", "F:3", "C:3",
                                        "G:3", "B:3", "F:3", "A:3", "E:3", "G:2", "D:3", "F:2", "C:3", "E:2", "B:3", "D:2", "A:3", "C:2", "G:2", "B:2", "F:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in fourths")
    }
    
    func testApplyModification_addIntervalOption_toAllDown_thirds() {
        // Test it for C major and with 1 and 3 octaves
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allDown, intervalOption: .thirds)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["E:2", "C:2", "F:2", "D:2", "G:2", "E:2", "A:3", "F:2", "B:3", "G:2", "C:3", "A:3", "D:3", "B:3", "E:3", "C:3",
                                        "D:3", "B:3", "C:3", "A:3", "B:3", "G:2", "A:3", "F:2", "G:2", "E:2", "F:2", "D:2", "E:2", "C:2", "D:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toAllDown_fourths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allDown, intervalOption: .fourths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["F:2", "C:2", "G:2", "D:2", "A:3", "E:2", "B:3", "F:2", "C:3", "G:2", "D:3", "A:3", "E:3", "B:3", "F:3", "C:3",
                                        "E:3", "B:3", "D:3", "A:3", "C:3", "G:2", "B:3", "F:2", "A:3", "E:2", "G:2", "D:2", "F:2", "C:2", "E:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toAllDown_fifths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .allDown, intervalOption: .fifths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["G:2", "C:2", "A:3", "D:2", "B:3", "E:2", "C:3", "F:2", "D:3", "G:2", "E:3", "A:3", "F:3", "B:3", "G:3", "C:3",
                                        "F:3", "B:3", "E:3", "A:3", "D:3", "G:2", "C:3", "F:2", "B:3", "E:2", "A:3", "D:2", "G:2", "C:2", "F:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneUpOneDown_thirds() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneUpOneDown, intervalOption: .thirds)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "E:2", "F:2", "D:2", "E:2", "G:2", "A:3", "F:2", "G:2", "B:3", "C:3", "A:3", "B:3", "D:3", "E:3", "C:3",
                                        "B:3", "D:3", "C:3", "A:3", "G:2", "B:3", "A:3", "F:2", "E:2", "G:2", "F:2", "D:2", "C:2", "E:2", "D:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneUpOneDown_fourths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneUpOneDown, intervalOption: .fourths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "F:2", "G:2", "D:2", "E:2", "A:3", "B:3", "F:2", "G:2", "C:3", "D:3", "A:3", "B:3", "E:3", "F:3", "C:3",
                                        "B:3", "E:3", "D:3", "A:3", "G:2", "C:3", "B:3", "F:2", "E:2", "A:3", "G:2", "D:2", "C:2", "F:2", "E:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneUpOneDown_fifths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneUpOneDown, intervalOption: .fifths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:2", "G:2", "A:3", "D:2", "E:2", "B:3", "C:3", "F:2", "G:2", "D:3", "E:3", "A:3", "B:3", "F:3", "G:3", "C:3",
                                        "B:3", "F:3", "E:3", "A:3", "G:2", "D:3", "C:3", "F:2", "E:2", "B:3", "A:3", "D:2", "C:2", "G:2", "F:2", "B:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneDownOneUp_thirds() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneDownOneUp, intervalOption: .thirds)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["E:2", "C:2", "D:2", "F:2", "G:2", "E:2", "F:2", "A:3", "B:3", "G:2", "A:3", "C:3", "D:3", "B:3", "C:3",
                                        "E:3", "D:3", "B:3", "A:3", "C:3", "B:3", "G:2", "F:2", "A:3", "G:2", "E:2", "D:2", "F:2", "E:2", "C:2", "B:2", "D:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneDownOneUp_forths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneDownOneUp, intervalOption: .fourths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["F:2", "C:2", "D:2", "G:2", "A:3", "E:2", "F:2", "B:3", "C:3", "G:2", "A:3", "D:3", "E:3", "B:3", "C:3",
                                        "F:3", "E:3", "B:3", "A:3", "D:3", "C:3", "G:2", "F:2", "B:3", "A:3", "E:2", "D:2", "G:2", "F:2", "C:2", "B:2", "E:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    func testApplyModification_addIntervalOption_toOneDownOneUp_fifths() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = setUpMusicNotesForIntervals(intervalType: .oneDownOneUp, intervalOption: .fifths)
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["G:2", "C:2", "D:2", "A:3", "B:3", "E:2", "F:2", "C:3", "D:3", "G:2", "A:3", "E:3", "F:3", "B:3", "C:3",
                                        "G:3", "F:3", "B:3", "A:3", "E:3", "D:3", "G:2", "F:2", "C:3", "B:3", "E:2", "D:2", "A:3", "G:2", "C:2", "B:2", "F:2", "C:2"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it to AllUp in thrids")
    }
    
    private func setUpMusicNotesForIntervals(intervalType: IntervalOption, intervalOption: Interval) -> MusicNotes {
        let musicNotes = MusicNotes()
        musicNotes.startingOctave = OctaveNumber.two
        musicNotes.octaves = OctaveNumber.one
        musicNotes.intervalType = intervalType
        musicNotes.intervalOption = intervalOption
        return musicNotes
    }
    
    func testApplyModification_convertToTonicOptions_allTonics() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = MusicNotes()
        musicNotes.tonicMode = .repeatedTonicAll
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:1", "C:1", "D:1", "E:1", "F:1", "G:1", "A:2", "B:2", "C:2", "C:2", "B:2", "A:2", "G:1", "F:1", "E:1", "D:1", "C:1", "C:1"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it repeat all tonics")
    }
    
    func testApplyModification_convertToTonicOptions_allTonicsButStartAndEnd() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = MusicNotes()
        musicNotes.tonicMode = .repeatedTonic
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:1", "D:1", "E:1", "F:1", "G:1", "A:2", "B:2", "C:2", "C:2", "B:2", "A:2", "G:1", "F:1", "E:1", "D:1", "C:1"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it repeat all tonics")
    }
    
    func testApplyModification_repeatAllNotes() {
        let cMajor: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]

        let musicArray = MusicArray(notes: cMajor)
        let musicNotes = MusicNotes()
        musicNotes.repeatNotes = true
        musicArray.applyModifications(musicNotes: musicNotes)
        
        let expectedOutput: [String] = ["C:1", "C:1", "D:1", "D:1", "E:1", "E:1", "F:1", "F:1", "G:1", "G:1", "A:2", "A:2", "B:2", "B:2", "C:2",
                                        "C:2", "B:2", "B:2", "A:2", "A:2", "G:1", "G:1", "F:1", "F:1", "E:1", "E:1", "D:1", "D:1", "C:1", "C:1"]
        let actualReadablePitches = musicArray.getPitches().map(pitchToReadableString)
        
        XCTAssertEqual(expectedOutput, actualReadablePitches, "apply pitches failed for c major when converting it repeat all tonics")
    }
    
    func testTranspose_cToA() {
        let transpositionNote = FileNotes.A
        self.fileReaderAndWriter.writeNewTranspositionNote(fileNote: transpositionNote)
        let cIonianScale: [Notes] = [.C, .D, .E, .F, .G, .A, .B, .C, .B, .A, .G, .F, .E, .D, .C]
        
        let musicArray = MusicArray(notes: cIonianScale)
        setBasicModulationForPitchArray(musicArrays: musicArray)
        
        let expectedOutput: [String] = ["A:1", "B:1", "C#|Db:1", "D:1", "E:1", "F#|Gb:1", "G#|Ab:1", "A:2", "G#|Ab:1", "F#|Gb:1", "E:1", "D:1", "C#|Db:1", "B:1", "A:1"]
        
        let transposedNotesReadable = musicArray.constructTransposedSoundFileArray().map(filePitchToReadableString)
        
        XCTAssertEqual(expectedOutput, transposedNotesReadable, "Transposing the C major scale to A has failed")
    }
    
    func testTranspose_fSharpArpeggioToBb() {
        let transpositionNote = FileNotes.A_SHARP_B_FLAT
        self.fileReaderAndWriter.writeNewTranspositionNote(fileNote: transpositionNote)

        let fSharpArpeggio: [Notes] = [.F_SHARP, .A, .C_SHARP, .F_SHARP, .C_SHARP, .A, .F_SHARP]
        
        let musicArray = MusicArray(notes: fSharpArpeggio)
        setBasicModulationForPitchArray(musicArrays: musicArray)
        
        let expectedOutput: [String] = ["E:1", "G:1", "B:2", "E:2", "B:2", "G:1", "E:1"]
        
        let transposedNotesReadable = musicArray.constructTransposedSoundFileArray().map(filePitchToReadableString)
        
        XCTAssertEqual(expectedOutput, transposedNotesReadable, "Transposing the F-sharp major arpeggio to B-flat has failed")
    }
    
    func testTranspose_dMajorToEb() {
        let transpositionNote = FileNotes.D_SHARP_E_FLAT
        self.fileReaderAndWriter.writeNewTranspositionNote(fileNote: transpositionNote)
        let fSharpArpeggio: [Notes] = [.D, .E, .F_SHARP, .G, .A, .B, .C_SHARP, .D, .C_SHARP, .B, .A, .G, .F_SHARP, .E, .D]
        
        let musicArray = MusicArray(notes: fSharpArpeggio)
        setBasicModulationForPitchArray(musicArrays: musicArray)
        
        let expectedOutput: [String] = ["F:1", "G:1", "A:2", "A#|Bb:2", "C:2", "D:2", "E:2", "F:2", "E:2", "D:2", "C:2", "A#|Bb:2", "A:2", "G:1", "F:1"]
        
        let transposedNotesReadable = musicArray.constructTransposedSoundFileArray().map(filePitchToReadableString)
        
        XCTAssertEqual(expectedOutput, transposedNotesReadable, "Transposing the D major arpeggio to E-flat has failed")
    }
    
    func testTransposition_basicSingleNotes() {
        let transpositionNote = FileNotes.D_SHARP_E_FLAT
        self.fileReaderAndWriter.writeNewTranspositionNote(fileNote: transpositionNote)
        let musicArrayC = MusicArray(notes: [.C])
        let musicArrayG = MusicArray(notes: [.G])
        let musicArrayASharp = MusicArray(notes: [.A_SHARP])
        let musicArrayEFlat = MusicArray(notes: [.E_FLAT])
        setBasicModulationForPitchArray(musicArrays: musicArrayC, musicArrayG, musicArrayASharp, musicArrayEFlat)
        
        let expectedTransposedNote1 = [FilePitch(fileNote: FileNotes.D_SHARP_E_FLAT, octave: NoteOctaveOption.one)]
        let expectedTransposedNote2 = [FilePitch(fileNote: FileNotes.A_SHARP_B_FLAT, octave: NoteOctaveOption.one)]
        let expectedTransposedNote3 = [FilePitch(fileNote: FileNotes.C_SHARP_D_FLAT, octave: NoteOctaveOption.one)]
        let expectedTransposedNote4 = [FilePitch(fileNote: FileNotes.F_SHARP_G_FLAT, octave: NoteOctaveOption.one)]
        
        XCTAssertEqual(expectedTransposedNote1, musicArrayC.constructTransposedSoundFileArray(), "transposition of C failed")
        XCTAssertEqual(expectedTransposedNote2, musicArrayG.constructTransposedSoundFileArray(), "transposition of G failed")
        XCTAssertEqual(expectedTransposedNote3, musicArrayASharp.constructTransposedSoundFileArray(), "transposition of A#/Bb failed")
        XCTAssertEqual(expectedTransposedNote4, musicArrayEFlat.constructTransposedSoundFileArray(), "transposition of D#/Eb failed")
    }
    
    private func setBasicModulationForPitchArray(musicArrays: MusicArray...) {
        for musicArray in musicArrays {
            let musicNotes = MusicNotes();
            musicArray.applyModifications(musicNotes: musicNotes)
        }
    }
        
    private func pitchToReadableString(_ pitch: Pitch) -> String {
        var readableString: String = ""
        readableString.append(pitch.note.name)
        readableString.append(":")
        readableString.append(String(pitch.octave.rawValue))
        return readableString
    }
    
    private func filePitchToReadableString(_ filePitch: FilePitch) -> String {
        var readableString: String = ""
        readableString.append(filePitch.fileNote.name)
        readableString.append(":")
        readableString.append(String(filePitch.octave.rawValue))
        return readableString
    }
}
