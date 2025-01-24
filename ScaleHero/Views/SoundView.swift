//
//  SoundView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 16/12/21.
//

import SwiftUI

struct SoundView : View {
    private let universalSize = UIScreen.main.bounds
    
    enum AlertType: Identifiable {
        case saveToFav
        case octaveSelection
        
        var id: String {
            switch self {
            case .saveToFav:
                return "Save to Favorites"
            case .octaveSelection:
                return "Octave Selection"
            }
        }
    }
    
    @Binding var screenType: ScreenType
    @EnvironmentObject var scaleOptions: NoteOptions
    @State private var isPlaying = false
    @State private var currentAlert: AlertType?
    @State private var lastTapTime = Date()
    @State var playSounds = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    var fileReaderAndWriter = FileReaderAndWriter()
    var musicArray: MusicArray
    var backgroundImage: String
    
    let doubleTapThreshold: TimeInterval = 0.5
    
    init(screenType: Binding<ScreenType>, backgroundImage: String, tonicNote: Notes, noteCase: Case) {
        _screenType = screenType
        self.backgroundImage = backgroundImage
        
        do {
            switch noteCase {
            case .arpeggio(let tonality):
                guard let arpeggioConstructor = try? ArpeggioConstructor(startingNote: tonicNote, tonality: tonality) else {
                    fatalError("Failed to initialize ArpeggioConstructor")
                }
                guard let noteNames = arpeggioConstructor.musicArray else {
                    fatalError("ArpeggioConstructor did not return valid note names")
                }
                self.musicArray = noteNames
            case .scale(let tonality):
                guard let scaleConstructor = try? ScaleConstructor(startingNote: tonicNote, tonality: tonality) else {
                    fatalError("Failed to initialize ScaleConstructor")
                }
                guard let noteNames = scaleConstructor.musicArray else {
                    fatalError("ScaleConstructor did not return valid note names")
                }
                self.musicArray = noteNames
            case .unselected:
                fatalError("The tonality wasn't selected as scale or arpeggio. I need to make this error a UI thing")
            }
        }
    }
    
