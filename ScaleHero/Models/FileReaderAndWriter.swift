//
//  FileReaderAndWriter.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/21.
//

import Foundation

/**
 Handles any reading and writing of files for the app
 */
class FileReaderAndWriter: ObservableObject {
    
    @Published var scales: [Scale]
    
    let filePath = FileManager.documentsDirectory.appendingPathComponent("FavouriteScales")
    let scaleInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("ScaleInstrument")
    let backgroundColourPath = FileManager.documentsDirectory.appendingPathComponent("backGroundColour")
    let transpositionPath = FileManager.documentsDirectory.appendingPathComponent("transposition")
    let metronomePulsePath = FileManager.documentsDirectory.appendingPathComponent("metronomePulse")
    let droneInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("DroneInstrument")
    let countInBeatsPath = FileManager.documentsDirectory.appendingPathComponent("CountInBeats")
    
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

    func add(scaleInfo: String,
             tonality: String,
             type: String,
             tempo: Int,
             startingOctave: Int,
             numOctave: Int,
             tonicSelection: Int,
             scaleNotes: Bool,
             drone: Bool,
             startingNote: String,
             noteDisplay: Int,
             endlessLoop: Bool) {

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
                          noteDisplay: noteDisplay,
                          endlessLoop: endlessLoop)
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
            Swift.print(error)
            print("error has occured when writing to the background file")
        }
    }
    
    func readBackgroundImage() -> String {
        //reading
        do {
            return try String(contentsOf: backgroundColourPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the background file"
        }
    }
    
    func writeScaleInstrument(newInstrument: String) {
        //writing
        do {
            try newInstrument.write(to: scaleInstrumentPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the Instrument file")
        }
    }
    
    func readScaleInstrument() -> String {
        //reading
        do {
            return try String(contentsOf: scaleInstrumentPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the instrument file"
        }
    }
    
    func writeNewTransposition(newTransposition: String) {
        //writing
        do {
            try newTransposition.write(to: transpositionPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the Transposition file")
        }
    }
    
    func readTransposition() -> String {
        //reading
        do {
            return try String(contentsOf: transpositionPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading Transposition file"
        }
    }
    
    func writeNewMetronomePulse(newPulse: String) {
        //writing
        do {
            try newPulse.write(to: metronomePulsePath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the Metronome file")
        }
    }
    
    func readMetronomePulse() -> String {
        //reading
        do {
            return try String(contentsOf: metronomePulsePath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the metronome file"
        }
    }
    
    func writeDroneInstrument(newDrone: String) {
        //writing
        do {
            try newDrone.write(to: droneInstrumentPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the Drone file")
        }
    }
    
    func readDroneInstrument() -> String {
        //reading
        do {
            return try String(contentsOf: droneInstrumentPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the drone file"
        }
    }
    
    func writeIntroBeats(beats: String) {
        //writing
        do {
            try beats.write(to: countInBeatsPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the Drone file")
        }
    }
    
    func readIntroBeats() -> String {
        //reading
        do {
            return try String(contentsOf: countInBeatsPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the IntroBeats file"
        }
    }
    
    /**
     Checks if the file exists
     */
    func checkFilePath(for fileDescription: String) -> Bool {
        var path : String
        switch fileDescription.lowercased() {
        case "intropulse":
            path = countInBeatsPath.path
        case "droneinstrument":
            path = droneInstrumentPath.path
        case "scaleinstrument":
            path = scaleInstrumentPath.path
        case "background":
            path = backgroundColourPath.path
        case "transposition":
            path = transpositionPath.path
        case "metronome":
            path = metronomePulsePath.path
        default:
            // Error message displayed
            print("Not a valid file descirption when searching for the file")
            path = "No File Could Be Found"
        }
        if FileManager.default.fileExists(atPath: path) {
            return true
        }
        return false
    }
}
