//
//  PlayScales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/21.
//

import Swift
import AVFoundation
import SwiftySound

/**
 Play the sound files in various patterns to produce scales
 */
struct PlaySounds {
    
    private var fileReaderAndWriter = FileReaderAndWriter()
    private var toggler = true
    var metronomeTimer: Timer? = nil
    // For the drone
    var player: AVAudioPlayer?
    // For the metronome
    var player2: AVAudioPlayer?
    // For the scaleNotes
    var player3: AVAudioPlayer?
    // For the scaleNotes
    var player4: AVAudioPlayer?
    
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
    mutating func playScaleNote(scaleFileName: String, duration: CGFloat, finalNote: Bool) throws {
        let extra = 0.05
        guard let fileURL = Bundle.main.url(
            forResource: scaleFileName, withExtension: "mp3"
        ) else {
            throw SoundError.fileNoteFound(fileName: scaleFileName)
        }
        if toggler {
            self.player3 = try! AVAudioPlayer(contentsOf: fileURL)
            self.player3?.play()
            toggler.toggle()
            
            if !finalNote {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration + extra, execute: { [self] in
                    cancelScaleNoteSound1()
                })
            }
        } else {
            self.player4 = try! AVAudioPlayer(contentsOf: fileURL)
            self.player4?.play()
            
            if !finalNote {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration + extra, execute: { [self] in
                    cancelScaleNoteSound2()
                })
            }
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
        
        if (tempo < 70) {
            metronomeFileArr = [metronomeFile, metronomeFile]
        } else {
            metronomeFileArr = [metronomeFile, metronomeFile, metronomeFile, metronomeFile]
        }
        
