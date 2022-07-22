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
    @Binding var screenType: ScreenType
    @State private var offset: CGFloat = .zero
    var backgroundImage: String
    @State private var presentHint = false
    private let circleImageScale = 0.6

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        
        let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
        let portrate = universalSize.height > universalSize.width
        let height = universalSize.height
        let width = universalSize.width
        let buttonHeight = height/10
        let maxSize = (portrate) ? CGFloat(250) : CGFloat(100)
        let radius = (maxSize > width * 0.4) ? width * 0.4 : maxSize
        let buttonSize = radius * 0.3
        let midY = (portrate) ? universalSize.minY + radius + buttonSize : universalSize.minY + radius + buttonSize
        let centre = CGPoint(x: universalSize.midX, y: midY)
        let hintText : Text = Text("Select a note from the circle of fifths and confirm by selecting the middle green button")
        
        ZStack {
            // Create all music note animations
            animationNotes(width: width)
            
            VStack {
                let colour = Color(fileReaderAndWriter.readBackgroundImage() + "Dark")
                
                if (portrate) {
                    titleImage.resizable()
                        .scaledToFit()
                        .frame(maxWidth: width * 0.9, maxHeight: height / 6)
                        .clipped()
                } else {
                    titleImage.resizable()
                        .scaledToFit()
                        .frame(maxWidth: width * 0.9, maxHeight: height / 6)
                }
                
                ScrollView {
                    Spacer()
                    ZStack {
                        topButtons(buttonSize: buttonSize, colour: colour)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 5)
                    
                        Circle().opacity(0.3)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(colour)
                            .frame(width: (radius + buttonSize * 0.8) * 2)
                            .position(centre)
                        
                        CircleOfFifthButtons(colour: colour, radius: radius, centre: centre, option: .outer, buttonSize: buttonSize, screenType: $screenType)
                        CircleOfFifthButtons(colour: colour, radius: radius, centre: centre, option: .centre, buttonSize: buttonSize, screenType: $screenType)
                        CircleOfFifthButtons(colour: colour, radius: radius - (buttonSize * 1.25), centre: centre, option: .inner, buttonSize: buttonSize, screenType: $screenType) // the button size
                        
                        bottomButtonLeft(buttonSize: buttonSize, colour: colour)
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 5)
                        bottomButtonRight(buttonSize: buttonSize, colour: colour)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 5)

                    }
                    .frame(height: (radius + buttonSize * 0.8) * 2)
                }
                .frame(width: width)
                
                Spacer()
                 
                // If removed the above calculation will have to change
                Button {
                    self.screenType = .aboutview
                } label: {
                    MainUIButton(buttonText: "About / Settings", type: 3, height: buttonHeight)
                }.aspectRatio(contentMode: .fill)
            }
            .alert(isPresented: $presentHint) {
                Alert(
                    title: Text("Selecting Notes"),
                    message: hintText,
                    dismissButton: .default(Text("Got it!"))
                );
            }
            .onAppear() {
                offset += height * 1.2
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
    
    @ViewBuilder func animationNotes(width: CGFloat) -> some View {
        ImageAnimation(imageName: "Treble-Cleff" + self.fileReaderAndWriter.readBackgroundImage(),
                       xPos: width * 0.3, duration: 7.00, offset: self.$offset)

        ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: -width * 0.3, duration: 5.00, offset: self.$offset)

        ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: 0, duration: 10.00, offset: self.$offset)

        ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: -width * 0.4, duration: 6.25, offset: self.$offset)

        ImageAnimation(imageName: "Treble-Cleff" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: -width * 0.1, duration: 4.60, offset: self.$offset)

        ImageAnimation(imageName: "Crotchet" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: width * 0.35, duration: 12.00, offset: self.$offset)

        ImageAnimation(imageName: "Quaver" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: width * 0.07, duration: 5.48, offset: self.$offset)

        ImageAnimation(imageName: "Semiquaver" + fileReaderAndWriter.readBackgroundImage(),
                       xPos: width * 0.48, duration: 8.00, offset: self.$offset)
    }
    
    @ViewBuilder func topButtons(buttonSize: CGFloat, colour: Color) -> some View {
        VStack {
            HStack {
                Button {
                    self.presentHint = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(colour)
                            .frame(height: buttonSize, alignment: .center)
                        Image(systemName: "questionmark.circle.fill").resizable().aspectRatio(contentMode: .fill)
                            .frame(width: buttonSize * circleImageScale, height: buttonSize * circleImageScale, alignment: .center)
                            .foregroundColor(Color.yellow)
                    }
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }.frame(width: buttonSize,
                        height: buttonSize)
                Spacer()
            }
            Spacer()
        }
    }
    
    @ViewBuilder func bottomButtonLeft(buttonSize: CGFloat, colour: Color) -> some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    screenType = .achievements
                } label: {
                    ZStack {
                        Circle()
                            .fill(colour)
                            .frame(height: buttonSize, alignment: .center)
                        Image(systemName: "checkmark.shield.fill").resizable().aspectRatio(contentMode: .fill)
                            .frame(width: buttonSize * circleImageScale, height: buttonSize * circleImageScale, alignment: .center)
                            .foregroundColor(Color.yellow)
                    }
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }.frame(width: buttonSize,
                        height: buttonSize)
                Spacer()
            }
        }
    }
    
    @ViewBuilder func bottomButtonRight(buttonSize: CGFloat, colour: Color) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    self.screenType = .favouritesview
                } label: {
                    ZStack {
                        Circle()
                            .fill(colour)
                            .frame(height: buttonSize, alignment: .center)
                        Image(systemName: "star.fill").resizable().aspectRatio(contentMode: .fill)
                            .frame(width: buttonSize * circleImageScale, height: buttonSize * circleImageScale, alignment: .center)
                            .foregroundColor(Color.yellow)
                    }
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }.frame(width: buttonSize,
                        height: buttonSize)
            }
        }
    }
}

