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
        let title = "\(musicNotes.noteName) \(musicNotes.getTonality(from: musicNotes.tonality))"
        let buttonHeight = universalSize.height/19
        let bottumButtonHeight = universalSize.height/10
        let maxFavourites = 7
        var disableOctaveSelection = (musicNotes.octaves < 2) ? false : true


        VStack {
            
            Text(title).asTitle()
            
            Button {
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 9, height: bottumButtonHeight)
            }
            ScrollView {

                Divider().background(Color.white)
                
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
                    }.onChange(of: musicNotes.octaves) { octave in
                        if (octave > 1) {
                            musicNotes.startingOctave = 1
                            disableOctaveSelection = true
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
            playButton(buttonHeight: buttonHeight)
        }
        .alert(isPresented: $presentAlert) {
            Alert(
                title: Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save To Favourites": " You have too many favourites. Delete One First"),
                message: Text(title),
                primaryButton: .default(Text((fileReaderAndWriter.scales.count < maxFavourites) ? "Save": "Go to favourites Page"), action: {
                    
                    if (fileReaderAndWriter.scales.count < maxFavourites) {
                        
                        fileReaderAndWriter.add(scaleInfo: "IS THIS NEEDED: POSSIBLY DELETE",
                                                tonality: musicNotes.tonality!,
                                                tempo: Int(musicNotes.tempo),
                                                startingOctave: musicNotes.startingOctave,
                                                numOctave: musicNotes.octaves,
                                                tonicSelection: musicNotes.tonicMode,
                                                scaleNotes: musicNotes.playScaleNotes,
                                                drone: musicNotes.playDrone,
                                                startingNote: musicNotes.noteName,
                                                noteDisplay: musicNotes.noteDisplay,
                                                endlessLoop: musicNotes.endlessLoop)
                    
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
                        currentNote: musicNotes.noteName,
                        repeatingEndlessly: musicNotes.endlessLoop)
        }
    }
    
    @ViewBuilder func playButton(buttonHeight: CGFloat) -> some View { // MAYBE A DELAY WHILE DOING THIS CODE BEFORE PLAYING THE SCALES
        Button {
            let startingNote = musicNotes.noteName

            let writeScale = WriteScales(scaleOptions: scaleOptions)
            
            // MAYBE PUT ALL OF THIS TOGETHER
            let baseScale = writeScale.returnScaleNotesArray(for: musicNotes.tonality!, startingAt: startingNote)
            if (baseScale.isEmpty) {
                print("failed due to not being able to read base scale notes from the json file")
                fatalError()
            }
            var notesArray : [String]
            switch musicNotes.tonality {
            case .scale(tonality: let tonality):
                notesArray = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
                                                            tonicOption: musicNotes.tonicMode, scaleType: tonality)
            default:
                notesArray = writeScale.convertToScaleArray(baseScale: baseScale, octavesToPlay: musicNotes.octaves,
                                                                tonicOption: musicNotes.tonicMode)
            }
            
            var soundFileNotesArray = writeScale.createScaleInfoArray(scaleArray: notesArray, initialOctave: musicNotes.startingOctave)
            
            if (musicNotes.intervalOption != .none) {
                soundFileNotesArray = writeScale.convertToIntervals(of: musicNotes.intervalOption, with: musicNotes.intervalType, for: soundFileNotesArray)
                notesArray = writeScale.convertToIntervals(of: musicNotes.intervalOption, with: musicNotes.intervalType, for: notesArray, withoutOctave: true)
            }
            
            let scaleSoundFiles = playScale.convertToSoundFile(scaleInfoArray: soundFileNotesArray, tempo: Int(musicNotes.tempo))
            let delay = CGFloat(60/musicNotes.tempo)
            musicNotes.scaleNotes = scaleSoundFiles
            
            if (musicNotes.repeatNotes) {
                musicNotes.scaleNotes = writeScale.repeatAllNotes(in: musicNotes.scaleNotes)
                musicNotes.scaleNoteNames = writeScale.repeatAllNotes(in: musicNotes.scaleNoteNames)
            }
            
            let metronomeBeats = playScale.addMetronomeCountIn(tempo: Int(musicNotes.tempo), scaleNotesArray: notesArray)
            notesArray.insert(contentsOf: metronomeBeats, at: 0) // MAGIC NUMBER
            musicNotes.scaleNoteNames = notesArray

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
            musicNotes.timer = Timer.publish(every: delay/CGFloat(musicNotes.metronomePulse), on: .main, in: .common).autoconnect()
        
            isPlaying = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                musicNotes.dismissable = true
            }
        } label: {
            MainUIButton(buttonText: "Play SystemImage speaker.wave.3", type: 3, height: buttonHeight*2)
        }
    }
}
