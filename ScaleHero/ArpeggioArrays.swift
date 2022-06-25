//
//  ArpeggioArrays.swift
//  ScaleHero
//
//  Created by Jesse Graf on 25/6/2022.
//

import Foundation

struct ArpeggioArrays: Identifiable, Codable {
    let id: UUID
    let note: String
    let major: [String]
    let minor: [String]
    let dominant7th: [String]
    let diminished7th: [String]
    let major7th: [String]
    let minor7th: [String]
}
