//
//  FavouritesView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 22/1/22.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    @Binding var screenType: ScreenType
    var backgroundImage: String
    @State private var isPresented = false
    @State private var deletionMode = false
    var fileReaderAndWriter = FileReaderAndWriter()
    
    var body: some View {
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let menuButtonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
            VStack {
                Text("Favourites").asTitle()
                
                ScrollView {
                    favouriteScalesList(buttonHeight: buttonHeight, width: width)
                    deleteButton(buttonHeight: buttonHeight, width: width)
                    infoButton(buttonHeight: buttonHeight, width: width)
                }
                
                Spacer()
                backButton(buttonHeight: menuButtonHeight, width: width)
            }
            .background(alignment: .center) {
                backgroundImageView
            }
            .fullScreenCover(isPresented: $isPresented) {
                FavouritesInfoView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
            }
        }
    }
    
    private func favouriteScalesList(buttonHeight: CGFloat, width: CGFloat) -> some View {
        ForEach(fileReaderAndWriter.scales) { scale in
            Button {
                handleScaleButtonAction(scale)
            } label: {
                favouriteScaleRow(scale: scale, buttonHeight: buttonHeight, width: width)
            }
        }
    }
    
    private func handleScaleButtonAction(_ scale: ScaleCharacteristics) {
        if deletionMode {
            withAnimation {
                fileReaderAndWriter.delete(scale)
                deletionMode.toggle()
            }
        } else {
            loadScaleData(scale)
            musicNotes.backDisplay = .favouritesview
            self.screenType = .soundview
        }
    }
    
    private func loadScaleData(_ scale: ScaleCharacteristics) {
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
    }
    
    private func favouriteScaleRow(scale: ScaleCharacteristics, buttonHeight: CGFloat, width: CGFloat) -> some View {
        ZStack {
            MainUIButton(buttonText: "", type: deletionMode ? 8: 1, height: buttonHeight, buttonWidth: width)
            HStack {
                VStack(alignment: .leading) {
                    Text("\(scale.startingNote.readableString) \(musicNotes.tonality.name)")
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
    
    private func deleteButton(buttonHeight: CGFloat, width: CGFloat) -> some View {
        Button {
            deletionMode.toggle()
        } label: {
            MainUIButton(buttonText: "Delete SystemImage trash", type: deletionMode ? 8 : 1, height: buttonHeight, buttonWidth: width)
        }
    }
    
    private func infoButton(buttonHeight: CGFloat, width: CGFloat) -> some View {
        Button {
            isPresented = true
        } label: {
            MainUIButton(buttonText: "Info", type: 1, height: buttonHeight, buttonWidth: width)
        }
    }
    
    private func backButton(buttonHeight: CGFloat, width: CGFloat) -> some View {
        Button {
            musicNotes.backDisplay = .noteSelection
            self.screenType = musicNotes.backDisplay
        } label: {
            MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: width)
        }
    }
    
    private var backgroundImageView: some View {
        Image(backgroundImage)
            .resizable()
            .ignoresSafeArea(.all)
            .scaledToFill()
    }
}
