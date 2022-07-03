//
//  NoteSelectionView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/7/2022.
//

import SwiftUI

struct NoteSelectionView: View {
        
    private let universalSize = UIScreen.main.bounds
    var fileReaderAndWriter = FileReaderAndWriter()
    //@Binding var screenType: ScreenType
    @State private var offset: CGFloat = .zero
    var backgroundImage: String

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        
        let titleImage = Image("ScaleHeroBlue") //+ fileReaderAndWriter.readBackgroundImage())
        let buttonHeight = universalSize.height/10
        
        ZStack {
            Image(backgroundImage).resizable().ignoresSafeArea()
            
            // Create all music note animations
            ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.3, duration: 7.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.3, duration: 5.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: 0, duration: 10.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.4, duration: 6.25, offset: self.$offset)
            
            ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: -universalSize.width * 0.1, duration: 4.60, offset: self.$offset)
            
            ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.35, duration: 12.00, offset: self.$offset)
            
            ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.07, duration: 5.48, offset: self.$offset)
            
            ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                           xPos: universalSize.width * 0.48, duration: 8.00, offset: self.$offset)
            
            VStack {

                titleImage.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height/6)
                    .padding()
                
                ZStack {
                    CircleOfFifthButtons(radius: universalSize.width * 0.4)
                    Circle().opacity(0.5)
                    CircleOfFifthButtons(radius: universalSize.width * 0.25)
                }
               
                Spacer()
                    
                Button {
                    // DOes nothing so far
                    //self.screenType = .aboutview
                } label: {
                    MainUIButton(buttonText: "About / Settings", type: 3, height: buttonHeight)
                }
            }
        }.onAppear() {
            offset += universalSize.height * 1.2
        }
    }
}

struct CircleOfFifthButtons: View {
    
    private let universalSize = UIScreen.main.bounds
    let colour = "BlueDark"
    let count = 12
    let radius : CGFloat
    
    var body: some View {
        let currentAngle: CGFloat = 0
        let buttonAngle: CGFloat = (CGFloat(360 / count)) * .pi / 180
        let centre = CGPoint(x: universalSize.midX, y: universalSize.maxY * 0.3)
        //let radius = universalSize.width * 0.4
        
        ZStack {
            Group {
                let firstPos = placePos(around: centre, radius: radius,
                                        currentAngle: currentAngle)
                NoteSelectionButtons(colour: colour) /// MAKE IT A BUTTON WITH TEXT
                    .position(x: firstPos.x, y: firstPos.y)
                
                let secondPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 1))
                NoteSelectionButtons(colour: colour)
                    .position(x: secondPos.x, y: secondPos.y)
                
                let thirdPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 2))
                NoteSelectionButtons(colour: colour)
                    .position(x: thirdPos.x, y: thirdPos.y)
                
                let fourthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 3))
                NoteSelectionButtons(colour: colour)
                    .position(x: fourthPos.x, y: fourthPos.y)
            }
            
            Group {
                let fifthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 4))
                NoteSelectionButtons(colour: colour)
                    .position(x: fifthPos.x, y: fifthPos.y)
                
                let sixthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 5))
                NoteSelectionButtons(colour: colour)
                    .position(x: sixthPos.x, y: sixthPos.y)
                
                let seventhPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 6))
                NoteSelectionButtons(colour: colour)
                    .position(x: seventhPos.x, y: seventhPos.y)
                
                let eighthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 7))
                NoteSelectionButtons(colour: colour)
                    .position(x: eighthPos.x, y: eighthPos.y)
            }
                
            Group {
                let ninethPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 8))
                NoteSelectionButtons(colour: colour)
                    .position(x: ninethPos.x, y: ninethPos.y)
                
                let tenthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 9))
                NoteSelectionButtons(colour: colour)
                    .position(x: tenthPos.x, y: tenthPos.y)
                
                let eleventhPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 10))
                NoteSelectionButtons(colour: colour)
                    .position(x: eleventhPos.x, y: eleventhPos.y)
                
                let twelvethPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 11))
                NoteSelectionButtons(colour: colour)
                    .position(x: twelvethPos.x, y: twelvethPos.y)
            }
        }
    }
    
    @ViewBuilder func NoteSelectionButtons(colour: String) -> some View {
        Circle()
            .fill(Color(colour))
            .frame(height: universalSize.width * 0.12, alignment: .center)
    }
    
    private func placePos(around center: CGPoint, radius: CGFloat,
                       currentAngle: CGFloat) -> (x: CGFloat, y: CGFloat) {

        let xPos = center.x + cos(currentAngle) * radius
        let yPos = center.y + sin(currentAngle) * radius
//        let buttonCenter = CGPoint(x: center.x + cos(currentAngle) * radius, y: center.y + sin(currentAngle) * radius)

        // (1)
        //button.transform = CGAffineTransform(rotationAngle: currentAngle)

        // (2)
        //view.addSubview(button)
        return (xPos, yPos)
//        button.center = buttonCenter
//        currentAngle += buttonAngle
    }
}

struct NoteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        //CircleOfFifthButtons()
        NoteSelectionView(backgroundImage: "BackgroundBlue")
    }
}
