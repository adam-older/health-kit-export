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
            let heartRateList = await repository.getHeartRateData(workout: hkWorkout)
            let distanceStatistic = getDistanceStatistic(workout: hkWorkout)
            let avgHeartRateStatistic = getAvgHeartRateStatistic(workout: hkWorkout)
            let workoutModel = WorkoutModel(workout: hkWorkout, totalDistance: distanceStatistic, AverageHeartRate: avgHeartRateStatistic, HeartRateList: heartRateList)
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
    
    func getHeartRateSeriesData(workout: HKWorkout) async -> [HeartRateStat] {
        let quantityType = HKQuantityType(HKQuantityTypeIdentifier.heartRate)
        let seriesData = await repository.getSeriesData(workout: workout, quantityType: quantityType)
        
    }
    
}
