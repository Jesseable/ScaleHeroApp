//
//  DateTime.swift
//  ScaleHero
//
//  Created by Jesse Graf on 21/7/2022.
//

import Foundation

struct DateTime {
    
    var weekCount : Int
    var week : Int
    var month : Int
    var monthCount : Int
    var year : Int
    var yearCount : Int
    var allTimeCount : Int
    
    var prevWeek : Int
    var prevMonth : Int
    var prevYear : Int
    
    /*
     Initialises all of the information for the achievements page, including the count (Integer) of how many scales have been played
        and the time of day
     */
    init(scaleAchievements: String) {
        var scaleAchievementsArr = scaleAchievements.components(separatedBy: ":")
        // must be three
        if scaleAchievementsArr.count != 7 {
            scaleAchievementsArr = Array.init(repeating: "0", count: 7)
            print("Error: The scale Achievements page count in dateTime was not 7")
        }
        
        // set the count
        self.weekCount = Int(scaleAchievementsArr[0]) ?? 0
        self.monthCount = Int(scaleAchievementsArr[1]) ?? 0
        self.yearCount = Int(scaleAchievementsArr[2]) ?? 0
        self.allTimeCount = Int(scaleAchievementsArr[3]) ?? 0
        
        // set previous dates
        self.prevWeek = Int(scaleAchievementsArr[4]) ?? -1
        self.prevMonth = Int(scaleAchievementsArr[5]) ?? -1
        self.prevYear = Int(scaleAchievementsArr[6]) ?? -1
        
        // set the time
        let date = Date()

        let dayNameFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.calendar = .current
            // W - Week of Year
            // LL - Stand-Alone Month - Use one or two for the numerical month
            // yy - Year. Normally the length specifies the padding, but for two letters it also specifies the maximum length
            dateFormatter.dateFormat = "w:LL:yy"
            return dateFormatter
        }()
        
        let curDate = dayNameFormatter.string(from: date)
        let dateArr = curDate.components(separatedBy: ":")

        if dateArr.count != 3 {
            week = 0
            month = 0
            year = 0
            print("error: too many Date components supplied")
            return
        }
        
        week = Int(dateArr[0]) ?? 0
        month = Int(dateArr[1]) ?? 0
        year = Int(dateArr[2]) ?? 0
        
        if (prevWeek == 0) {
            prevWeek = week
        }
        if (prevMonth == 0) {
            prevMonth = month
        }
        if (prevYear == 0) {
            prevYear = year
        }
    }
    
    mutating func alterCount() {
        // check the year
        if (prevYear < year && prevYear != -1) {
            self.yearCount = 0
        }
        
        // check month
        if (prevMonth < month && prevMonth != -1) {
            self.monthCount = 0
        }
        
        if (prevWeek < week && prevWeek != -1) {
            self.weekCount = 0
        }
    }
}
