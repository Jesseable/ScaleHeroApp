//
//  CalcScalesCount.swift
//  ScaleHero
//
//  Created by Jesse Graf on 7/7/2022.
//

import Foundation
import UIKit

struct CalcScalesCount {
    private let scaleOptions: ScaleOptions
    
    /*
     Initialises the variables for the function. The variables will contain the top 5
         most played scales
     ----------------
     @param ScaleOptions: The data from the json file ScaleData that contains the number
         of times each scale has been played
     */
    init(scaleOptions: ScaleOptions) {
        self.scaleOptions = scaleOptions
 
    }
    
    /*
     Increments the count value and adds it to the ranking if applicable
     ----------------
     @param tonality: A string in the form of the json file text
     @param note: A string in the form of the json file note name
     */
    func incrememntAchievementsCount(tonality : String, note: String) {
        let achievementsCount = scaleOptions.achievementsCount
        var lowestNum = 0

//        achievementsCount.
        for count in achievementsCount {
            if (count.note == note) {
                
            }
            count.major[0] += 1
            
            
            
            
            var i = 0
            for number in count.major {
                if (number != 0) {
                    if (number > lowestNum) {
                        //number += 1
                        addToArray(at: i, numCount: number, tonality: tonality)
                    }
                }
                i += 1
            }
        }
        fatalError("failed due to not being able to read base scale notes from the json file")
    }
    
//    private func incremenetMajor(achievementsCount : AchievementsCount) {
//        for number in achievementsCount.major {
//            achievementsCount.
//        }
//    }
    
    private func addToArray(at indexPos: Int, numCount: Int, tonality: String) {
        
    }
    
    // For the achievementsCount
    enum Index : Int {
        case week = 0
        case month = 1
        case year = 2
        case allTime = 3
    }
    
    /*
     An Enum that contained the index position that correlated to each place of each
         variable in the arrays
     */
    enum Place : Int {
        case first = 0
        case second = 1
        case third = 2
        case fourth = 3
        case fifth = 4
    }
}
