//
//  MainUIButtonView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/1/22.
//

import SwiftUI

struct MainUIButton: View {

    var buttonText: String
    var type : Int
    var height : CGFloat
    let fileReaderAndWriter = FileReaderAndWriter()
    private let universalSize = UIScreen.main.bounds
    
    var body: some View {
        let buttonWidth = universalSize.width 
        
        ZStack {
            let buttonColor = fileReaderAndWriter.readBackgroundImage()
            switch type {
            case 2:
                CroppedBelowButton()
                    .fill(style: FillStyle(eoFill: true))
                    .foregroundColor(Color(buttonColor))
                    .formatted(height: height, width: buttonWidth)
            case 3:
                CroppedAboveButton() // Bottum Buttons
                        .fill(style: FillStyle(eoFill: true))
                    .foregroundColor(Color(buttonColor + "Dark"))
                    .formatted(height: height, width: buttonWidth)
            case 4:
                RectangularButton() // Not able to select buttons
                    .fill(Color("GrayBasic"))
                    .formatted(height: height, width: buttonWidth)
            case 5:
                RectangularButton()
                    .fill(Color(buttonColor))
                    .padding(.trailing, 10)
                    .frame(width: buttonWidth * 0.5, height: height)
                    .opacity(0.8)
            case 6:
                RectangularButton()
                    .fill(Color(buttonColor))
                    .padding(.leading, 10)
                    .frame(width: buttonWidth * 0.5, height: height)
                    .opacity(0.8)
            case 7:
                RectangularButton()
                    .fill(Color("LightGrayBasic"))
                    .formatted(height: height, width: buttonWidth)
            case 8:
                RectangularButton()
                    .fill(Color("RedDark"))
                    .formatted(height: height, width: buttonWidth)
            case 9:
                RectangularButton()
                    .fill(Color(buttonColor + "Dark"))
                    .formatted(height: height, width: buttonWidth)
            default:
                RectangularButton()
                    .fill(Color(buttonColor))
                    .formatted(height: height, width: buttonWidth)
            }

            let scaleEffect = (height - 30)/height + 1
            if (buttonText.contains("SystemImage")) {
                let stringArr = buttonText.components(separatedBy: " SystemImage ")

                Text(" \(stringArr[0]) \(Image(systemName: stringArr[1]))")
                    .foregroundColor(Color.white).bold()
                    .scaleEffect(scaleEffect)
                    .frame(maxWidth: buttonWidth * 0.5, alignment: .center)
                    .allowsTightening(true)

            } else {
                Text(buttonText)
                    .foregroundColor(Color.white).bold()
                    .scaleEffect(scaleEffect)
            }
        }
    }
}

struct RectangularButton: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))
        return path
    }
}

struct CroppedAboveButton: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                      control1: CGPoint(x: rect.maxX * (0.15), y: rect.minY - 25),
                      control2: CGPoint(x: rect.maxX * (0.9), y: rect.minY + 15))
        return path
    }
}

struct CroppedBelowButton: Shape {

    var radius: CGSize = CGSize(width: 5, height: 5)
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radius)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                      controlPoint1: CGPoint(x: rect.maxX * (0.15), y: rect.maxY - 25),
                      controlPoint2: CGPoint(x: rect.maxX * (0.9), y: rect.maxY + 20))
        return Path(path.cgPath)
    }
}

/**
 Sets the Shapes paramater requirements by extendiong the view..
 */
extension View {
    func formatted(height: CGFloat, width: CGFloat) -> some View {
            padding(.horizontal, 10)
            .frame(width: width, height: height)
            .opacity(0.8)
    }
}
