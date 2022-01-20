//
//  FileManager-DocumentsDirectory.swift
//  ScaleHero
//
//  Created by Jesse Graf on 2/1/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
