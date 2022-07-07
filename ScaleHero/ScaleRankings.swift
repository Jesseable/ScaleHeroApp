//
//  File.swift
//  ScaleHero
//
//  Created by Jesse Graf on 7/7/2022.
//

import Foundation

struct ScaleRankings: Identifiable, Codable {
    let id: UUID
    let timeStatus: String
    var first: String
    var second: String
    var third: String
    var fourth: String
    var fifth: String
}
