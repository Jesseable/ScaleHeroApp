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
    private let productURL = URL(string: "https://apps.apple.com/app/id1608260694")!
    
    var body: some View {
        let buttonHeight = universalSize.height/10

        VStack {
            
            ScrollView {
                
                Button {
                    self.screenType = .settings
                } label: {
                    MainUIButton(buttonText: "Settings", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }

                Button {
                    isPresented1 = true
                } label: {
                    MainUIButton(buttonText: "Acknowledgments", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }
                
                Button {
                    isPresented2 = true
                } label: {
                    MainUIButton(buttonText: "Tutorial", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }
                
                Button {
                    isPresented3 = true
                } label: {
                    MainUIButton(buttonText: "About", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }
                
                Button {
                    self.isSharePresented = true
                } label: {
                    MainUIButton(buttonText: "Share App", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }
                
                Button {
                    writeReview()
                } label: {
                    MainUIButton(buttonText: "Write Review", type: 1, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
                }
            }
            Spacer()
            
            Button {
                self.screenType = .noteSelection
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: buttonHeight, buttonWidth: universalSize.width * 0.9)
            }
        }.padding(.top, 50)
            .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
        //.frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
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
            ActivityViewController(activityItems: [productURL])
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
