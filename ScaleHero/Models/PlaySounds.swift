//
//  PlayScales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/21.
//

import Swift
import AVFoundation

/**
 Play the sound files in various patterns to produce scales
 */
struct PlaySounds {
    
    private var fileReaderAndWriter = FileReaderAndWriter()
    private var toggler = true
    var metronomeTimer: Timer? = nil
    // For the drone
    var dronePlayer: AVAudioPlayer?
    // For the metronome
    var metronomePlayer: AVAudioPlayer?
    // For the scaleNotes1
    var notesPlayer1: AVAudioPlayer? // TODO: Why are there 2??? -  I believe so that they overlap one another, makes for a smoother experience. But I should rename
    // For the scaleNotes2
    var notesPlayer2: AVAudioPlayer?
    
    lazy var instrument: String = {
        [self] in
        switch self.fileReaderAndWriter.readScaleInstrument() {
        case "Organ":
            return "Organ"
        case "Piano":
            return "Piano"
        case "Strings":
            return "Strings"
        default:
            return "Piano"
        }
    }()
    
    lazy var drone: String = {
        [self] in
        switch self.fileReaderAndWriter.readDroneInstrument() {
        case "Cello":
            return "Cello"
        case "Tuning Fork":
            return "TuningFork1"
        default:
            return "Cello"
        }
    }()
    
    /**
     Play ScaleNote Sounds
     */
    mutating func playScaleNote(filePitch: FilePitch, duration: CGFloat, isFinalNote: Bool) throws {
        let fileName = "\(instrument)-\(filePitch.octave.rawValue)-\(filePitch.fileNote.name)"
        let extra = 0.1
        guard let fileURL = Bundle.main.url(
            forResource: fileName, withExtension: "mp3"
        ) else {
            throw SoundError.fileNoteFound(fileName: fileName)
        }
        self.notesPlayer1 = try! AVAudioPlayer(contentsOf: fileURL)
        self.notesPlayer1?.play()
        toggler.toggle()  // TODO: Does this just get stuck in the else after this???  Maybe I only need one fo these in the end anyway...
        
        if !isFinalNote {
            // Adds the fade effect
            DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.05, execute: { [self] in // TODO: Magic numbers used
                self.notesPlayer1?.setVolume(0.1, fadeDuration: 0.15)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + extra, execute: { [self] in
                cancelScaleNoteSound1()
            })
        }
    }
    
    /**
     Converts the array into a readable file name (mp3 format)
     */
    mutating func convertToSoundFile(scaleInfoArray: [String], tempo: Int) -> [String] {
        var soundFileArr: [String] = []
        
        for scaleNote in scaleInfoArray {
            let scaleComponentsArr = scaleNote.components(separatedBy: ":")
            let newStringNote = scaleComponentsArr[1].replacingOccurrences(of: "/", with: "|")
            let soundFileString = "\(instrument)-\(scaleComponentsArr[0])-\(newStringNote)"
            soundFileArr.append(soundFileString)
        }
        
        soundFileArr.insert(contentsOf: addMetronome(tempo: tempo), at: 0)
        
        return soundFileArr
    }
    
    /**
     Creates an array of the metronome sound files to be added to the sound files array
     */
    private func addMetronome(tempo: Int) -> [String] {
        let metronomeFile = "Metronome"
        var metronomeFileArr: [String] = []
        let introBeatsArr = fileReaderAndWriter.readIntroBeats().components(separatedBy: "-")
        let slowTempoIntro = Int(introBeatsArr[0])
        let fastTempoIntro = Int(introBeatsArr[1])
        
        if (tempo < 70) {
            slowTempoIntro?.times {
                metronomeFileArr.append(metronomeFile)
            }
        } else {
            fastTempoIntro?.times {
                metronomeFileArr.append(metronomeFile)
            }
        }
        
        return metronomeFileArr
    }
    
