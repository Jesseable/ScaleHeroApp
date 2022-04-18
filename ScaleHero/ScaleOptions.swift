//
//  ScaleOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

class ScaleOptions: ObservableObject, Codable {
    let scales: [Scales]
    //let arpeggios: [Arpeggios]

    init() {
        do {
            guard let url = Bundle.main.url(forResource: "scale-data", withExtension: "json") else {
                fatalError("Failed to located scaleOptions.json")
            }
            //let bundlePath = Bundle.main.path(forResource: "scaleOptions", ofType: "json")
            //let data = try String(contentsOfFile: bundlePath!).data(using: .utf8)
            let jsonData = try Data(contentsOf: url)
            let scaleOptionsData = try JSONDecoder().decode(ScaleOptions.self, from: jsonData)
            print(scaleOptionsData)

            scales = scaleOptionsData.scales
            //arpeggios = scaleOptionsData.arpeggios
        } catch {
            //print(error.localizedDescription)
            //print(error)
            print(String(describing: error))
            fatalError("scaleOptions.json is missing or corrupt.")
        }
    }
}
