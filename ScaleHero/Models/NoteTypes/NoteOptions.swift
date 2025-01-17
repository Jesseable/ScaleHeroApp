//
//  ScaleOptions.swift
//  ScaleHero
//
//  Created by Jesse Graf on 18/4/2022.
//

import Foundation

class NoteOptions: ObservableObject, Codable {
    let scales: [Scales]
    let arpeggios: [Arpeggios]

    init() {
        do {
            guard let url = Bundle.main.url(forResource: "scale-data", withExtension: "json") else { // TODO: Rename to note-data later on
                fatalError("Failed to located scaleOptions.json")
            }
            let jsonData = try Data(contentsOf: url)
            let scaleOptionsData = try JSONDecoder().decode(NoteOptions.self, from: jsonData)
            //print(scaleOptionsData) // Just for testing purposes

            scales = scaleOptionsData.scales
            arpeggios = scaleOptionsData.arpeggios
        } catch {
            print(String(describing: error))
            fatalError("scaleOptions.json is missing or corrupt.")
        }
    }
}
// TODO: Is this do be deleted???
// Custom decoding for NotesBase
extension Scales: Codable {
    func encode(to encoder: any Encoder) throws {
        // nothing needed yet
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, noteArray
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        // Decode the noteArray into the correct type (ScaleArray)
        self.noteArray = try container.decode([ScaleArray].self, forKey: .noteArray)
    }
}

extension Arpeggios: Codable {
    func encode(to encoder: any Encoder) throws {
        // Nothing needed yet
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, noteArray
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)

        // Decode the noteArray into the correct type (ArpeggioArray)
        self.noteArray = try container.decode([ArpeggioArray].self, forKey: .noteArray)
    }
}
