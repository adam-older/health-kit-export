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
    var workout: HKWorkout?
    var totalDistance: Double
    var AverageHeartRate: Double
    var HeartRateList: [HeartRateStat]
    var HeartRateSamples: [QuantitySample]
    var LocationList: [LocationModel]
    
    init() {
        self.workout = nil
        self.totalDistance = 0.00
        self.AverageHeartRate = 0.00
        self.HeartRateList = []
        self.HeartRateSamples = []
        self.LocationList = []
    }
    
    init(workout: HKWorkout?, totalDistance: Double, AverageHeartRate: Double, HeartRateList: [HeartRateStat], HeartRateSamples: [QuantitySample], LocationList: [LocationModel]) {
        self.workout = workout
        self.totalDistance = totalDistance
        self.AverageHeartRate = AverageHeartRate
        self.HeartRateList = HeartRateList
        self.HeartRateSamples = HeartRateSamples
        self.LocationList = LocationList
    }
}
