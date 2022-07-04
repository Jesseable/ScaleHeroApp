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

    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        
        let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
        let buttonHeight = universalSize.height/10
        let centre = CGPoint(x: universalSize.midX, y: universalSize.maxY * 0.3)
        
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
                let radius = universalSize.width * 0.4
                let colour = "BlueDark"
                titleImage.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height/6)
                    .padding(.top)
                
                ZStack {
                    VStack {
                        HStack {
                            Button {
                                //screenType = .achievements
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(colour))
                                        .frame(height: universalSize.width * 0.12, alignment: .center)
                                    Image(systemName: "checkmark.shield.fill").foregroundColor(Color.yellow)
                                }
                            }.frame(width: universalSize.width * 0.12,
                                    height: universalSize.width * 0.12)
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            Button {
                                self.screenType = .favouritesview
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(colour))
                                        .frame(height: universalSize.width * 0.12, alignment: .center)
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                }
                            }.frame(width: universalSize.width * 0.12,
                                    height: universalSize.width * 0.12)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    
                    Circle().opacity(0.3)
                        .position(centre)
                        .foregroundColor(Color(colour))
                    CircleOfFifthButtons(colour: colour, radius: radius, centre: centre, option: .outer, screenType: $screenType)
                    CircleOfFifthButtons(colour: colour, radius: radius, centre: centre, option: .centre, screenType: $screenType)
                    CircleOfFifthButtons(colour: colour, radius: radius * 0.65, centre: centre, option: .inner, screenType: $screenType)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Button {
                                //screenType = .hintview
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(colour))
                                        .frame(height: universalSize.width * 0.12, alignment: .center)
                                    Image(systemName: "questionmark.circle.fill").foregroundColor(Color.yellow)
                                }
                            }.frame(width: universalSize.width * 0.12,
                                    height: universalSize.width * 0.12)
                                .padding()
                            
                            Spacer()
                        }
                    }
                }
               
                Spacer()
                    
                Button {
                    self.screenType = .aboutview
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
    
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    let colour : String
    let radius : CGFloat
    let centre : CGPoint
    let option : circleOfFifthsOption
    @Binding var screenType: ScreenType
    
    var body: some View {
        let count = 12
        let currentAngle: CGFloat = 0
        let buttonAngle: CGFloat = (CGFloat(360 / count)) * .pi / 180
        //let centre = CGPoint(x: universalSize.midX, y: universalSize.maxY * 0.3)
        //let radius = universalSize.width * 0.4

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
                //let pos = placePos(around: centre, radius: radius, currentAngle: 0)
                Button {
                    screenType = .homepage
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: universalSize.width * 0.3, height: universalSize.width * 0.3, alignment: .center)
                            .foregroundColor(Color.green)
                        Text("\(musicNotes.noteName)").font(
                            .system(size: universalSize.width * 0.2, weight: .semibold, design: .serif))
                            .foregroundColor(.white)
                            .frame(alignment: .center)
                    }
                }.frame(width: universalSize.width * 0.3) // WEIRD THING HAPPENING HERE???????????????????
                    .position(centre)
            }
            
        }
    }
    
    @ViewBuilder func NoteSelectionButtons(colour: String, note: String) -> some View {
        Button {
            musicNotes.noteName = note
        } label: {
            ZStack {
                Circle()
                    .fill(Color(colour))
                    .frame(height: universalSize.width * 0.12, alignment: .center)
                Text("\(note)").font(.system(size: universalSize.width * 0.07,
                                             weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
        }.frame(width: universalSize.width * 0.12,
                height: universalSize.width * 0.12)
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
