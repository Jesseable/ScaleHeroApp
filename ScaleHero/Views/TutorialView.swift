//
//  TutorialView.swift
//  ScaleHero
//
//  Created by Jesse Graf on 1/2/22.
//

import SwiftUI

struct TutorialView: View {
    
    var backgroundImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var fileReaderAndWriter : FileReaderAndWriter
    
    var body: some View {

        ZStack {
            Color(fileReaderAndWriter.readBackgroundImage())
                .ignoresSafeArea()

            VStack {
                    ScrollView {
                        Text("Tutorial")
                                    .font(.largeTitle.bold())
                                    .accessibilityAddTraits(.isHeader)
                                    .foregroundColor(Color.white)
                                    .padding()
                        
                        Divider().background(Color.white)
                            
                        Text(infoText())
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    MainUIButton(buttonText: "Back", type: 3, height: UIScreen.main.bounds.height/10)
                }
            }
        }
    }
    
    func infoText() -> String {
        let text = """
        This app is intended to support music students in their scale practice.
        
        The app enables and encourages students to:
            1.  Practice alongside scale notes, listening closely to intonation
            2.  Practice alongside a drone and scale notes, listening closely to intonation
            3.  Practice alongside the drone alone, listening closely to intonation
            4.  Listen to an individual scale to understand its structure
            5.  Read and understand the note names of a given scale while practicing
            6.  Explore new scales and have fun!!!
        
        Scales can be customized as follows:
            a.  Instrument selection (piano, organ, strings)
            b.  Drone Selection (cello, tuning fork)
            c.  Transposition option for all keys
            d.  Scale selection (All recognized scales, including Major, Natural minor, Harmonic minor, Melodic minor, Modes, Arpeggios, Pentatonics, Blues, etc.)
            e.  Adjustment of tempo, time signature, starting note, starting octave, number of octaves, repetition of tonic note, metronome (simple or compound time)
            f.  Selection/addition of drone
            g.  Displayed Notes can be shown either as sharps or flats
            h.  Repeating note option to enable real time listen and play of each note
        
        Customized scale formats also can be saved as favourites
        
        Background colour can be adjusted and saved.
        """
        return text
    }
}
