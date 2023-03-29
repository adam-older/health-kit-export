//
//  HealthStoreSingleton.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/13/23.
//

import Foundation
import HealthKit

class HealthStoreSingleton {
    class var sharedInstance: HealthStoreSingleton {
        struct Singleton {
            static let instance = HealthStoreSingleton()
        }

        return Singleton.instance
    }

    let healthStore = HKHealthStore()
}
