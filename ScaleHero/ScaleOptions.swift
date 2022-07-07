//
//  ScaleOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

class ScaleOptions: ObservableObject, Codable {
    let scales: [Scales]
    let arpeggios: [Arpeggios]
    var achievementsCount: [AchievementsCount]
    var scaleRankings: [ScaleRankings]

    init() {
        do {
            guard let url = Bundle.main.url(forResource: "scale-data", withExtension: "json") else {
                fatalError("Failed to located scaleOptions.json")
            }
            let jsonData = try Data(contentsOf: url)
            let scaleOptionsData = try JSONDecoder().decode(ScaleOptions.self, from: jsonData)
            //print(scaleOptionsData) // TO DELETE???

            scales = scaleOptionsData.scales
            arpeggios = scaleOptionsData.arpeggios
            achievementsCount = scaleOptionsData.achievementsCount
            scaleRankings = scaleOptionsData.scaleRankings
        } catch {
            print(String(describing: error))
            fatalError("scaleOptions.json is missing or corrupt.")
        }
    }
}
