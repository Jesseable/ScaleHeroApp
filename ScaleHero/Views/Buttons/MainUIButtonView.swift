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
    let height : CGFloat
    let buttonWidth : CGFloat
    let fileReaderAndWriter = FileReaderAndWriter()
    
    var body: some View {
        ZStack {
            let buttonColor = fileReaderAndWriter.readBackgroundImage()
            switch type { // TODO: CHANGE TO AN ENUM
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
            case 10:
                RectangularButton()
                    .fill(Color(buttonColor + "Dark"))
                    .padding(.horizontal, 10)
                    .frame(width: buttonWidth, height: height)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                            .padding(.horizontal, 10)
                    )
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
