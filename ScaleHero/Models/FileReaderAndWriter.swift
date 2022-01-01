//
//  FileReaderAndWriter.swift
//  ScaleHero
//
//  Created by Jesse Graf on 31/12/21.
//

import SwiftUI

struct FileReaderAndWriter {
    
    let manager = FileManager.default
    let file = "ScaleInstruments"
    
//    func createFile() {
//        if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = dir.appendingPathComponent(file)
//            //writing
//            manager.createFile(atPath: fileURL.path, contents: nil, attributes: [:])
//            print(fileURL.path)
//        }
//    }
    
    func writeScaleInstrument(newInstrument: String) {
        if let fileURL = Bundle.main.url(forResource: file, withExtension: "txt") {
            //let fileURL = getDocumentsDirectory().appendingPathComponent(file)
    //        if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
            //let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try newInstrument.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                // Look into this or make the pop up errors occur for users when this occurs !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                Swift.print(error)
                print("error has occured when writing to the file")
            }
        }
    }
    
    func readScaleInstrument() -> String {
        //if let dir = manager.urls(for: .documentDirectory, in: .userDomainMask).first {
        if let fileURL = Bundle.main.url(forResource: file, withExtension: "txt") {
            //let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                let instrumentName = try String(contentsOf: fileURL, encoding: .utf8)
                return instrumentName
            }
            catch {
                Swift.print(error)
                return "Error caught when reading instrument file" // Return default option. 
            }
        } else {
            return "Error in reading the instrument String"
        }
    }
}
