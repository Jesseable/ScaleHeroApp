//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
import AVFoundation

struct PlayingView: View { /// LOOK INTO HOW TO DELAY CODE TO COMPLETE FUNCTIONS BEFORE CONTINUEING
    @EnvironmentObject var musicNotes: MusicNotes
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var backgroundImage : String
    let playScaleNotes : Bool
    let playDrone : Bool
    @State var playSounds : PlaySounds
    let title: String
    @State var currentNote: String
    @State var index = 0
    @State var isPlaying = false
    @State var firstTime = true
    @State var delay : CGFloat?
    private let universalSize = UIScreen.main.bounds
    @State var firstNoteDisplay = true
    @State var num = 0
    @State var repeatingEndlessly : Bool // Chnage to a variable
    
    var body: some View {
        let buttonHeight = universalSize.height/10

        VStack {
            Text(title) // TO BE CHANGED SOMEWHERE
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
            
            Spacer()

            Image(currentNote).resizable()
            
            Spacer()
            
            Button {
                playSounds.cancelAllSounds()
                musicNotes.timer.upstream.connect().cancel()
                presentationMode.wrappedValue.dismiss()
                musicNotes.dismissable = false
                UIApplication.shared.isIdleTimerDisabled = false
            } label: {
                MainUIButton(buttonText: "Stop", type: 3, height: buttonHeight)
            }
        }
        .onAppear(perform: {
            // So the screen will never turn off when on this setting
            UIApplication.shared.isIdleTimerDisabled = true
            
            // Allows sound to play when ringer is on silent
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            // maybe move all of this into SoundView to free up space at the start
            if (playDrone) {
                let extraDuration : Int
                if musicNotes.tempo >= 80 {
                    extraDuration = 2
                } else {
                    extraDuration = 1
                }
                
                let duration = (tempoToSeconds(tempo: self.musicNotes.tempo)
                                * CGFloat(self.musicNotes.scaleNotes.count + extraDuration))
                // Transposes just the drone note
                let transposedNoteName = playSounds.getTransposedNote(selectedNote: musicNotes.tonicNote)
                
                if (!repeatingEndlessly) {
                    playSounds.playDroneSound(duration: duration,
                                          startingNote: transposedNoteName)
                } else {
                    playSounds.playDroneSound(duration: -1,
                                          startingNote: transposedNoteName)
                }
            }
        })
        .onReceive(musicNotes.timer) { time in
            if (num % musicNotes.metronomePulse != 0 && musicNotes.metronome) {
                do {
                    try playSounds.playOffbeatMetronome()
                } catch {
                    print("File Error When reading off beat metronome")
                }
            
            } else {
                
                // Metronome sound
                if musicNotes.metronome {
                    do {
                        try playSounds.playMetronome()
                    } catch {
                        print("File Error When reading metronome")
                    }
                }
                currentNote = musicNotes.scaleNoteNames[self.index]
                
                // Allows sound to play when ringer is on silent
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                
                // plays the next note
                if (playScaleNotes) {
                    if !musicNotes.scaleNotes[index].contains("Metronome") {
                        do {
                            let finalNote : Bool
                            if (index == musicNotes.scaleNotes.count - 1) {
                                finalNote = true
                                /// MUST CLEAN LATER
                                DispatchQueue.global(qos: .utility).async {
                                    var achievementsData = fileReaderAndWriter.readScaleAchievements()
                                    var acheivementsArr = achievementsData.components(separatedBy: ":")
                                    acheivementsArr[0] = "\((Int(acheivementsArr[0]) ?? -2) + 1)"
                                    acheivementsArr[1] = "\((Int(acheivementsArr[1]) ?? -2) + 1)"
                                    acheivementsArr[2] = "\((Int(acheivementsArr[2]) ?? -2) + 1)"
                                    acheivementsArr[3] = "\((Int(acheivementsArr[3]) ?? -2) + 1)"
                                    achievementsData = "\(acheivementsArr[0]):\(acheivementsArr[1]):\(acheivementsArr[2]):\(acheivementsArr[3])"
                                                     + ":\(acheivementsArr[4]):\(acheivementsArr[5]):\(acheivementsArr[6])"
                                    fileReaderAndWriter.writeScaleAchievements(newData: achievementsData)
                                }
                                /// TO BE CLEANED ABOVE
                            } else {
                                finalNote = false
                            }
                            try playSounds.playScaleNote(scaleFileName: musicNotes.scaleNotes[index], duration: tempoToSeconds(tempo: self.musicNotes.tempo), finalNote: finalNote)
                        } catch {
                            print("File Error When attempting to play scale Notes")
                        }
                    }
                }
                
                if (index == musicNotes.scaleNotes.count - 1) {
                    if !self.repeatingEndlessly {
                        terminateScale()
                    } else {
                        self.index = -1 // Since it will have one added in a second
                    }
                }
                self.index += 1
            }
            num += 1
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
    
    /**
     Repeats the scale
     */
    private func terminateScale() {
        musicNotes.timer.upstream.connect().cancel()
        
        // Add in a short delay before this is called  You will have to debug this thouroughly
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if musicNotes.dismissable {
                presentationMode.wrappedValue.dismiss()
                AppStoreReviewManager.requestReviewIfAppropriate()
            }
        }
    }
    
    /**
     Chooses sharps or flats option. 0 sharps, 1 flats
     */
    private func sharpOrFlat(for note: String, on selection: [String]) -> Int {
        if (selection.contains(note)) {
            return 1
        }
        return 0
    }
    
    /**
     Returns the number of seconds a note lasts for
     */
    private func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
