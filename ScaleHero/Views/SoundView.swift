//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI

struct SoundView : View {
    
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: ScreenType
    @EnvironmentObject var scaleOptions: ScaleOptions
    @State private var isPlaying = false
    @State private var presentAlert = false
    //@State private var disableOctaveSelection = false
    //@State private var disableOctaveWithIntervals = false
    @State var playScale = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var backgroundImage: String
    
    var body: some View {
        let title = "\(musicNotes.tonicNote) \(musicNotes.getTonality(from: musicNotes.tonality))"
        let buttonHeight = universalSize.height/19
        let bottumButtonHeight = universalSize.height/10
        let maxFavourites = 7
        var disableOctaveSelection = (musicNotes.octaves < 2) ? false : true

        VStack {
            
            Text(title).asTitle()
            
            ScrollView {
                
                Group {
                    MainUIButton(buttonText: "Number of Octaves:", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("Octave selection", selection: $musicNotes.octaves) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").font(.title).tag(3)
                            }
                            .formatted()
                        }
                    }.onChange(of: musicNotes.octaves) { octave in
                        if (octave == 1) {
                            disableOctaveSelection = false
                        } else {
                            musicNotes.intervalType = .allUp
                            musicNotes.intervalOption = .none
                        }
                        if (octave > 1) {
                            musicNotes.startingOctave = 1
                            disableOctaveSelection = true
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    MainUIButton(buttonText: "Starting Octaves:", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("Octave:", selection: $musicNotes.startingOctave) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                            }
                            .formatted()
                            .disabled(disableOctaveSelection)
                        }
                    }.onChange(of: musicNotes.startingOctave) { strOct in
                        if (strOct != 2) {
                            musicNotes.intervalType = .allUp
                            musicNotes.intervalOption = .none
                        }
                    }
                    
                    Divider().background(Color.white)
            
                    MainUIButton(buttonText: "Tempo = " + String(Int(musicNotes.tempo)), type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Slider(value: $musicNotes.tempo, in: 20...180, step: 1.0)
                            .padding(.horizontal)
                    }
                    
                    Divider().background(Color.white)
                    
                }

                Button {
                    screenType = .soundOptionsView
                } label: {
                    MainUIButton(buttonText: "Further Options", type: 1, height: buttonHeight)
                }
                
                Divider().background(Color.white)
                
                Button {
                    presentAlert = true
                } label: {
                    MainUIButton(buttonText: "Save", type: 1, height: buttonHeight)
                }
                
                Spacer()
            }
            playButton(buttonHeight: buttonHeight).padding(.bottom, 10)
            
