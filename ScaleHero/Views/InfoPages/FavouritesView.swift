//
//  FavouritesView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: ScreenType
    var backgroundImage: String
    @State private var isPresented = false
    @State private var deletionMode = false
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        let menuButtonHeight = universalSize.height/10

        VStack {
            
            Text("Favourites").asTitle()
            
            ScrollView {
                
                ForEach(fileReaderAndWriter.scales) { scale in
                    Button {
                        if (deletionMode) {
                            withAnimation {
                                fileReaderAndWriter.delete(scale)
                                deletionMode.toggle()
                            }
                        } else {
                            musicNotes.tonality = scale.tonality
                            musicNotes.tempo = CGFloat(scale.tempo)
                            musicNotes.startingOctave = scale.startingOctave
                            musicNotes.octaves = scale.numOctave
                            musicNotes.tonicMode = scale.tonicSelection
                            musicNotes.playDrone = scale.drone
                            musicNotes.playScaleNotes = scale.scaleNotes
                            musicNotes.tonicNote = scale.startingNote
                            musicNotes.noteDisplay = scale.noteDisplay
                            musicNotes.endlessLoop = scale.endlessLoop

                            musicNotes.backDisplay = .favouritesview
                            self.screenType = .soundview
                        }
                    } label: {
                        ZStack {
                            MainUIButton(buttonText: "", type: deletionMode ? 8: 1, height: buttonHeight)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(scale.startingNote) \(musicNotes.getTonality(from: scale.tonality))")
                                        .font(.headline)
                                        .foregroundColor(Color.white)

                                    Text(String(scale.scaleDescription))
                                        .font(.caption)
                                        .foregroundColor(Color.white)
                                }

                                Spacer()

                                Text("Tempo: \(scale.tempo)")
                                    .foregroundColor(Color.white)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                Button {
                    deletionMode.toggle()
                } label: {
                    MainUIButton(buttonText: "Delete SystemImage trash", type: deletionMode ? 8: 1, height: buttonHeight)
                }

                Button {
                    isPresented = true
                } label: {
                    MainUIButton(buttonText: "Info", type: 1, height: buttonHeight)
                }
            }
            Spacer()
            
            Button {
                musicNotes.backDisplay = .noteSelection
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: menuButtonHeight)
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        .fullScreenCover(isPresented: $isPresented) {
            FavouritesInfoView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
    }
}
