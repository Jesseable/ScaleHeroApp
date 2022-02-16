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
                        Text("Tutorial").asTitle()
                                    .padding()
                        
                        Divider().background(Color.white)
                            
                        Text(infoText())
                            .font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider().background(Color.white)
                        
                        Text("**Button Explanations:**")
                            .font(.title2)
                            .foregroundColor(Color.white)
                            .padding(5)
                        
                        Text(buttonText())
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
            i.  The 'Endless Loop' button plays the scale on repeat endlessly. As soon as the scale ends it loops directly back into the metronome count in
        
        Customized scale formats also can be saved as favourites
        
        Background colour can be adjusted and saved.
        """
        return text
    }
    
    func buttonText() -> String {
        let text = """
        Arpeggio and Scale Pages:
            From the arpeggio and scale page you are able to choose the scale options you would like to hear. You can also select the tonic (starting) note by selecting the 'Note' button
        
        Playing Page:
            This page contains all options for scale customisation
            Buttons:
                a. Number of Octaves: Allows you to select how many octaves the scale will be. The options are a 1, 2 or 3 octave scale
                b. Starting Octave: Allows you to select the octave at which the scale notes are played. Note that this is avaliable when only playing one octave scales
                c. Tempo: Adjusts the speed to the scale. The number displayed indicates the number of beats per minute
                d. Drone: Allows the user to remove the drone sound
                e. Play Notes: Allows the user to remove the scale note sounds
                f. Metronome: Allows the user to remove the metronome clicking sound
                g. Repeat Notes: Repeat Notes: When activated, every note in the scale selected is repeated. This can be beneficial when the user listens to each note and then plays only when the note is repeated, allowing more time for adjustment in between notes
                h. Endless Loop: Sets the selected scale to repeat endlessly. This allows the user to practice a scale multiple times without having to press play multiple times
                i. Repeat Tonics: The tonic is the first note of a scale. Repeat Tonics means repeating this note throughout the scale. The options avaliable are to repeat 'all' tonics, meaning the first and last note are doubled in addition to all of the other tonic notes in the scale. The 'not initial' option repeats all of the tonics in the scale except the first and last tonic notes. When this is on with repeat notes then all of the tonic notes will be repeated four times
                j. Note Display: This allows the user to select whether they want the displayed notes to appear as sharps or flats, if applicable. Automatic mode will select the computer generated option chosen
                k. Save: This button allows you to save the present scale characteristics to the favourites page. Selecting a scale in the favourites page will automatically restore all of the saved characteristics for that scale
        
        Settings:
            Buttons:
                a. Background: This allows you to customise the background image. Note that after selecting the colour you want, you will need to press apply or back to see the change.
                b. Transposition: This allows you to choose a transposition option if needed. For examaple, if you change the transposition note to an 'F', and then select an F major scale, it will play a C major scale with the F major notes displayed. You can also choose your transposition note through your instrument
                c. Scale Instrument: Select the scale instrument
                d. Drone: Select the drone sound
                e. Metronome: This option allows you to add off-beat metronome clicks into the scales. The two options are simple (three off beat notes) or compound (two off beat notes). Note that this option is only avaliable for scales with a tempo under 70bpm
                f. Apply: This option applies the changes you have made to the app. Note that pressing the back button also applies the changes directly to the app
        """
        return text
    }
}
