//
//  HealthStat.swift
//  HealthKitExport
//
//  Created by Adam Older on 2/23/23.
//

import Foundation
import HealthKit

struct HealthStat: Identifiable {
    let id = UUID()
    let stat: HKQuantity?
    let date: Date
}
