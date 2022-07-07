//
//  AchievementsView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 5/7/2022.
//

import SwiftUI

struct AchievementsView: View {
    @Binding var screenType: ScreenType
    var backgroundImage: String
    
    var fileReaderAndWriter = FileReaderAndWriter()
    @EnvironmentObject var musicNotes: MusicNotes
    private let universalSize = UIScreen.main.bounds
    
    var body: some View {
        let achievementValues = fileReaderAndWriter.readScaleAchievements().components(separatedBy: ":")
        let numThisWeek = achievementValues[0]
        let numThisMonth = achievementValues[1]
        let numThisYear = achievementValues[2]
        let numAllTime = achievementValues[3]
        
        VStack {
        
            Text("ACHIEVEMENTS").asTitle()

            Divider().background(Color.white)
            
            ScrollView {
                Group {
                    Text("Total Scales Played This Week:")
                        .headingFormat(width: universalSize.width)
                    
                    Text(String(numThisWeek))
                        .valueFormat(width: universalSize.width)
                    
                    Divider().background(Color.white)
                    
                    Text("Total Scales Played This Month:")
                        .headingFormat(width: universalSize.width)
                    
                    Text(String(numThisMonth))
                        .valueFormat(width: universalSize.width)
                }
                
                Group {
                    Divider().background(Color.white)
                    
                    Text("Total Scales Played This Year:")
                        .headingFormat(width: universalSize.width)
                    
                    Text(String(numThisYear))
                        .valueFormat(width: universalSize.width)
                    
                    Divider().background(Color.white)
                    
                    Text("Total Scales Played All Time:")
                        .headingFormat(width: universalSize.width)
                    
                    Text(String(numAllTime))
                        .valueFormat(width: universalSize.width)
                }
            }
            
            Spacer()
            Button {
                musicNotes.backDisplay = .noteSelection
                self.screenType = musicNotes.backDisplay
            } label: {
                MainUIButton(buttonText: "Back", type: 3, height: universalSize.height / 10)
            }
        }
        .background(alignment: .center) { Image(backgroundImage).resizable().ignoresSafeArea(.all).scaledToFill() }
    }
}

extension Text {
    func headingFormat(width: CGFloat) -> some View {
        font(.title2)
        .foregroundColor(Color.white)
        .frame(maxWidth: width * 0.9, alignment: .leading)
        .padding(.bottom, 5)
    }
    
    func valueFormat(width: CGFloat) -> some View {
        frame(maxWidth: 50, alignment: .center)
        .font(.system(size: 36, weight: .black, design: .serif))
        .background(AngularGradient(colors: [.red, .green, .blue, .purple, .pink],
                                     center: .center,
                                     startAngle: .degrees(90),
                                   endAngle: .degrees(360)))
    }
}
