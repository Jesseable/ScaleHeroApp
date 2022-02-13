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
    
    @Binding var screenType: String
    var backgroundImage: String
    @State private var isPresented = false
    @State private var deletionMode = false
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var body: some View {
        let buttonHeight = universalSize.height/10
        let menuButtonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                Text("Favourites")
                            .font(.largeTitle.bold())
                            .accessibilityAddTraits(.isHeader)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                
                ScrollView {
                    
                    ForEach(fileReaderAndWriter.scales) { scale in
                        Button {
                            if (deletionMode) {
                                withAnimation {
                                    fileReaderAndWriter.delete(scale)
                                    deletionMode.toggle()
                                }
                            } else {
                                musicNotes.isFavouriteScale = true
                                musicNotes.tonality = scale.tonality
                                musicNotes.type = scale.type
                                musicNotes.tempo = CGFloat(scale.tempo)
                                musicNotes.startingOctave = scale.startingOctave
                                musicNotes.octaves = scale.numOctave
                                musicNotes.tonicis = scale.tonicSelection
                                musicNotes.playDrone = scale.drone
                                musicNotes.playScaleNotes = scale.scaleNotes
                                musicNotes.noteName = scale.startingNote
                                musicNotes.noteDisplay = scale.noteDisplay
                                musicNotes.endlessLoop = scale.endlessLoop

                                self.screenType = "soundview"
                            }
                        } label: {
                            ZStack {
                                MainUIButton(buttonText: "", type: deletionMode ? 8: 1, height: buttonHeight)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(scale.scaleInfo)
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
                    self.screenType = "homepage"
                } label: {
                    MainUIButton(buttonText: "Home Page", type: 3, height: menuButtonHeight)
                }
            }
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .fullScreenCover(isPresented: $isPresented) {
            FavouritesInfoView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
    }
}
