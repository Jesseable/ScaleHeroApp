//
//  Scales.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

class Scales: Identifiable, Codable {
    let id: UUID
    let name: String
    let scaleArrays: [ScaleArrays]
}
