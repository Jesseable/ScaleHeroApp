//
//  FileReaderAndWriter.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/21.
//

import Foundation

class FileReaderAndWriter: ObservableObject {
    
    // USE THIS WHEN CREATING THE FAVOURITES PAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    @Published var scales: [Scale]
    let filePath = FileManager.documentsDirectory.appendingPathComponent("FavouriteScales")
    let scaleInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("ScaleInstrument")
    
    // Need to make the JSON FIle
    init() {
        do {
            let data = try Data(contentsOf: filePath)
            scales = try JSONDecoder().decode([Scale].self, from: data)
        } catch {
            scales = []
        }
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(scales)
            try data.write(to: filePath, options: [.atomic, .completeFileProtection])
            print (filePath.path)
        } catch {
            print("Unable to save data")
        }
    }
    
    func add(scaleNote: String, type: String, tonality: String, octave: Int, tempo: Int) {

        let scale = Scale(id: UUID(), name: scaleNote, type: type, tonality: tonality, tempo: tempo, octaves: octave)
        scales.insert(scale, at: 0)
        save()
    }
    
    func writeScaleInstrument(newInstrument: String) {
        //writing
        do {
            try newInstrument.write(to: scaleInstrumentPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            Swift.print(error)
            print("error has occured when writing to the file")
        }
    }
    
    func readScaleInstrument() -> String {
        //reading
        do {
            let instrumentName = try String(contentsOf: scaleInstrumentPath, encoding: .utf8)
            return instrumentName
        }
        catch {
            Swift.print(error)
            return "Error caught when reading instrument file" // Return default option.
        }
    }
}
