//
//  FileReaderAndWriter.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/21.
//

import SwiftUI

struct FileReaderAndWriter {
    
    let manager = FileManager.default
    let file = "ScaleInstrument.txt"
    
    func createFile() {
        if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            //writing
            manager.createFile(atPath: fileURL.path, contents: nil, attributes: [:])
            print(fileURL.path)
        }
    }
    
    func writeScaleInstrument(newInstrument: String) {
        if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try newInstrument.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                Swift.print(error)
            }
        }
    }
    
    func readScaleInstrument() -> String {
        if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                let instrumentName = try String(contentsOf: fileURL, encoding: .utf8)
                return instrumentName
            }
            catch {
                Swift.print(error)
                return "Error caught when reading instrument file"
            }
        } else {
            return "Error in reading the instrument String"
        }
    }
}
