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
        
        let titleImage = Image("ScaleHero" + fileReaderAndWriter.readBackgroundImage())
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
    
    var body: some View {
        HStack {
            NoteSelectionButtons()
                .fill(style: FillStyle(eoFill: true))
                .foregroundColor(Color("LightGrayBasic"))
                .padding(.horizontal, 10)
                .frame(width: universalSize.width * 0.18, height: universalSize.height * 0.08)
                .opacity(0.8)
                .rotationEffect(Angle(degrees: -30))
                .padding(.top, 40)
            
            NoteSelectionButtons()
                .fill(style: FillStyle(eoFill: true))
                .foregroundColor(Color("LightGrayBasic"))
                .padding(.horizontal, 10)
                .frame(width: universalSize.width * 0.18, height: universalSize.height * 0.08)
                .opacity(0.8)
            
            NoteSelectionButtons()
                .fill(style: FillStyle(eoFill: true))
                .foregroundColor(Color("LightGrayBasic"))
                .padding(.horizontal, 10)
                .frame(width: universalSize.width * 0.18, height: universalSize.height * 0.08)
                .opacity(0.8)
                .rotationEffect(Angle(degrees: 30))
                .padding(.top, 40)
        }
    }
}

struct NoteSelectionButtons: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(rect: rect)
        // No need to move
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                          controlPoint: CGPoint(x: rect.midX, y: rect.maxY * 0.9))
        // At top right
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        //path.addLine(to: CGPoint(x: rect.maxX * (1.1), y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY),
                          controlPoint: CGPoint(x: rect.midX, y: 0 - rect.maxY * 0.1))
        return Path(path.cgPath)
    }
}

struct NoteSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CircleOfFifthButtons()
        //NoteSelectionView(backgroundImage: "BackgroundBlack")
    }
}
