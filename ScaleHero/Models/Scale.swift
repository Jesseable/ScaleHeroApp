//
//  Scale.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/1/22.
//

import Foundation

// NEED TO ADD WHEN THE FAVOURITES PAGE ARRIVES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
struct Scale: Identifiable, Codable, Equatable {
    var id: UUID
    let name: String
    let type: String
    let tonality: String
    let tempo: Int
    let octaves: Int
}
