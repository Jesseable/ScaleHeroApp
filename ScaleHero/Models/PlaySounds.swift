//
//  PlayScales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/21.
//

import SwiftUI
import SwiftySound
import AVFoundation

/**
 Play the sound files in various patterns to produce scales
 */
struct PlaySounds {
    
    var fileReaderAndWriter = FileReaderAndWriter()
    var scaleTimer: Timer? = nil
    var player: AVAudioPlayer?
    
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
    mutating func convertToSoundFile(scaleInfoArr: [String]) -> [String] {
        var soundFileArr: [String] = []
        
        for scaleNote in scaleInfoArr {
            let scaleComponentsArr = scaleNote.components(separatedBy: ":")
            let newStringNote = scaleComponentsArr[1].replacingOccurrences(of: "/", with: "|")
            let soundFileString = "\(instrument)-\(scaleComponentsArr[0])-\(newStringNote)"
            soundFileArr.append(soundFileString)
        }
        return soundFileArr
    }
    
    // Return a possible time function for the scale to know when to switch stop back to play
    mutating func playScaleSounds(temp: Int, scaleInfoArra: [String]) {
        let delay = tempoToSeconds(tempo: CGFloat(temp))
        let soundFileArr = convertToSoundFile(scaleInfoArr: scaleInfoArra)
        var index = 0
        
        scaleTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
            // stop the previous sound
            if (index != 0) {
                Sound.stop(file: soundFileArr[index-1], fileExtension: "mp3")
            }
            // play the next note
            Sound.play(file: soundFileArr[index], fileExtension: "mp3")
            index += 1
            if (index == soundFileArr.count) {
                timer.invalidate()
            }
        }
    }
    
    mutating func playDroneSound(duration: CGFloat, startingNote: String) {
        let startingFileNote = startingNote.replacingOccurrences(of: "/", with: "|")
        let droneSoundFile = "\(drone)-Drone-\(startingFileNote)"
        //ar player: AVAudioPlayer!
        
        if let droneURL = Bundle.main.url(forResource: droneSoundFile, withExtension: "mp3") {
            self.player = try! AVAudioPlayer(contentsOf: droneURL)
            self.player?.play()
            
            let totalDuration = duration + 2.5
                
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: { [self] in
                self.player?.setVolume(0.05, fadeDuration: 2.5)
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration, execute: { [self] in
                self.player?.stop()
            })
        }
    }
    
    mutating func cancelPreviousTimer() {
        scaleTimer?.invalidate()
        self.scaleTimer = nil
    }
    
    func cancelDroneSound() {
        self.player?.stop()
    }
    
    mutating func cancelAllSounds() {
        cancelPreviousTimer()
        cancelDroneSound()
    }
    
    func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
