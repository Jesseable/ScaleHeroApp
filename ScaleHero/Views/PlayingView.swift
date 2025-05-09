//
//  PlayingView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 4/1/22.
//

import SwiftUI
import AVFoundation

struct CountInBeats {
    private var currentCount: Int
    private let maxCount: Int = 8
    
    init(numBeats: Int) {
        self.currentCount = numBeats
    }
    
    mutating func nextBeat() -> String? {
        guard currentCount > 0 else {
            return nil
        }
        let beat = self.currentCount
        self.currentCount -= 1
        return toString(beat: beat)
    }
    
    private func toString(beat: Int) -> String {
        let englishNames = [
            1: "Metronome_1", 2: "Metronome_2", 3: "Metronome_3", 4: "Metronome_4",
            5: "Metronome_5", 6: "Metronome_6", 7: "Metronome_7", 8: "Metronome_8"
        ]
        return englishNames[beat] ?? "\(beat)"
    }
}

/*
 The view to show the note names when the scale is playing. Also contains functionality to play the scale
 */
struct PlayingView: View {
    @EnvironmentObject var musicNotes: MusicNotes
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var fileReaderAndWriter = FileReaderAndWriter()
    let width: CGFloat
    let height: CGFloat
    var backgroundImage : String
    let playScaleNotes : Bool
    let playDrone : Bool
    @State var playSounds = PlaySounds()
    @State var countInBeats : CountInBeats
    let title: String
    let tonicFileNote: FileNotes 
    @State var index = 0 // TODO: Does this really need to be a state???
    @State var isPlaying = false
    @State var firstTime = true
    @State var delay : CGFloat?
    @State var firstNoteDisplay = true
    @State var num = 0
    @State var repeatingEndlessly : Bool // TODO: Change to a variable
    let pitches: [Pitch]
    let filePitches: [FilePitch]
    let tonicNote: FileNotes
    @State var mainImageName: String?
    var noteConverter: (any NoteMapper)?
    
    var body: some View {
        VStack {
            headerView
            Spacer()
            imageView
            Spacer()
            stopButton
        }
        .onAppear(perform: {
            UIApplication.shared.isIdleTimerDisabled = true // Disable screen turn off due to inactivity while playing notes
            setUpAudioSession()
            playDroneIfNeeded()
        })
        .onReceive(musicNotes.timer) { time in
            handleMetronomeAndNotes()
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
    
    private var headerView: some View {
        Text(title)
            .font(.largeTitle.bold())
            .accessibilityAddTraits(.isHeader)
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
    }
    
    private var imageView: some View {
        if let imageName = mainImageName {
            return AnyView(
                Image(imageName).resizable()
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    private var stopButton: some View {
        Button {
            stopAllSoundsAndDismiss()
        } label: {
            let buttonHeight = height / 10
            MainUIButton(buttonText: "Stop", type: 1, height: buttonHeight, buttonWidth: width * 0.9)
        }
    }
    
    private func stopAllSoundsAndDismiss() {
        playSounds.cancelAllSounds()
        musicNotes.timer.upstream.connect().cancel()
        presentationMode.wrappedValue.dismiss()
        musicNotes.dismissable = false
        UIApplication.shared.isIdleTimerDisabled = false // reenable screen turning off due to inactivity
    }
    
    private func setUpAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    private func playDroneIfNeeded() {
        guard playDrone else { return }
    
        let extraDuration: Int = musicNotes.tempo >= 80 ? 2 : 1
        let duration = (tempoToSeconds(tempo: self.musicNotes.tempo) * CGFloat(self.pitches.count + extraDuration))
        
        if (!repeatingEndlessly) {
            playSounds.playDroneSound(duration: duration,
                                      tonicNote: tonicNote)
        } else {
            playSounds.playDroneSound(duration: -1,
                                      tonicNote: tonicNote)
        }
    }
    
    private func handleMetronomeAndNotes() {
        if (num % musicNotes.metronomePulse != 0) {
            playOffbeatMetronome()
        } else {
            playOnBeatMetronome()
            handleNotesAndImages()
        }
        num += 1
    }
    
    private func playOffbeatMetronome() {
        guard musicNotes.metronome else { return }
        
        do {
            try playSounds.playOffbeatMetronome()
        } catch {
            print("File Error When reading off-beat metronome")
        }
    }
    
    
    private func playOnBeatMetronome() {
        guard musicNotes.metronome else { return }

        do {
            try playSounds.playMetronome()
        } catch {
            print("File Error When reading on-beat metronome")
        }
    }
    
    private func handleNotesAndImages() {
        let currentCountInBeat = countInBeats.nextBeat()
        if let nextBeat = currentCountInBeat {
            self.mainImageName = nextBeat
        } else {
            setMainImageName()
                    
            playNextNoteIfNeeded()
            
            if (index == pitches.count - 1) {
                if !self.repeatingEndlessly {
                    terminate()
                } else {
                    self.index = -1 // reset index
                }
            }
            self.index += 1
        }
    }
    
    private func setMainImageName() {
        let currentNote = pitches[self.index].note
        
        guard let noteMapper = noteConverter else {
            self.mainImageName = currentNote.name
            return
        }
        
        do {
            let displayImage = try noteMapper.getMapping(for: currentNote)
            if let solFaImage = displayImage as? SolFa {
                self.mainImageName = solFaImage.name
            } else if let numbersImage = displayImage as? NumberRepresentation {
                self.mainImageName = numbersImage.name
            } else {
                print("The display image was of a unexpected type '\(type(of: displayImage))'")
                self.mainImageName = currentNote.name
            }
        } catch SolFaNoteMapperError.noteNotFound {
            print("Error mapping the note to a solFa")
            self.mainImageName = currentNote.name
        } catch {
            print("An unexpected error occurred when mapping note to solFa: \(error)")
            self.mainImageName = currentNote.name
        }
    }
    
    private func playNextNoteIfNeeded() {
        guard playScaleNotes else { return }
        
        do {
            let finalNote = (index == pitches.count - 1)
            if finalNote {
                updateAchievmentsPage()
            }
            try playSounds.playScaleNote(
                filePitch: filePitches[index],
                duration: tempoToSeconds(tempo: self.musicNotes.tempo),
                isFinalNote: finalNote
            )
        } catch {
            print("File Error When attempting to play scale Notes")
        }
    }
    
    private func updateAchievmentsPage() {
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
    }
    
    private func terminate() {
        musicNotes.timer.upstream.connect().cancel()
        
        // Add in a short delay before this is called  You will have to debug this thouroughly
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            if musicNotes.dismissable {
                presentationMode.wrappedValue.dismiss()
                AppStoreReviewManager.requestReviewIfAppropriate()
            }
        }
    }
    
    private func tempoToSeconds(tempo: CGFloat) -> CGFloat {
        let noteLength = CGFloat(60/tempo)
        return noteLength
    }
}
