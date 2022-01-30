//
//  FileReaderAndWriter.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/21.
//

import Foundation

/**
 Handles all of the reading and writing of files throughout the app
 */
class FileReaderAndWriter: ObservableObject {
    
    @Published var scales: [Scale]
    let filePath = FileManager.documentsDirectory.appendingPathComponent("FavouriteScales")
    let scaleInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("ScaleInstrument")
    let backgroundColourPath = FileManager.documentsDirectory.appendingPathComponent("backGroundColour")
    let transpositionPath = FileManager.documentsDirectory.appendingPathComponent("transposition")
    let metronomePulsePath = FileManager.documentsDirectory.appendingPathComponent("metronomePulse")
    
    // Need to make the JSON FIle
    init() {
        do {
            let data = try Data(contentsOf: filePath)
            scales = try JSONDecoder().decode([Scale].self, from: data)
        } catch {
            scales = []
        }
    }

    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(scales)
            try data.write(to: filePath, options: [.atomic, .completeFileProtection])
            // TO BE REMOVED LATER
            //print (filePath.path)
        } catch {
            print("Unable to save data")
        }
    }

    func add(scaleInfo: String, tonality: String, type: String, tempo: Int, startingOctave: Int, numOctave: Int, tonicSelection: Int, scaleNotes: Bool, drone: Bool, startingNote: String, noteDisplay: Int) {

        let scale = Scale(id: UUID(),
                          scaleInfo: scaleInfo,
                          tonality: tonality,
                          type: type,
                          tempo: tempo,
                          startingOctave: startingOctave,
                          numOctave: numOctave,
                          tonicSelection: tonicSelection,
                          scaleNotes: scaleNotes,
                          drone: drone,
                          scaleDescription: "Octaves: \(numOctave), Drone: \(drone ? "on": "off")",
                          startingNote: startingNote,
                          noteDisplay: noteDisplay)
        scales.insert(scale, at: 0)
        save()
    }
    
    func delete(_ scale: Scale) {
        if let index = scales.firstIndex(of: scale) {
            scales.remove(at: index)
            save()
        }
    }
    
    func writeBackgroundImage(newImage: String) {
        do {
            try newImage.write(to: backgroundColourPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            Swift.print(error)
            print("error has occured when writing to the file")
        }
    }
    
    func readBackgroundImage() -> String {
        //reading
        do {
            return try String(contentsOf: backgroundColourPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading instrument file" // Return default option IN FUTURE WHEN DECIDED UPON !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
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
            return try String(contentsOf: scaleInstrumentPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading instrument file" // Return default option IN FUTURE WHEN DECIDED UPON !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
    
    func writeNewTransposition(newTransposition: String) {
        //writing
        do {
            try newTransposition.write(to: transpositionPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            Swift.print(error)
            print("error has occured when writing to the file")
        }
    }
    
    func readTransposition() -> String {
        //reading
        do {
            return try String(contentsOf: transpositionPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading instrument file" // Return default option IN FUTURE WHEN DECIDED UPON !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
    
    func writeNewMetronomePulse(newPulse: String) {
        //writing
        do {
            try newPulse.write(to: metronomePulsePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            Swift.print(error)
            print("error has occured when writing to the file")
        }
    }
    
    func readMetronomePulse() -> String {
        //reading
        do {
            return try String(contentsOf: metronomePulsePath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading instrument file" // Return default option IN FUTURE WHEN DECIDED UPON !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
}
