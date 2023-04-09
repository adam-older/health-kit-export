//
//  DummyData.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/29/23.
//

import Foundation
import HealthKit

struct DummyData {
    var workouts: [WorkoutModel]
    
    let heartRateList: [HeartRateStat] = [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")]
    let heartRateSample: [QuantitySample] = [
                                            QuantitySample(quantityType: .HeartRate, quantity: 120, startDate: Date.now, endDate: Date.now.addingTimeInterval(5), workoutId: UUID()),
                                            QuantitySample(quantityType: .HeartRate, quantity: 123, startDate: Date.now.addingTimeInterval(5), endDate: Date.now.addingTimeInterval(10), workoutId: UUID()),
                                            QuantitySample(quantityType: .HeartRate, quantity: 124, startDate: Date.now.addingTimeInterval(10), endDate: Date.now.addingTimeInterval(15), workoutId: UUID())
    ]
    let locationList: [LocationModel] = [
        LocationModel(latitude: 32.859, longitude: -117.2311, altitude: 50, horizontalAccuracy: 1, verticalAccuracy: 1, timeStamp: Date.now, speed: 1.5, speedAccuracy: 1, course: 20, courseAccuracy: 1),
        LocationModel(latitude: 33, longitude: -118, altitude: 50, horizontalAccuracy: 1, verticalAccuracy: 1, timeStamp: Date.now.addingTimeInterval(5), speed: 1.5, speedAccuracy: 1, course: 20, courseAccuracy: 1)
    ]
    
    init() {
        self.workouts = [
            WorkoutModel(workout: HKWorkout(activityType: .running, start: .now, end: .now+1, duration: 3600, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200), totalDistance: HKQuantity(unit: .mile(), doubleValue: 2), metadata: [:]), totalDistance: 2, AverageHeartRate: 150, HeartRateList: [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")], HeartRateSamples: heartRateSample, LocationList: locationList),
            WorkoutModel(workout: HKWorkout(activityType: .running, start: .now, end: .now+1, duration: 3600, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200), totalDistance: HKQuantity(unit: .mile(), doubleValue: 2), metadata: [:]), totalDistance: 2, AverageHeartRate: 150, HeartRateList: [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")], HeartRateSamples: heartRateSample, LocationList: locationList),
            WorkoutModel(workout: HKWorkout(activityType: .running, start: .now, end: .now+1, duration: 3600, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200), totalDistance: HKQuantity(unit: .mile(), doubleValue: 2), metadata: [:]), totalDistance: 2, AverageHeartRate: 150, HeartRateList: [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")], HeartRateSamples: heartRateSample, LocationList: locationList)
        ]
    }
    
    init(workouts: [WorkoutModel]) {
        self.workouts = workouts
    }
}