    func retrieveMetronomeCountInLength(for tempo: Int) -> Int {
        let introBeatsArr = fileReaderAndWriter.readIntroBeats().components(separatedBy: "-")
        let slowTempoIntro = Int(introBeatsArr[0])
        let fastTempoIntro = Int(introBeatsArr[1])
        if tempo < 70 { //  TODO: This is a mgic number
            return slowTempoIntro ?? 0
        } else {
            return fastTempoIntro ?? 0
        }
    }
    
    /**
     Creates an array of the metronome sound files to be added to the sound files array
     */
    func addMetronomeCountIn(tempo: Int, scaleNotesArray: [String]) -> [String] { // TODO: Will be redundant
        let countingArr = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
        var metronomeFileArr: [String] = []
        let introBeatsArr = fileReaderAndWriter.readIntroBeats().components(separatedBy: "-")
        let slowTempoIntro = Int(introBeatsArr[0])
        let fastTempoIntro = Int(introBeatsArr[1])
        var i : Int
        if (tempo < 70) {
            i = slowTempoIntro ?? 0
            slowTempoIntro?.times {
                metronomeFileArr.append(countingArr[i-1])
                i -= 1
            }
        } else {
            i = fastTempoIntro ?? 0
            fastTempoIntro?.times {
                metronomeFileArr.append(countingArr[i-1])
                i -= 1
            }
        }
        
        return metronomeFileArr
    }
    
    /**
     Plays the off beat metronome sound
     */
    mutating func playOffbeatMetronome() throws {
        
        if ((metronomePlayer?.isPlaying) != nil) {
            metronomePlayer?.stop()
        }
        let metronomeOffBeatFile = "Metronome1"
        guard let metronomeOffBeatURL = Bundle.main.url(
            forResource: metronomeOffBeatFile, withExtension: "wav"
        ) else {
            throw SoundError.fileNoteFound(fileName: metronomeOffBeatFile)
        }
        
        metronomePlayer = try! AVAudioPlayer(contentsOf: metronomeOffBeatURL)
        metronomePlayer?.play()
    }
    
    /**
     Plays the drone sound effects
     */
    mutating func playDroneSound(duration: CGFloat, tonicNote: FileNotes) {
        let droneSoundFile = "\(drone)-Drone-\(tonicNote.name)"

        if let droneURL = Bundle.main.url(forResource: droneSoundFile, withExtension: "mp3") {
            self.dronePlayer = try! AVAudioPlayer(contentsOf: droneURL)
            self.dronePlayer?.play()
            
            if (duration != -1 ) {
            
                let totalDuration = duration + 2.5
                self.dronePlayer?.numberOfLoops = 4 // Increases all drones to 5 minutes at least
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: { [self] in
                    self.dronePlayer?.setVolume(0.05, fadeDuration: 2.5)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration, execute: { [self] in
                    self.dronePlayer?.stop()
                })
            } else {
                self.dronePlayer?.numberOfLoops = -1 // Loops the sound continuously
            }
        }
    }
    
    
    func getTransposedNote(selectedNote: String) -> String { // TODO: Convert this to being done in the MusicArray
        var transpositionNote = fileReaderAndWriter.readTranspositionFile()
        // Has to be done in case the old string value from previous version is still active
        transpositionNote = transpositionNote.replacingOccurrences(of: "/", with: "|")
        let selectedNoteAltered = selectedNote.replacingOccurrences(of: "/", with: "|")
        
        if (transpositionNote.components(separatedBy: " ").count > 1) {
            transpositionNote = transpositionNote.components(separatedBy: " ")[2]
        }
        transpositionNote = getFullNote(singularNote: transpositionNote)
        let selectedNoteReadable = getFullNote(singularNote: selectedNoteAltered)
        switch transpositionNote {
        case "C":
            return findNote(transposedNote: "C", selectedNote: selectedNoteReadable)
        case "G":
            return findNote(transposedNote: "G", selectedNote: selectedNoteReadable)
        case "D":
            return findNote(transposedNote: "D", selectedNote: selectedNoteReadable)
        case "A":
            return findNote(transposedNote: "A", selectedNote: selectedNoteReadable)
        case "E":
            return findNote(transposedNote: "E", selectedNote: selectedNoteReadable)
        case "B":
            return findNote(transposedNote: "B", selectedNote: selectedNoteReadable)
        case "F#|Gb":
            return findNote(transposedNote: "F#|Gb", selectedNote: selectedNoteReadable)
        case "C#|Db":
            return findNote(transposedNote: "C#|Db", selectedNote: selectedNoteReadable)
        case "G#|Ab":
            return findNote(transposedNote: "G#|Ab", selectedNote: selectedNoteReadable)
        case "D#|Eb":
            return findNote(transposedNote: "D#|Eb", selectedNote: selectedNoteReadable)
        case "A#|Bb":
            return findNote(transposedNote: "A#|Bb", selectedNote: selectedNoteReadable)
        case "F":
            return findNote(transposedNote: "F", selectedNote: selectedNoteReadable)
        default:
            print("Error: Transition note was not found")
            return "not Found"
        }
    }
    