        return metronomeFileArr
    }
    
    /**
     Sets the amount of offbeat pulses for the metronome
     */
    mutating func offBeatMetronome(fileName: String, rhythm: String, timeInterval: CGFloat) throws { /// AQServer.cpp:72    Exception caught in AudioQueueInternalNotifyRunning - error -66671
        var runCount = 0
        // For the offbeat metronome
        var player5: AVAudioPlayer?
        var player6: AVAudioPlayer?
        var player7: AVAudioPlayer?
        var player8: AVAudioPlayer?
        
        let timeSigniture : CGFloat
        
        switch rhythm.lowercased() {
        case "simple":
            timeSigniture = 3.0
        case "compound":
            timeSigniture = 2.0
        case "off":
            timeSigniture = 1.0
        default:
            timeSigniture = 1.0
        }
        
        guard let offBeatMetronomeURL = Bundle.main.url(
            forResource: fileName, withExtension: "mp3"
        ) else {
            throw SoundError.fileNoteFound(fileName: fileName)
        }
        
        player5 = try! AVAudioPlayer(contentsOf: offBeatMetronomeURL)
        player6 = try! AVAudioPlayer(contentsOf: offBeatMetronomeURL)
        player7 = try! AVAudioPlayer(contentsOf: offBeatMetronomeURL)
        player8 = try! AVAudioPlayer(contentsOf: offBeatMetronomeURL)
    
        Timer.scheduledTimer(withTimeInterval: (timeInterval/(timeSigniture + 1)), repeats: true) { timer in
            
            runCount += 1
            
            if (runCount == Int(timeSigniture)) {
                timer.invalidate()
            }
            switch runCount {
            case 0:
                player5?.play()
            case 1:
                player6?.play()
            case 2:
                player7?.play()
            case 3:
                player8?.play()
            default:
                player5?.play()
            }
        }
    }
    
    /**
     Plays the drone sound effects
     */
    mutating func playDroneSound(duration: CGFloat, startingNote: String) {
        let startingFileNote = startingNote.replacingOccurrences(of: "/", with: "|")
        let droneSoundFile = "\(drone)-Drone-\(startingFileNote)"

        if let droneURL = Bundle.main.url(forResource: droneSoundFile, withExtension: "mp3") {
            self.player = try! AVAudioPlayer(contentsOf: droneURL)
            self.player?.play()
            
            if (duration != -1 ) {
            
                let totalDuration = duration + 2.5
                self.player?.numberOfLoops = 4 // Increases all drones to 4 minutes at least
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: { [self] in
                    self.player?.setVolume(0.05, fadeDuration: 2.5)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration, execute: { [self] in
                    self.player?.stop()
                })
            }
        }
    }
    
    func getTransposedNote(selectedNote: String) -> String {
        var transpositionNote = fileReaderAndWriter.readTransposition()
        if (transpositionNote.components(separatedBy: " ").count > 1) {
            transpositionNote = transpositionNote.components(separatedBy: " ")[2]
            transpositionNote = getFullNote(singularNote: transpositionNote)
        }
        switch transpositionNote {
        case "C":
            return findNote(transposedNote: "C", selectedNote: selectedNote)
        case "G":
            return findNote(transposedNote: "G", selectedNote: selectedNote)
        case "D":
            return findNote(transposedNote: "D", selectedNote: selectedNote)
        case "A":
            return findNote(transposedNote: "A", selectedNote: selectedNote)
        case "E":
            return findNote(transposedNote: "E", selectedNote: selectedNote)
        case "B":
            return findNote(transposedNote: "B", selectedNote: selectedNote)
        case "F#/Gb":
            return findNote(transposedNote: "F#/Gb", selectedNote: selectedNote)
        case "C#/Db":
            return findNote(transposedNote: "C#/Db", selectedNote: selectedNote)
        case "G#/Ab":
            return findNote(transposedNote: "G#/Ab", selectedNote: selectedNote)
        case "D#/Eb":
            return findNote(transposedNote: "D#/Eb", selectedNote: selectedNote)
        case "A#/Bb":
            return findNote(transposedNote: "A#/Bb", selectedNote: selectedNote)
        case "F":
            return findNote(transposedNote: "F", selectedNote: selectedNote)
        default:
            return "not Found"
        }
    }
    
    private func findNote(transposedNote: String, selectedNote: String) -> String {
        let orderedAlphabet = ["A","A#/Bb","B","C","C#/Db","D","D#/Eb","E","F","F#/Gb","G","G#/Ab","A","A#/Bb","B","C","C#/Db","D","D#/Eb","E","F","F#/Gb","G","G#/Ab"]
        // Twice as long too allow only going forwards
        let transposedIndex = orderedAlphabet.firstIndex(of: transposedNote) ?? 0
        let CIndex = orderedAlphabet.firstIndex(of: "C") ?? 0
        let selectedIndex = orderedAlphabet.firstIndex(of: selectedNote) ?? 0
        let difference = CIndex - transposedIndex
        let arrayIndex = selectedIndex - difference
        return orderedAlphabet[arrayIndex]
    }
    
    /// ALSO IN WRITE SCALES
    private func getFullNote(singularNote: String) -> String{
        switch singularNote {
        case "F#", "Gb":
            return "F#/Gb"
        case "C#", "Db":
            return "C#/Db"
        case "G#", "Ab":
            return "G#/Ab"
        case "D#", "Eb":
            return "D#/Eb"
        case "A#", "Bb":
            return "A#/Bb"
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
            forResource: metronomeFile, withExtension: "mp3"
        ) else {
            throw SoundError.fileNoteFound(fileName: metronomeFile)
        }
        
        player2 = try! AVAudioPlayer(contentsOf: metronomeURL)
        player2?.play()
    }
    
    private mutating func cancelPreviousTimer() {
        metronomeTimer?.invalidate()
        self.metronomeTimer = nil
    }
    
    private func cancelScaleNoteSound1() {
        self.player3?.stop()
    }
    
    private func cancelScaleNoteSound2() {
        self.player4?.stop()
    }
    
    private func cancelDroneSound() {
        self.player?.stop()
    }
    
    private func cancelMetronomeSound() {
        self.player2?.stop()
    }
    
    mutating func cancelAllSounds() {
        cancelPreviousTimer()
        cancelDroneSound()
        cancelMetronomeSound()
        cancelScaleNoteSound1()
        cancelScaleNoteSound2()
    }
}
