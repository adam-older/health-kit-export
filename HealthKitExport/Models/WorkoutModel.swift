//
//  WorkoutModel.swift
//  HealthKitExport
//
//  Created by Adam Older on 2/24/23.
//

import Foundation
import HealthKit

struct WorkoutModel: Identifiable {
    let id = UUID()
    let workout: HKWorkout?
    let totalDistance: Double
    let AverageHeartRate: Double
    let HeartRateList: [HeartRateStat]
//    let date: Date
}
