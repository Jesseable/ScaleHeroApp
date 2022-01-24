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
    
    var fileReaderAndWriter = FileReaderAndWriter()
    var metronomeTimer: Timer? = nil
    var player: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    lazy var instrument: String = {
        [self] in
        switch self.fileReaderAndWriter.readScaleInstrument() {
        case "Cello":
            return "Cello"
        case "Jesse's Vocals":
            return "JTest"
        default:
            return "Cello"
        }
    }()
    
    lazy var drone: String = {
        return "Cello"
//        [self] in
//        switch self.fileReaderAndWriter.readScaleInstrument() {
//        case "Cello":
//            return "Cello"
//        case "Jesse's Vocals":
//            return "JTest"
//        default:
//            return "Cello"
//        }
    }()
    
    /**
     Converts the array into a readable file name (mp3 format)
     */
    mutating func convertToSoundFile(scaleInfoArray: [String], tempo: Int) -> [String] {
        var soundFileArr: [String] = []
        let metronomeFile = "Metronome"
        
        for scaleNote in scaleInfoArray {
            let scaleComponentsArr = scaleNote.components(separatedBy: ":")
            let newStringNote = scaleComponentsArr[1].replacingOccurrences(of: "/", with: "|")
            let soundFileString = "\(instrument)-\(scaleComponentsArr[0])-\(newStringNote)"
            soundFileArr.append(soundFileString)
        }
        if (tempo < 70) {
            2.times {
                soundFileArr.insert(metronomeFile, at: 0)
            }
        } else {
            4.times {
                soundFileArr.insert(metronomeFile, at: 0)
            }
        }
        
        return soundFileArr
    }
    
                        /// SEE IF IT IS USED ANYWHERE
    func getTimer() -> Timer {
        return metronomeTimer ?? Timer.init()
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
        if let droneURL = Bundle.main.url(forResource: metronomeFile, withExtension: "mp3") {
            player2 = try! AVAudioPlayer(contentsOf: droneURL)
            player2?.play()
        }
    }
    
    mutating func cancelPreviousTimer() {
        metronomeTimer?.invalidate()
        self.metronomeTimer = nil
    }
    
    func cancelDroneSound() {
        self.player?.stop()
    }
    
    mutating func cancelAllSounds() {
        Sound.enabled = false
        cancelPreviousTimer()
        cancelDroneSound()
    }
    
    func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