    // TODO: This is all redundant woith my new cvhanges
    private func findNote(transposedNote: String, selectedNote: String) -> String {
        let orderedAlphabet = ["A","A#|Bb","B","C","C#|Db","D","D#|Eb","E","F","F#|Gb","G","G#|Ab","A","A#|Bb","B","C","C#|Db","D","D#|Eb","E","F","F#|Gb","G","G#|Ab"]
        // Twice as long too allow only going forwards
        let transposedIndex = orderedAlphabet.firstIndex(of: transposedNote) ?? 0
        let indexOfNoteC = orderedAlphabet.firstIndex(of: "C") ?? 0
        let selectedIndex = orderedAlphabet.firstIndex(of: selectedNote) ?? 0
        let difference = indexOfNoteC - transposedIndex
        let arrayIndex = selectedIndex - difference
        return orderedAlphabet[arrayIndex]
    }
    
    /// ALSO IN WRITE SCALES -> TODO: Will be deleted soon
    private func getFullNote(singularNote: String) -> String{
        switch singularNote {
            // Equivalent note name cases
        case "A##", "Cb":
            return "B"
        case "B#", "Dbb":
            return "C"
        case "C##", "Ebb":
            return "D"
        case "D##", "Fb":
            return "E"
        case "E#", "Gbb":
            return "F"
        case "F##", "Abb":
            return "G"
        case "G##", "Bbb":
            return "A"
            // Sharp/flat cases
        case "F#", "Gb", "E##":
            return "F#|Gb"
        case "C#", "Db", "B##":
            return "C#|Db"
        case "G#", "Ab":
            return "G#|Ab"
        case "D#", "Eb", "Fbb":
            return "D#|Eb"
        case "A#", "Bb", "Cbb":
            return "A#|Bb"
        default:
            return singularNote
        }
    }
    
    /**
     Plays the metronomes sound files
     */
    mutating func playMetronome() throws {
        let metronomeFile = "Metronome"
        guard let metronomeURL = Bundle.main.url(
            forResource: metronomeFile, withExtension: "wav"
        ) else {
            throw SoundError.fileNoteFound(fileName: metronomeFile)
        }
        
        metronomePlayer = try! AVAudioPlayer(contentsOf: metronomeURL)
        metronomePlayer?.play()
    }
    
    private mutating func cancelPreviousTimer() {
        metronomeTimer?.invalidate()
        self.metronomeTimer = nil
    }
    
    private func cancelScaleNoteSound1() {
        self.notesPlayer1?.stop()
    }
    
    private func cancelScaleNoteSound2() {
        self.notesPlayer2?.stop()
    }
    
    private func cancelDroneSound() {
        self.dronePlayer?.stop()
    }
    
    private func cancelMetronomeSound() {
        self.metronomePlayer?.stop()
    }
    
    mutating func cancelAllSounds() {
        cancelPreviousTimer()
        cancelDroneSound()
        cancelMetronomeSound()
        cancelScaleNoteSound1()
        cancelScaleNoteSound2()
    }
}
