//
//  ScaleArrays.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

struct ScaleArrays: Identifiable, Codable {
    let id: UUID
    let note: String
    let major: [String]
    let naturalMinor: [String]
    let harmonicMinor: [String]
    let melodicMinor: [String]
    let chromatic: [String]
    let pentatonic: [String]
    let blues: [String]
//
//    var image: String {
//        name.lowercased().replacingOccurrences(of: " ", with: "-")
//    }
}
