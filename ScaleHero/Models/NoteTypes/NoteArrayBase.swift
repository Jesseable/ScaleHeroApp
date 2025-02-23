//
//  NoteArrayBase.swift
//  ScaleHero
//
//  Created by Jesse Graf on 20/12/2024.
//

import Foundation

protocol NoteArrayBase: Identifiable, Codable {
    var id: UUID { get }
    var note: Notes { get }
}
