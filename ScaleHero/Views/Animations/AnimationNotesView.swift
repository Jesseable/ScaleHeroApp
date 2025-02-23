//
//  AnimationNotesView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 30/1/2025.
//

import SwiftUI

struct AnimationNotesView: View {
    let width: CGFloat
    @Binding var offset: CGFloat
    let fileReaderAndWriter: FileReaderAndWriter

    var body: some View {
        Group {
            ImageAnimation(imageName: "Treble-Cleff" + self.fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.65, duration: 7.00, offset: self.$offset)

            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.9, duration: 5.00, offset: self.$offset)

            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: 0, duration: 10.00, offset: self.$offset)

            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.4, duration: 6.25, offset: self.$offset)

            ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.1, duration: 4.60, offset: self.$offset)

            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.35, duration: 12.00, offset: self.$offset)

            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.07, duration: 5.48, offset: self.$offset)

            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: width * 0.48, duration: 8.00, offset: self.$offset)
        }
    }
}