            Button {
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: bottumButtonHeight)
            }
        }
        .alert(isPresented: $presentAlert) {
            Alert(
                title: Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save To Favourites": " You have too many favourites. Delete One First"),
                message: Text(title),
                primaryButton: .default(Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save": "Go to favourites Page"), action: {
                    
                    if (fileReaderAndWriter.scales.count < maxFavourites) {
                        
                        fileReaderAndWriter.add(tonality: musicNotes.tonality!,
                                                tempo: Int(musicNotes.tempo),
                                                startingOctave: musicNotes.startingOctave,
                                                numOctave: musicNotes.octaves,
                                                tonicSelection: musicNotes.tonicMode,
                                                scaleNotes: musicNotes.playScaleNotes,
                                                drone: musicNotes.playDrone,
                                                startingNote: musicNotes.tonicNote,
                                                noteDisplay: musicNotes.noteDisplay,
                                                endlessLoop: musicNotes.endlessLoop,
                                                intervalType: musicNotes.intervalType,
                                                intervalOption: musicNotes.intervalOption)
                    
                    }
                    // Goes to the favourites screen
                    self.screenType = .favouritesview
                }),
                secondaryButton: .cancel(Text("Cancel"), action: { /*Do Nothing*/ })
            )
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .fullScreenCover(isPresented: $isPlaying) {
            PlayingView(backgroundImage: backgroundImage,
                        playScaleNotes: musicNotes.playScaleNotes,
                        playDrone: musicNotes.playDrone,
                        playSounds: playScale,
                        title: title,
                        currentNote: musicNotes.tonicNote,
                        repeatingEndlessly: musicNotes.endlessLoop)
        }
    }
    
    @ViewBuilder func playButton(buttonHeight: CGFloat) -> some View {
        Button {

            fetchScaleNotesArrayData()
            
            // Could add in quavers?
            switch fileReaderAndWriter.readMetronomePulse().lowercased() {
            case "simple":
                musicNotes.metronomePulse = 4
            case "compound":
                musicNotes.metronomePulse = 3
            case "off":
                musicNotes.metronomePulse = 1
            default:
                musicNotes.metronomePulse = 1
            }

            // This line of code sets at what tempo when the metronome off beat pulses will not play
            if (musicNotes.tempo >= 70 || !musicNotes.metronome) {
                musicNotes.metronomePulse = 1
            }
            let delay = CGFloat(60/musicNotes.tempo)
            musicNotes.timer = Timer.publish(every: delay/CGFloat(musicNotes.metronomePulse), on: .main, in: .common).autoconnect()

            isPlaying = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                musicNotes.dismissable = true
            }
        } label: {
            MainUIButton(buttonText: "Play SystemImage speaker.wave.3", type: 10, height: buttonHeight*2)
        }
    }
    
    /*
     Retrieves the scale note data
     ----------------
     @param type:
     Returns: a string array containing the notes of the scale to be outputted as sound files
     */
    private func fetchScaleNotesArrayData() {
        DispatchQueue.global(qos: .utility).async {
            var noteNamesArray : [String]
            var soundFileArray : [String]
            let start = 0
            
            let writeScale = WriteScales(scaleOptions: scaleOptions)
            let baseScale = writeScale.returnScaleNotesArray(for: musicNotes.tonality!, startingAt: musicNotes.tonicNote)
            
            switch musicNotes.tonality {
            case .scale(tonality: let tonality):
                noteNamesArray = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
                                                            tonicOption: musicNotes.tonicMode, scaleType: tonality)
            default:
                noteNamesArray = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
                                                                tonicOption: musicNotes.tonicMode)
            }
            // transpose if needed
            soundFileArray = transposeNotes(for: noteNamesArray)
            
            soundFileArray = writeScale.createScaleInfoArray(scaleArray: soundFileArray,
                                                         initialOctave: musicNotes.startingOctave)
            
            if (musicNotes.intervalOption != .none) {
                soundFileArray = writeScale.convertToIntervals(of: musicNotes.intervalOption,
                                                           with: musicNotes.intervalType,
                                                           for: soundFileArray)
                noteNamesArray = writeScale.convertToIntervals(of: musicNotes.intervalOption,
                                                           with: musicNotes.intervalType,
                                                           for: noteNamesArray, withoutOctave: true)
            }
            
            soundFileArray = playScale.convertToSoundFile(scaleInfoArray: soundFileArray, tempo: Int(musicNotes.tempo))
            
            if (musicNotes.repeatNotes) {
                soundFileArray = writeScale.repeatAllNotes(in: soundFileArray)
                noteNamesArray = writeScale.repeatAllNotes(in: noteNamesArray)
            }
            
            let metronomeBeats = playScale.addMetronomeCountIn(tempo: Int(musicNotes.tempo), scaleNotesArray: noteNamesArray)
            noteNamesArray.insert(contentsOf: metronomeBeats, at: start)

            DispatchQueue.main.async {
                musicNotes.scaleNotes = soundFileArray
                musicNotes.scaleNoteNames = noteNamesArray
            }
        }
    }
    
    
    private func transposeNotes(for notesArray: [String]) -> [String] {
        var transposedNotes = notesArray
        // add transposition here if needed
        var itr = 0
        for scaleNote in transposedNotes {
            let transposedNoteName = playScale.getTransposedNote(selectedNote: scaleNote)
            transposedNotes[itr] = transposedNoteName
            itr += 1
        }
        return transposedNotes
    }
}
