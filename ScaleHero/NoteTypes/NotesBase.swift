//
//  NotesAbstract.swift
//  ScaleHero
//
//  Created by Jesse Graf on 20/12/2024.
//

import Foundation

protocol NotesBase: Identifiable, Codable {
    associatedtype NoteArrayType: NoteArrayBase
    var id: UUID { get }
    var name: String { get }
    var noteArray: [NoteArrayType] { get }
}
