//
//  AppStoreReviewManager.swift
//  ScaleHero
//
//  Created by Jesse Graf on 13/7/2022.
//

import SwiftUI
import StoreKit

enum AppStoreReviewManager {
    // number of scales played before it is presented
    static var threshold = 11
    @AppStorage("runsSinceLastRequest") static var runsSinceLastRequest = 0
    @AppStorage("version") static var version = ""

    static func requestReviewIfAppropriate() {
        runsSinceLastRequest += 1
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let thisVersion = "\(appVersion) build: \(appBuild)"
        if thisVersion != version {
            if runsSinceLastRequest >= threshold {
                if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                    version = thisVersion
                    runsSinceLastRequest = 0
                }
            }
        } else {
            runsSinceLastRequest = 0
        }
    }
}
