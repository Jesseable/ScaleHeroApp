//
//  MusicNotes.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/1/2025.
//

import SwiftUI


/**
 Observable object class that stays in the environment. Saves and publishes data that will be used in multiple classes
 */
class MusicNotes: ObservableObject {
    
    var musicArray: MusicArray?
    @Published var tonicNote: Notes = .C
    @Published var tempo = 60.0
    @Published var octaves: OctaveNumber = .one
    
    @Published var tonicMode: TonicOption = .noRepeatedTonic
    // An enum containing either scale or arpeggio followed by the tonality, e.g. Case.scale(.major)
    @Published var tonality: Case = .unselected
    @Published var intervalOption: Interval = .none // TODO: Fix these names
    @Published var intervalType: IntervalOption = .allUp
    @Published var backDisplay: ScreenType = .homepage
    @Published var otherSpecificScaleTypes : OtherScaleTypes?
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var backgroundImage : String?
    @Published var playScaleNotes = true
    @Published var playDrone = true
    @Published var startingOctave: OctaveNumber = .one
    @Published var transposition: FileNotes = .C
    @Published var noteDisplay = 2
    @Published var metronome = true
    @Published var dismissable = false
    @Published var repeatNotes = false
    @Published var metronomePulse = 1 // TODO: Changed to an enum or in the metronome class???
    @Published var endlessLoop = false
    @Published var displayType: DisplayType = .notes
}
