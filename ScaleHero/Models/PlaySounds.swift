//
//  PlayScales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 24/12/21.
//

import SwiftUI
import SwiftySound

/**
 Play the sound files in various patterns to produce scales
 */
struct PlaySounds {
    
    lazy var instrument: String = {
        // change to allowing other instrument types once settings menu is up and running
        return "JTest"
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
    
    mutating func playSounds(temp: Int, scaleInfoArra: [String]) {
        var delay = tempoToSeconds(tempo: CGFloat(temp))
        let delayMultiplier = delay
        let soundFileArr = convertToSoundFile(scaleInfoArr: scaleInfoArra)
        
        for fileName in soundFileArr {
            addDelay(fileName: fileName, delay: delay, delayMultiplier: delayMultiplier)
            delay += delayMultiplier
        }
    }
    
    func addDelay(fileName: String, delay: CGFloat, delayMultiplier: CGFloat) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            Sound.play(file: fileName, fileExtension: "mp3")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (1.0 * (delayMultiplier * 1.1 + delay))) {
            Sound.stop(file: fileName, fileExtension: "mp3")
        }
    }
    
    func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