struct CircleOfFifthButtons: View {
    
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    let colour : Color
    let radius : CGFloat
    let centre : CGPoint
    let option : circleOfFifthsOption
    let buttonSize : CGFloat
    @Binding var screenType: ScreenType
    
    var body: some View {
        let count = 12
        let currentAngle: CGFloat = 0
        let buttonAngle: CGFloat = (CGFloat(360 / count)) * .pi / 180

        ZStack {
            switch option {
            case .outer:
                Group {
                    let firstPos = placePos(around: centre, radius: radius,
                                            currentAngle: currentAngle)
                    NoteSelectionButtons(colour: colour, note: "A")
                        .position(x: firstPos.x, y: firstPos.y)
                    
                    let secondPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 1))
                    NoteSelectionButtons(colour: colour, note: "E")
                        .position(x: secondPos.x, y: secondPos.y)
                    
                    let thirdPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 2))
                    NoteSelectionButtons(colour: colour, note: "B")
                        .position(x: thirdPos.x, y: thirdPos.y)
                    
                    let fourthPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 3))
                    NoteSelectionButtons(colour: colour, note: "F#")
                        .position(x: fourthPos.x, y: fourthPos.y)
                }
                
                Group {
                    let fifthPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 4))
                    NoteSelectionButtons(colour: colour, note: "C#")
                        .position(x: fifthPos.x, y: fifthPos.y)
                    
                    let sixthPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 5))
                    NoteSelectionButtons(colour: colour, note: "G#")
                        .position(x: sixthPos.x, y: sixthPos.y)
                    
                    let seventhPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 6))
                    NoteSelectionButtons(colour: colour, note: "D#")
                        .position(x: seventhPos.x, y: seventhPos.y)
                    
                    let eighthPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 7))
                    NoteSelectionButtons(colour: colour, note: "A#")
                        .position(x: eighthPos.x, y: eighthPos.y)
                }
                    
                Group {
                    let ninethPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 8))
                    NoteSelectionButtons(colour: colour, note: "F")
                        .position(x: ninethPos.x, y: ninethPos.y)
                    
                    let tenthPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 9))
                    NoteSelectionButtons(colour: colour, note: "C")
                        .position(x: tenthPos.x, y: tenthPos.y)
                    
                    let eleventhPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 10))
                    NoteSelectionButtons(colour: colour, note: "G")
                        .position(x: eleventhPos.x, y: eleventhPos.y)
                    
                    let twelvethPos = placePos(around: centre, radius: radius,
                                             currentAngle: (currentAngle + buttonAngle * 11))
                    NoteSelectionButtons(colour: colour, note: "D")
                        .position(x: twelvethPos.x, y: twelvethPos.y)
                }
            case .inner:
                let fourthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 3))
                NoteSelectionButtons(colour: colour, note: "Gb")
                    .position(x: fourthPos.x, y: fourthPos.y)
                
                let fifthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 4))
                NoteSelectionButtons(colour: colour, note: "Db")
                    .position(x: fifthPos.x, y: fifthPos.y)
                
                let sixthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 5))
                NoteSelectionButtons(colour: colour, note: "Ab")
                    .position(x: sixthPos.x, y: sixthPos.y)
                
                let seventhPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 6))
                NoteSelectionButtons(colour: colour, note: "Eb")
                    .position(x: seventhPos.x, y: seventhPos.y)
                
                let eighthPos = placePos(around: centre, radius: radius,
                                         currentAngle: (currentAngle + buttonAngle * 7))
                NoteSelectionButtons(colour: colour, note: "Bb")
                    .position(x: eighthPos.x, y: eighthPos.y)
                
            case .centre:
                let maxSize = radius - (radius * 0.2)
                let size = (maxSize > universalSize.width * 0.3) ? universalSize.width * 0.3 : maxSize
                Button {
                    screenType = .homepage
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: size, height: size, alignment: .center)
                            .foregroundColor(Color.green)
                        Text("\(musicNotes.noteName)").font(
                            .system(size: size * 0.65, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                            .frame(alignment: .center)
                    }
                }.frame(width: size)
                    .position(centre)
            }
            
        }
    }
    
    @ViewBuilder func NoteSelectionButtons(colour: Color, note: String) -> some View {
        Button {
            musicNotes.noteName = note
        } label: {
            ZStack {
                Circle()
                    .fill(colour)
                    .frame(height: buttonSize, alignment: .center)
                Text("\(note)").font(.system(size: buttonSize * 0.5,
                                             weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
        }.frame(width: buttonSize,
                height: buttonSize)
    }
    
    private func placePos(around center: CGPoint, radius: CGFloat,
                       currentAngle: CGFloat) -> (x: CGFloat, y: CGFloat) {

        let xPos = center.x + cos(currentAngle) * radius
        let yPos = center.y + sin(currentAngle) * radius

        return (xPos, yPos)
    }
}

//struct NoteSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        //CircleOfFifthButtons()
//        NoteSelectionView(backgroundImage: "BackgroundBlue")
//    }
//}
