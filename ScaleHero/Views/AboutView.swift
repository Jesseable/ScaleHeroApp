//
//  AboutView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI
import UIKit

struct AboutView: View {
    private let universalSize = UIScreen.main.bounds
    
    @Binding var screenType: ScreenType
    var backgroundImage: String
    @State private var isPresented1 = false
    @State private var isPresented2 = false
    @State private var isPresented3 = false
    @State private var isSharePresented = false
    var fileReaderAndWriter = FileReaderAndWriter()
    private let productURL = URL(string: "https://itunes.apple.com/app/id958625272")! // DOUBLE CHECK THIS!!!!!!!!!!!!!!!!!!!!!!!
    
    var body: some View {
        let buttonHeight = universalSize.height/10

        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()

            VStack {
                
                ScrollView {
                    
                    Button {
                        self.screenType = .settings
                    } label: {
                        MainUIButton(buttonText: "Settings", type: 1, height: buttonHeight)
                    }

                    Button {
                        isPresented1 = true
                    } label: {
                        MainUIButton(buttonText: "Acknowledgments", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        isPresented2 = true
                    } label: {
                        MainUIButton(buttonText: "Tutorial", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        isPresented3 = true
                    } label: {
                        MainUIButton(buttonText: "About", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        self.isSharePresented = true
                    } label: {
                        MainUIButton(buttonText: "Share App", type: 1, height: buttonHeight)
                    }
                    
                    Button {
                        writeReview()
                    } label: {
                        MainUIButton(buttonText: "Write Review", type: 1, height: buttonHeight)
                    }
                }
                Spacer()
                
                Button {
                    self.screenType = .noteSelection
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: buttonHeight)
                }
            }.padding(.top, 50)
        }
        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
        .fullScreenCover(isPresented: $isPresented1) {
            AcknowledgementsView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
        .fullScreenCover(isPresented: $isPresented2) {
            TutorialView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
        .fullScreenCover(isPresented: $isPresented3) {
            AboutDeveloperView(backgroundImage: backgroundImage, fileReaderAndWriter: fileReaderAndWriter)
        }
        .sheet(isPresented: $isSharePresented) {
            ActivityViewController(activityItems: [URL(string: "https://itunes.apple.com/app/id958625272")!])
        }
    }
    
    // MARK: - Actions

    // DOES THIS WORK??????????????????????????????
    private func writeReview() {
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
        URLQueryItem(name: "action", value: "write-review")
        ]

        guard let writeReviewURL = components?.url else {
        return
        }

        UIApplication.shared.open(writeReviewURL)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
