//
//  PlayScales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/21.
//

import Swift
import SwiftySound
import AVFoundation

/**
 Play the sound files in various patterns to produce scales
 */
struct PlaySounds {
    
    private var fileReaderAndWriter = FileReaderAndWriter()
    var metronomeTimer: Timer? = nil
    // For the drone
    var player: AVAudioPlayer?
    // For the metronome
    var player2: AVAudioPlayer?
    
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
    mutating func offBeatMetronome(fileName: String, rhythm: String, timeInterval: CGFloat) { /// AQServer.cpp:72    Exception caught in AudioQueueInternalNotifyRunning - error -66671
        let timeSigniture = (rhythm == "4/4") ? 3.0 : 2.0 // Only two options. 4/4 or 3/4 atm
        var runCount = 0
        var player3: AVAudioPlayer? // Maybe later try to move outside of this function
                
        Timer.scheduledTimer(withTimeInterval: (timeInterval/(timeSigniture + 1)), repeats: true) { timer in
            if (runCount == Int(timeSigniture)) {
                timer.invalidate()
            }
            if let offBeatMetronomeURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
                player3 = try! AVAudioPlayer(contentsOf: offBeatMetronomeURL)
                player3?.play()
            }
            runCount += 1
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
    
    /**
     Plays the metronomes sound files
     */
    mutating func playMetronome() {
        let metronomeFile = "Metronome"
        if let metronomeURL = Bundle.main.url(forResource: metronomeFile, withExtension: "mp3") {
            player2 = try! AVAudioPlayer(contentsOf: metronomeURL)
            player2?.play()
        }
    }
    
    private mutating func cancelPreviousTimer() {
        metronomeTimer?.invalidate()
        self.metronomeTimer = nil
    }
    
    private func cancelDroneSound() {
        self.player?.stop()
    }
    
    private func cancelMetronomeSound() {
        self.player2?.stop()
        //self.player3?.stop()
    }
    
    mutating func cancelAllSounds() {
        Sound.enabled = false
        cancelPreviousTimer()
        cancelDroneSound()
        cancelMetronomeSound()
    }
}
