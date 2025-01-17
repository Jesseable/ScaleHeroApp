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
    @EnvironmentObject var scaleOptions: NoteOptions
    @State private var isPlaying = false
    @State private var presentAlert = false
    //@State private var disableOctaveSelection = false
    //@State private var disableOctaveWithIntervals = false
    @State var playScale = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    var fileReaderAndWriter = FileReaderAndWriter()
    var musicArray: MusicArray
    var backgroundImage: String
    
    init(screenType: Binding<ScreenType>, backgroundImage: String, tonicNoteString: String, noteCase: Case) {
        _screenType = screenType
        self.backgroundImage = backgroundImage
        
        let tonicNote = Notes(noteName: tonicNoteString)
        do {
            switch noteCase {
            case .arpeggio(let tonality):
                guard let arpeggioConstructor = try? ArpeggioConstructor(startingNote: tonicNote!, tonality: tonality) else {
                    fatalError("Failed to initialize ArpeggioConstructor")
                }
                guard let noteNames = arpeggioConstructor.noteNames else {
                    fatalError("ArpeggioConstructor did not return valid note names")
                }
                self.musicArray = noteNames
            case .scale(let tonality):
                guard let scaleConstructor = try? ScaleConstructor(startingNote: tonicNote!, tonality: tonality) else {
                    fatalError("Failed to initialize ScaleConstructor")
                }
                guard let noteNames = scaleConstructor.noteNames else {
                    fatalError("ScaleConstructor did not return valid note names")
                }
                self.musicArray = noteNames
            case .unselected:
                fatalError("The tonality wasn't selected as scale or arpeggio. I need to make this error a UI thing")
            }
        }
    }
    
    var body: some View { // TODO: This just needs to be made smaller
        let title = "\(musicNotes.tonicNote) \(musicNotes.tonality.name)"
        let buttonHeight = universalSize.height/19
        let bottumButtonHeight = universalSize.height/10
        let maxFavourites = 7
        var disableOctaveSelection = (musicNotes.octaves.rawValue < 2) ? false : true

        VStack {
            
            Text(title).asTitle()
            
            ScrollView {
                
                Group {
                    MainUIButton(buttonText: "Number of Octaves:", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("Octave selection", selection: $musicNotes.octaves) {
                                Text("1").tag(OctaveNumber.one)
                                Text("2").tag(OctaveNumber.two)
                                Text("3").tag(OctaveNumber.three)
                            }
                        }
                    }.onChange(of: musicNotes.octaves) { octave in
                        if octave == .one {
                            disableOctaveSelection = false
                        } else {
                            musicNotes.intervalType = .allUp
                            musicNotes.intervalOption = .none
                        }
                        if octave.rawValue > 1 {
                            musicNotes.startingOctave = .one
                            disableOctaveSelection = true
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    MainUIButton(buttonText: "Starting Octave:", type: 4, height: buttonHeight)
                    ZStack {
                        MainUIButton(buttonText: "", type: 7, height: buttonHeight)
                        Section {
                            Picker("Starting Octave", selection: $musicNotes.startingOctave) {
                                Text("1").tag(OctaveNumber.one)
                                Text("2").tag(OctaveNumber.two)
                                Text("3").tag(OctaveNumber.three)
                            }
                            .disabled(disableOctaveSelection)
                        }
                    }.onChange(of: musicNotes.startingOctave) { strOct in
                        if strOct != .two {
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
                        
                        fileReaderAndWriter.add(tonality: musicNotes.tonality,
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
            DispatchQueue.global(qos: .utility).async {
                musicArray.applyModifications(musicNotes: musicNotes)
            }
            
            // TODO: Move this elsewhere
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
    private func fetchScaleNotesArrayData() { // TODO: Have a sound Model that takes in the musicNotes and does everything it needs with it.
//        DispatchQueue.global(qos: .utility).async {
//            var noteNamesArray : [String]
//            var soundFileArray : [String]
//            let start = 0
//
//            // TODO: This should all be moved into 'CREATE_SCALE' constructor.
//            let writeScale = WriteScales(scaleOptions: scaleOptions)
//            let baseScale = writeScale.returnScaleNotesArray(for: musicNotes.tonality, startingAt: musicNotes.tonicNote)
//
//            switch musicNotes.tonality {
//            case .scale(tonality: let tonality):
//                // TODO: This is pretty much all going to be rewritten
//                noteNamesArray = [] // writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
//                                                           // tonicOption: musicNotes.tonicMode, scaleType: tonality)
//            default:
//                noteNamesArray = [] // writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
//                                                                //tonicOption: musicNotes.tonicMode)
//            }
//            // transpose if needed
//            soundFileArray = transposeNotes(for: noteNamesArray)
//            
//            soundFileArray = writeScale.createScaleInfoArray(scaleArray: soundFileArray,
//                                                         initialOctave: musicNotes.startingOctave)
//            
//            if (musicNotes.intervalOption != .none) {
//                soundFileArray = writeScale.convertToIntervals(of: musicNotes.intervalOption,
//                                                           with: musicNotes.intervalType,
//                                                           for: soundFileArray)
//                noteNamesArray = writeScale.convertToIntervals(of: musicNotes.intervalOption,
//                                                           with: musicNotes.intervalType,
//                                                           for: noteNamesArray, withoutOctave: true)
//            }
//            
//            soundFileArray = playScale.convertToSoundFile(scaleInfoArray: soundFileArray, tempo: Int(musicNotes.tempo))
//            
//            if (musicNotes.repeatNotes) {
//                soundFileArray = writeScale.repeatAllNotes(in: soundFileArray)
//                noteNamesArray = writeScale.repeatAllNotes(in: noteNamesArray)
//            }
//            
//   TODO: These two lines are more important         let metronomeBeats = playScale.addMetronomeCountIn(tempo: Int(musicNotes.tempo), scaleNotesArray: noteNamesArray)
//            noteNamesArray.insert(contentsOf: metronomeBeats, at: start)
//
//            DispatchQueue.main.async {
//                musicNotes.scaleNotes = soundFileArray
//                musicNotes.scaleNoteNames = noteNamesArray
//            }
//        }
    }
    
    // TODO: Move into the NoteConstructorAbstract. This isn't view behaviour
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
