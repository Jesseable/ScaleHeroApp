//
//  ScaleHeroApp.swift
//  ScaleHero
//
//  Created by Jesse Graf on 14/12/21.
//

import SwiftUI

@main
struct ScaleHeroApp: App {
    @StateObject var musicNotes = MusicNotes()
    @StateObject var scaleOptions = ScaleOptions()
    
    var body: some Scene {
        WindowGroup {
            AppContentView()
                .environmentObject(musicNotes)
                .environmentObject(scaleOptions)
        }
    }
}
