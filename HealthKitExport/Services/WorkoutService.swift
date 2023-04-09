//
//  WorkoutService.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/13/23.
//

import Foundation
import HealthKit

class WorkoutService {
    var repository: HKRepository
    
    init(repository: HKRepository) {
        self.repository = repository
    }
    
    func getWorkouts() async -> [WorkoutModel] {
        let hkWorkouts = await repository.readWorkouts() ?? []
        //        let workouts = hkWorkouts.map { (workout: HKWorkout) -> WorkoutModel in return { WorkoutModel(workout: workout)
        //            }()
        var workouts = [WorkoutModel]()
        for hkWorkout in hkWorkouts {
            //            getAllStatistics(workout: hkWorkout)
            //            let result = repository.getSplitData(workout: hkWorkout)
            var workoutModel = WorkoutModel()
            workoutModel.workout = hkWorkout
            workoutModel.HeartRateSamples = await getSeriesData(workout: hkWorkout, quantityType: .HeartRate, workoutModelId: workoutModel.id)
            workoutModel.totalDistance = getDistanceStatistic(workout: hkWorkout)
            workoutModel.AverageHeartRate = getAvgHeartRateStatistic(workout: hkWorkout)
            
            workoutModel.LocationList = await getRouteLocations(workout: hkWorkout)
            
//            let workoutRoute = await repository.getWorkoutRoute(workout: hkWorkout)
//            let locationList = await repository.getLocationDataForRoute(givenRoute: workoutRoute![0])
            
            //            let heartRateList = await repository.getHeartRateData(workout: hkWorkout)
            //            let distanceStatistic = getDistanceStatistic(workout: hkWorkout)
            //            let avgHeartRateStatistic = getAvgHeartRateStatistic(workout: hkWorkout)
            //            let workoutModel = WorkoutModel(workout: hkWorkout, totalDistance: distanceStatistic, AverageHeartRate: avgHeartRateStatistic, HeartRateList: heartRateList)
            workouts.append(workoutModel)
        }
        return workouts
    }
    
    func getWorkoutStatistic(workout: HKWorkout, quantityType: HKQuantityType, unit: HKUnit) -> Double {
        let statistic = workout.statistics(for: quantityType)?.sumQuantity()?.doubleValue(for: unit)
        return statistic ?? 0.00
    }
    
    func getDistanceStatistic(workout: HKWorkout) -> Double {
        //        let quantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
        let quantityType = HKQuantityType(HKQuantityTypeIdentifier.distanceWalkingRunning)
        let mileUnit = HKUnit.mile()
        return getWorkoutStatistic(workout: workout, quantityType: quantityType, unit: mileUnit)
        
    }
    
    func getAvgHeartRateStatistic(workout: HKWorkout) -> Double {
        let quantityType = HKQuantityType(HKQuantityTypeIdentifier.heartRate)
        let countPerMinuteUnit = HKUnit.count().unitDivided(by: .minute())
        let statistic = workout.statistics(for: quantityType)?.averageQuantity()?.doubleValue(for: countPerMinuteUnit)
        return statistic ?? 0.00
    }
    
    func getAllStatistics(workout: HKWorkout) {
        let allStatistics = workout.allStatistics
        print(allStatistics.keys)
    }
    
    func getSeriesData(workout: HKWorkout, quantityType: QuantityType, workoutModelId: UUID) async -> [QuantitySample] {
        let hkQuantityType = getHkQuantityType(quantityType: quantityType)
        let hrSeriesData = await repository.getSeriesData(workout: workout, quantityType: hkQuantityType)
        var heartRateList = [QuantitySample]()
        for hr in hrSeriesData {
            let hrStat = QuantitySample(quantityType: quantityType, hKQuantitySample: hr, workoutModelId: workoutModelId)
            heartRateList.append(hrStat)
        }
        return heartRateList
    }
    private func convertHeartRateUnits(quantity: HKQuantity) -> Double {
        let countPerMinute = HKUnit.count().unitDivided(by: .minute())
        return quantity.doubleValue(for: countPerMinute)
    }
    
    private func getHkQuantityType(quantityType: QuantityType) -> HKQuantityType {
        switch quantityType {
        case QuantityType.HeartRate:
            return HKQuantityType(HKQuantityTypeIdentifier.heartRate)
        }
        
    }
    private func getRouteLocations(workout: HKWorkout) async -> [LocationModel]  {
        let workoutRoute = await repository.getWorkoutRoute(workout: workout)
        let locationList = await repository.getLocationDataForRoute(givenRoute: workoutRoute![0])
        
        let result: [LocationModel] = locationList.map({(loc) -> LocationModel in
            return LocationModel(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, altitude: loc.altitude, horizontalAccuracy: loc.horizontalAccuracy, verticalAccuracy: loc.verticalAccuracy, timeStamp: loc.timestamp, speed: loc.speed, speedAccuracy: loc.speedAccuracy, course: loc.course, courseAccuracy: loc.courseAccuracy)})
        
        return result
    }
    
}