    var body: some View {
        let title = "\(musicNotes.tonicNote.readableString) \(musicNotes.tonality.name)"
        let buttonHeight = universalSize.height/19
        let bottumButtonHeight = universalSize.height/10
        let maxFavourites = 7

        VStack {
            
            Text(title).asTitle()
            
            ScrollView {
                
                Group {
                    MainUIButton(buttonText: "Number of Octaves:", type: 4, height: buttonHeight)
                    octavePickerView(title: "Octave Selection", selectedOctave: $musicNotes.octaves, buttonHeight: buttonHeight, onChange: handleOctaveChange)
                    Divider().background(Color.white)
                    
                    MainUIButton(buttonText: "Starting Octave:", type: 4, height: buttonHeight)
                    octavePickerView(title: "Starting Octave", selectedOctave: $musicNotes.startingOctave, buttonHeight: buttonHeight, onChange: handleStartingOctaveChange)
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
//                    presentSaveToFavAlert = true
                    currentAlert = .saveToFav
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
        .alert(item: $currentAlert) { alertType in
            switch alertType {
            case .saveToFav:
                favourtiesPageAlertPopUp(noteTitle: title, maxFavourites: maxFavourites)
            case .octaveSelection:
                octaveAlertPopUp()
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .fullScreenCover(isPresented: $isPlaying) {
            self.musicArray.applyModifications(musicNotes: musicNotes)
            let countInBeats = CountInBeats(numBeats: playSounds.retrieveMetronomeCountInLength(for: Int(musicNotes.tempo)))
            
            return PlayingView(backgroundImage: backgroundImage,
                        playScaleNotes: musicNotes.playScaleNotes,
                        playDrone: musicNotes.playDrone,
                        countInBeats: countInBeats,
                        title: title,
                        tonicFileNote: musicArray.getTransposedStartingNote(),
                        repeatingEndlessly: musicNotes.endlessLoop,
                        pitches: musicArray.getPitches(),
                        filePitches: musicArray.constructTransposedSoundFileArray())
        }
    }
    
    private func favourtiesPageAlertPopUp(noteTitle: String, maxFavourites: Int) -> Alert {
        Alert(
            title: Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save To Favourites": " You have too many favourites. Delete One First"),
            message: Text(noteTitle),
            primaryButton: .default(Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save": "Go to favourites Page"), action: {
                
                if (fileReaderAndWriter.scales.count < maxFavourites) {
                    
                    fileReaderAndWriter.add(tonality: musicNotes.tonality,
                                            tempo: Int(musicNotes.tempo),
                                            startingOctave: musicNotes.startingOctave,
                                            numOctave: musicNotes.octaves,
                                            tonicSelection: musicNotes.tonicMode,
                                            scaleNotes: musicNotes.playScaleNotes,
                                            drone: musicNotes.playDrone,
                                            startingNote: musicNotes.tonicNote.name,
                                            noteDisplay: musicNotes.noteDisplay,
                                            endlessLoop: musicNotes.endlessLoop,
                                            intervalType: musicNotes.intervalType,
                                            intervalOption: musicNotes.intervalOption)
                
                }
                self.screenType = .favouritesview
            }),
            secondaryButton: .cancel(Text("Cancel"), action: { /* Do nothing */ })
        )
    }
    
    private func octaveAlertPopUp() -> Alert {
        Alert(title: Text("Octave Selection"),
              message: Text("To select a starting octave of 'two', you can only play up to two octaves. " +
                            "To select a starting octave of 'three', you can only play one octave. Please adjust your selections accordingly."),
              dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder func playButton(buttonHeight: CGFloat) -> some View {
        Button {
            // TODO: Move this elsewhere. WHAT IS THIS EVEn DOING.
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
    
    private func octavePickerView(title: String, selectedOctave: Binding<OctaveNumber>, buttonHeight: CGFloat, onChange: @escaping (OctaveNumber) -> Void) -> some View {
        ZStack {
            MainUIButton(buttonText: "", type: 7, height: buttonHeight)
            Section {
                Picker(title, selection: selectedOctave) {
                    Text("1").tag(OctaveNumber.one)
                    Text("2").tag(OctaveNumber.two)
                    Text("3").tag(OctaveNumber.three)
                }
                .formatted()
            }
        }
        .onChange(of: selectedOctave.wrappedValue) { octave in
            onChange(octave)
        }
    }

    private func handleOctaveChange(_ octave: OctaveNumber) {
        if octave != .one {
            musicNotes.intervalType = .allUp
            musicNotes.intervalOption = .none
        }

        if octave == .two {
            if musicNotes.startingOctave == .three {
                musicNotes.startingOctave = .two
            }
        } else if octave == .three {
            if musicNotes.startingOctave != .one {
                musicNotes.startingOctave = .one
            }
        }
    }

    func handleStartingOctaveChange(_ octave: OctaveNumber) {
        if octave != .two {
            musicNotes.intervalType = .allUp
            musicNotes.intervalOption = .none
        }

        if musicNotes.octaves == .three {
            if octave != .one {
                musicNotes.startingOctave = .one
                if detectDoubleTap() {
                    currentAlert = .octaveSelection
                }
            }
        }

        if musicNotes.octaves == .two {
            if octave == .three {
                musicNotes.startingOctave = .two
                if detectDoubleTap() {
                    currentAlert = .octaveSelection
                }
            }
        }
    }
    
    // TODO: Move elsewhere - bad cohesion atm
    private func detectDoubleTap() -> Bool {
        let currentTime = Date()
        if currentTime.timeIntervalSince(lastTapTime) < doubleTapThreshold {
            return true
        }
        lastTapTime = currentTime
        return false
    }
}
