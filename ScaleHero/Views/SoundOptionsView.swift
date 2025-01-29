//
//  SoundOptionsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 5/7/2022.
//

import SwiftUI

struct SoundOptionsView: View {
    @Binding var screenType: ScreenType
    @EnvironmentObject var scaleOptions: NoteOptions
    @State private var isPlaying = false
    @State private var presentAlert = false
    @State var playScale = PlaySounds()
    @EnvironmentObject var musicNotes: MusicNotes
    var fileReaderAndWriter = FileReaderAndWriter()
    @State private var presentIntervalHint = false
    @State private var intervalDisabled = false
    
    var backgroundImage: String
    
    var body: some View {
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 19
            let mainMenuButtonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            let title = "\(musicNotes.tonicNote) \(musicNotes.tonality.name)"
            let advice = Text("The Number of Octaves must be One and the Starting Octave must be Two to perform a scale with intervals")
            
            VStack {
                
                Text(title).asTitle()
                
                ScrollView {
                    Group {
                        Divider().background(Color.white)
                        HStack {
                            
                            Button {
                                musicNotes.playDrone.toggle()
                            } label: {
                                if (musicNotes.playDrone) {
                                    MainUIButton(buttonText: "Drone SystemImage checkmark.square", type: 6, height: buttonHeight, buttonWidth: width)
                                } else {
                                    MainUIButton(buttonText: "Drone SystemImage square", type: 6, height: buttonHeight, buttonWidth: width)
                                }
                            }
                            
                            Button {
                                musicNotes.playScaleNotes.toggle()
                            } label: {
                                if (musicNotes.playScaleNotes) {
                                    MainUIButton(buttonText: "Play Notes SystemImage checkmark.square", type: 5, height: buttonHeight, buttonWidth: width)
                                } else {
                                    MainUIButton(buttonText: "Play Notes SystemImage square", type: 5, height: buttonHeight, buttonWidth: width)
                                }
                            }
                        }
                        
                        HStack {
                            Button {
                                musicNotes.metronome.toggle()
                            } label: {
                                if (musicNotes.metronome) {
                                    MainUIButton(buttonText: "Metronome SystemImage checkmark.square", type: 6, height: buttonHeight, buttonWidth: width)
                                } else {
                                    MainUIButton(buttonText: "Metronome SystemImage square", type: 6, height: buttonHeight, buttonWidth: width)
                                }
                            }
                            
                            Button {
                                musicNotes.repeatNotes.toggle()
                            } label: {
                                if (musicNotes.repeatNotes) {
                                    MainUIButton(buttonText: "Repeat Notes SystemImage checkmark.square", type: 5, height: buttonHeight, buttonWidth: width)
                                } else {
                                    MainUIButton(buttonText: "Repeat Notes SystemImage square", type: 5, height: buttonHeight, buttonWidth: width)
                                }
                            }
                        }
                        Button {
                            musicNotes.endlessLoop.toggle()
                        } label: {
                            if (musicNotes.endlessLoop) {
                                MainUIButton(buttonText: "Endless Loop SystemImage checkmark.square", type: 1, height: buttonHeight, buttonWidth: width)
                            } else {
                                MainUIButton(buttonText: "Endless Loop SystemImage square", type: 1, height: buttonHeight, buttonWidth: width)
                            }
                        }
                    }
                    
                    if musicNotes.tonality.hasSolFa {
                        Divider().background(Color.white)
                        Group {
                            MainUIButton(buttonText: "Image Display Type", type: 4, height: buttonHeight, buttonWidth: width)
                            ZStack {
                                MainUIButton(buttonText: "", type: 7, height: buttonHeight, buttonWidth: width)
                                Section {
                                    Picker("Display Image options", selection: $musicNotes.displayType) {
                                        Text("Notes").tag(DisplayType.notes)
                                        Text("Sol-Fa").tag(DisplayType.solFa)
                                        Text("Numbers").tag(DisplayType.numbers)
                                    }
                                    .formatted(width: width)
                                }
                            }
                        }
                    }
                    
                    Divider().background(Color.white)
                    
                    Group {
                        MainUIButton(buttonText: "Repeat Tonics", type: 4, height: buttonHeight, buttonWidth: width) // Make a new UI button colour for the ones pickers are on
                        ZStack {
                            MainUIButton(buttonText: "", type: 7, height: buttonHeight, buttonWidth: width)
                            Section {
                                Picker("Tonic selection", selection: $musicNotes.tonicMode) {
                                    Text("Never").tag(TonicOption.noRepeatedTonic)
                                    Text("All").tag(TonicOption.repeatedTonicAll)
                                    Text("Not Initial").tag(TonicOption.repeatedTonic)
                                }
                                .formatted(width: width)
                            }
                        }
                    }
                    
                    intervalOptonsButtons(buttonHeight: buttonHeight, width: width)
                    
                    Spacer()
                }
                
                Button {
                    self.screenType = .soundview
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: mainMenuButtonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
            .alert(isPresented: $presentIntervalHint) {
                Alert(
                    title: Text("Selecting Interval Option"),
                    message: advice,
                    primaryButton: .default(Text("Set"), action: {
                        
                        musicNotes.octaves = .one
                        musicNotes.startingOctave = .two
                    }),
                    secondaryButton: .cancel(Text("Cancel"), action: {
                        musicNotes.intervalOption = .none
                        intervalDisabled = true
                    })
                );
            }
        }
    }
    
    @ViewBuilder func intervalOptonsButtons(buttonHeight: CGFloat, width: CGFloat) -> some View {
        var intervalsVerify = (musicNotes.intervalOption == .none) ? true : false
        
        Divider().background(Color.white)
        
        Group {
            MainUIButton(buttonText: "Interval Options", type: 4, height: buttonHeight, buttonWidth: width) // Make a new UI button colour for the ones pickers are on
            ZStack {
                MainUIButton(buttonText: "", type: 7, height: buttonHeight, buttonWidth: width)
                Section {
                    Picker("Interval Selections", selection: $musicNotes.intervalOption) {
                        Text("None").tag(Interval.none)
                        Text("Thirds").tag(Interval.thirds)
                        Text("Fourths").tag(Interval.fourths)
                        Text("Fifths").tag(Interval.fifths)
                    }
                    .formatted(width: width)
                    .disabled(intervalDisabled)
                }
                .onChange(of: musicNotes.intervalOption) { intOpt in
                    if (musicNotes.octaves != .one || musicNotes.startingOctave != .two) {
                        presentIntervalHint = true
                    }
                    if (intOpt != .none) {
                        intervalsVerify = false
                    }
                }
            }
        }
        
        Divider().background(Color.white)
        
        Group {
            MainUIButton(buttonText: "Interval Type", type: 4, height: buttonHeight, buttonWidth: width) // Make a new UI button colour for the ones pickers are on
            ZStack {
                MainUIButton(buttonText: "", type: 7, height: buttonHeight, buttonWidth: width)
                Section {
                    Picker("Interval Selections", selection: $musicNotes.intervalType) {
                        Text("All Up").tag(IntervalOption.allUp)
                        Text("All Down").tag(IntervalOption.allDown)
                        Text("One Up One Down").tag(IntervalOption.oneUpOneDown)
                        Text("One Down One Up").tag(IntervalOption.oneDownOneUp)
                    }
                    .formatted(width: width)
                    .disabled(intervalsVerify)
                }
                .onChange(of: musicNotes.intervalOption) { opt in
                    if (opt == .none) {
                        intervalsVerify = true
                    }
                }
            }
        }
    }
}
