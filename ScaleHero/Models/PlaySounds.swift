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
    
//    lazy var majorPattern : [Int] = {
//        [self] in
//        switch self.style {
//        case "arpeggio":
//            return [4, 3, 5]
//        case "scale":
//            return [2, 2, 1, 2, 2, 2, 1]
//        default:
//            return[-1]
//        }
//    }()
    var fileReaderAndWriter = FileReaderAndWriter()
    
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
        let delay = tempoToSeconds(tempo: CGFloat(temp))
        let soundFileArr = convertToSoundFile(scaleInfoArr: scaleInfoArra)
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { timer in
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
    
    func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
