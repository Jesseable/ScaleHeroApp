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
class FileReaderAndWriter: ObservableObject { /// MOVE ALL OF THIS INTO ONE BIG TEXT FILE TO SAVE MEMORY
    
    @Published var scales: [ScaleCharacteristics]
    
    let filePath = FileManager.documentsDirectory.appendingPathComponent("FavouriteScales")
    let scaleInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("ScaleInstrument")
    let backgroundColourPath = FileManager.documentsDirectory.appendingPathComponent("backGroundColour")
    let transpositionPath = FileManager.documentsDirectory.appendingPathComponent("transposition")
    let metronomePulsePath = FileManager.documentsDirectory.appendingPathComponent("metronomePulse")
    let droneInstrumentPath = FileManager.documentsDirectory.appendingPathComponent("DroneInstrument")
    let countInBeatsPath = FileManager.documentsDirectory.appendingPathComponent("CountInBeats")
    let scaleAchievementsPath = FileManager.documentsDirectory.appendingPathComponent("ScaleAchievementsData")
    let initialHintPath = FileManager.documentsDirectory.appendingPathComponent("InitialHintData")
    
    init() {
        
        do {
            let data = try Data(contentsOf: filePath)
            scales = try JSONDecoder().decode([ScaleCharacteristics].self, from: data)
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

    func add(tonality: Case,
             tempo: Int,
             startingOctave: Int,
             numOctave: Int,
             tonicSelection: TonicOption,
             scaleNotes: Bool,
             drone: Bool,
             startingNote: String,
             noteDisplay: Int,
             endlessLoop: Bool,
             intervalType: IntervalOption,
             intervalOption: Interval) {

        let scale = ScaleCharacteristics(id: UUID(),
                          tonality: tonality,
                          tempo: tempo,
                          startingOctave: startingOctave,
                          numOctave: numOctave,
                          tonicSelection: tonicSelection,
                          scaleNotes: scaleNotes,
                          drone: drone,
                          scaleDescription: "Octaves: \(numOctave), Drone: \(drone ? "on": "off")",
                          startingNote: startingNote,
                          noteDisplay: noteDisplay,
                          endlessLoop: endlessLoop,
                          intervalType: intervalType,
                          intervalOption: intervalOption)
        scales.insert(scale, at: 0)
        save()
    }
    
    func delete(_ scale: ScaleCharacteristics) {
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
    
    func writeScaleAchievements(newData: String) {
        //writing
        do {
//            print(scaleAchievementsPath)
//            print(newData)
            try newData.write(to: scaleAchievementsPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("Error has occured when writing to the Achievements file")
        }
    }
    
    func readScaleAchievements() -> String {
        //reading
        do {
            return try String(contentsOf: scaleAchievementsPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the Scale Achievements Data"
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
    
    func writeInitialHint(value: String) {
        //writing
        do {
            try value.write(to: initialHintPath, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            Swift.print(error)
            print("error has occured when writing to the initialHint file")
        }
    }
    
    func readInitialHint() -> String {
        //reading
        do {
            return try String(contentsOf: initialHintPath, encoding: .utf8)
        }
        catch {
            Swift.print(error)
            return "Error caught when reading the initialHint file"
        }
    }
    
    /**
     Checks if the file exists
     */
    func checkFilePath(for filePath: FilePath) -> Bool {
        var path : String
        switch filePath {
        case .countInBeats:
            path = countInBeatsPath.path
        case .droneInst:
            path = droneInstrumentPath.path
        case .scaleInst:
            path = scaleInstrumentPath.path
        case .background:
            path = backgroundColourPath.path
        case .transposition:
            path = transpositionPath.path
        case .metronome:
            path = metronomePulsePath.path
        case .achievements:
            path = scaleAchievementsPath.path
        case .initialHint:
            path = initialHintPath.path
        }

        if FileManager.default.fileExists(atPath: path) {
            return true
        }
        return false
    }
}
