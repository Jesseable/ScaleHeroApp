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
        GeometryReader { geometry in
            let buttonHeight = geometry.size.height / 10
            let width = geometry.size.width
            
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
                    MainUIButton(buttonText: "Back", type: 1, height: buttonHeight, buttonWidth: width)
                }
            }
            .background(alignment: .center) { Color(fileReaderAndWriter.readBackgroundImage()).ignoresSafeArea() }
        }
    }
    
    func infoText() -> String {
        let text = """
        This app is intended to support music students in their scale practice
        
        The app enables and encourages students to:
            1.  Practice alongside scale notes, listening closely to intonation
            2.  Practice alongside a drone and scale notes, listening closely to intonation
            3.  Practice alongside the drone alone, listening closely to intonation
            4.  Listen to an individual scale to understand its structure
            5.  Read and understand the note names of a given scale while practicing
            6.  Explore new scales and have fun!!!
        
        Scales can be customized as follows:
            1.  Instrument selection (piano, organ, strings)
            2.  Drone Selection (cello, tuning fork)
            3.  Transposition option for all keys
            4.  Scale selection (All recognized scales, including Major, Natural minor, Harmonic minor, Melodic minor, Major and Pentatonic Modes, Arpeggios, Pentatonics, Blues, etc.)
            5.  Adjustment of tempo, time signature, starting note, starting octave, number of octaves, repetition of tonic note, metronome (simple or compound time), number of intro beats
            6.  Selection/addition of drone
            7.  Variety of interval selection possibilities
            8.  Repeating note option to enable real time listen and play of each note
            9.  The 'Endless Loop' button plays the scale on repeat endlessly. As soon as the scale ends it loops directly back into the metronome count in
        
        Customized scale formats also can be saved as favourites
        
        Background colour can be adjusted and saved
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
                j. Interval Options: This allows the user to play scales in with specific intervals applied (Thirds, Fourths, or Fifths). Note: The Number of Octaves must be set to One and the Starting Octave must be Two to perform a scale with intervals
                k. Interval Type: When an interval option is set, this allows the user to chose how they want to intervals to be performed. All up (1 3 2 4 ...), All down (3, 1, 4, 2 ...), One Up One Down (1 3 4 2 ...) and One Down One Up (3 1 2 4 ...)
                l. Save: This button allows you to save the present scale characteristics to the favourites page. Selecting a scale in the favourites page will automatically restore all of the saved characteristics for that scale
        
        Settings:
            Buttons:
                a. Background: This allows you to customise the background image. Note that after selecting the colour you want, you will need to press apply or back to see the change.
                b. Transposition: This allows you to choose a transposition option if needed. For examaple, if you change the transposition note to an 'F', and then select an F major scale, it will play a C major scale with the F major notes displayed. You can also choose your transposition note through your instrument
                c. Scale Instrument: Select the scale instrument
                d. Drone: Select the drone sound
                e. Metronome: This option allows you to add off-beat metronome clicks into the scales. The two options are simple (three off beat notes) or compound (two off beat notes). Note that this option is only avaliable for scales with a tempo under 70bpm
                f. Intro Beats: These buttons will adjust the number of count in beats. There are two options, '<=70bpm' and '>70bpm'. This will ajust the count in beats for two different scenarios: when the tempo is either less than or eaqual to 70 beats per minute or, when the tempo is greater than 70 beats per minute
                g. Apply: This option applies the changes you have made to the app. Note that pressing the back button also applies the changes directly to the app
                h. Reset to Default: This will reset the value of all above buttons to their initial state
        """
        return text
    }
}
