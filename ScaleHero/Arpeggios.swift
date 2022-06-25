//
//  Arpeggios.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

class Arpeggios: Identifiable, Codable {
    let id: UUID
    let name: String
    let arpeggioArrays: [ArpeggioArrays]
}
