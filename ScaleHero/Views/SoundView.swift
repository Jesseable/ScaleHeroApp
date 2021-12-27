//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI
import SwiftySound

struct SoundView : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @State var scaleType: String
    @State private var isPlaying = false
    @State private var numOctave = 1
    @State private var tempo = 100
    @State private var drone = true
    @State private var chords = false
    @State private var scaleNotes = true
    @EnvironmentObject var musicNotes: MusicNotes
    
    var body: some View {
        
        ZStack {
            Image("music-Copyrighted-exBackground").resizable().ignoresSafeArea()
        
            VStack {
                Text(scaleType).bold().textCase(.uppercase).font(.title).foregroundColor(.white).padding()
                
                Spacer()
                
                Button {
                    let scaleTypeArr = scaleType.components(separatedBy: " ")
                    let startingNote = getStartingNote(scaleTypeArr: scaleTypeArr)
                    let tonality = getScaleTonality(scaleTypeArr: scaleTypeArr).lowercased()
                    let scaleType = getScaleType(scaleTypeArr: scaleTypeArr).lowercased()
                    
                    if (isPlaying) {
                        Sound.stopAll()
                        Sound.enabled = false
                        isPlaying = false
                    } else {
                        Sound.enabled = true
                        var scale = WriteScales(style: scaleType.lowercased())
                        let scaleInfo = scale.ScaleNotes(startingNote: startingNote, octave: 1, tonality: tonality) // Chnage later
                        
                        var playScale = PlaySounds()
                        print(playScale.convertToSoundFile(scaleInfoArr: scaleInfo))
                        playScale.playSounds(temp: self.tempo, scaleInfoArra: scaleInfo)
                        
                        isPlaying = true
                    }
                } label: {
                    HStack {
                        if isPlaying {
                            Text("Stop")
                            Image(systemName: "speaker.slash").foregroundColor(Color.white)
                        } else {
                            Text("Play")
                            Image(systemName: "speaker.wave.3").foregroundColor(Color.white)
                        }
                    }
                }.padding()

                // Ovtaves view
                Menu("Number of Octaves = " + String(numOctave)) {
                    Button("1 octave", action: {numOctave = 1})
                    Button("2 octaves", action: {numOctave = 2})
                    Button("3 octaves", action: {numOctave = 3})
                }.padding()
            
                Menu("Tempo = " + String(tempo)) {
                    ForEach(20..<181) { i in
                        if (i % 10 == 0) {
                            Button("Tempo: " + String(i), action: {tempo = i})
                        }
                    }
                }.padding()
                
                HStack {
                    Spacer()
                    if (drone) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        if (chords) {
                            Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                        } else {
                            Image(systemName: "square").foregroundColor(Color.white)
                        }
                    }
                    Button("Drone") {
                        if (!chords) {
                            drone.toggle()
                        }
                    }
                    Spacer()
                }.padding()
                
                HStack {
                    Spacer()
                    
                    if (chords) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        if (drone) {
                            Image(systemName: "square").foregroundColor(Color.white).blur(radius: 1.5)
                        } else {
                            Image(systemName: "square").foregroundColor(Color.white)
                        }
                    }
                    Button("Chords") {
                        if (!drone) {
                            chords.toggle()
                        }
                    }
                    Spacer()
                }.padding()
                
                HStack {
                    Spacer()
                    
                    if (scaleNotes) {
                        Image(systemName: "checkmark.square").foregroundColor(Color.white)
                    } else {
                        Image(systemName: "square").foregroundColor(Color.white)
                    }
                    Button("Scale Notes") {
                        scaleNotes.toggle()
                    }
                    Spacer()
                }.padding()
                
                
                Spacer()
                Spacer()
            }
        }
    }
    
    func getStartingNote(scaleTypeArr: [String]) -> String {
        
        let startingNote = scaleTypeArr[0]
//
//        switch startingNote {
//        case "A":
//            startingNote = "A"
//        case "A#/Bb":
//            startingNote = "A#/Bb"
//        case "B":
//            startingNote = "B"
//        case "C":
//            startingNote = "C"
//        case "C#/Db":
//            startingNote = "C#/Db"
//        case "D":
//            startingNote = "D"
//        case "D#/Eb":
//            startingNote = "D#/Eb"
//        case "E":
//            startingNote = "E"
//        case "F":
//            startingNote = "F"
//        case "F#/Gb":
//            startingNote = "F#/Gb"
//        case "G":
//            startingNote = "G"
//        case "G#/Ab":
//            startingNote = "G#/Ab"
//        default:
//            print("Starting note did not match the computer sound file")
//        }
        
        return startingNote
    }
    
    func getScaleTonality(scaleTypeArr: [String]) -> String {
        let tonality = scaleTypeArr[1]
        return tonality
    }
    
    func getScaleType(scaleTypeArr: [String]) -> String {
        let type = scaleTypeArr[2]
        return type
    }
}
