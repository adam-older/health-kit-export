//
//  HKRepository.swift
//  HealthKitExport
//
//  Created by Adam Older on 2/23/23.
//

import Foundation
import HealthKit
import CoreLocation

class HKRepository {
    var store: HKHealthStore?
    
    init() {
//        store = HKHealthStore()
        store = HealthStoreSingleton.sharedInstance.healthStore
    }
    
    let allTypes = Set([
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!
    ])
    
    func requestAuthentication(completion: @escaping(Bool) -> Void) {
        guard let store = store else {
            return
        }
        store.requestAuthorization(toShare: [], read: allTypes) { success, error in
            completion(success)
        }
    }
    
    func readWorkouts() async -> [HKWorkout]? {
        guard let store = store else {
            return nil
        }
        let running = HKQuery.predicateForWorkouts(with: .running)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: running, limit: 2
//                                            HKObjectQueryNoLimit
                                        ,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }

        return workouts
    }
    
    func getWorkoutRoute(workout: HKWorkout) async -> [HKWorkoutRoute]? {
        guard let store = store else {
            return nil
        }
        let byWorkout = HKQuery.predicateForObjects(from: workout)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }

        return workouts
    }
    
    func getWorkoutRouteLocations(myRoute: HKWorkoutRoute) -> [CLLocation]? {
        guard let store = store else {
            return nil
        }
        var locationsList = [CLLocation]()
        // Create the route query.
        let query = HKWorkoutRouteQuery(route: myRoute) { (query, locationsOrNil, done, errorOrNil) in
            
            // This block may be called multiple times.
            
            if let error = errorOrNil {
                // Handle any errors here.
                return
            }
            
            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }
            
            locationsList.append(contentsOf: locations)
                
            if done {
                // The query returned all the location data associated with the route.
                // Do something with the complete data set.
            }
            
            // You can stop the query by calling:
            // store.stop(query)
            
        }
        store.execute(query)
        return locationsList
    }
    
    func getSplitData(workout: HKWorkout) -> [HKQuantitySample] {
//        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        var quantitySample = [HKQuantitySample]()
        let distanceType = HKQuantityType(HKQuantityTypeIdentifier.distanceWalkingRunning)
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: distanceType, predicate: workoutPredicate, limit: 0, sortDescriptors: [startDateSort]) {
            (sampleQuery, results, error) in
            if let distanceSamples = results as? [HKQuantitySample] {
                quantitySample = distanceSamples
            }
        }
        store?.execute(query)
        return quantitySample
        
    }
    
    func getHeartRateData(workout: HKWorkout) async -> [HeartRateStat] {
        let heartRateType = HKQuantityType(HKQuantityTypeIdentifier.heartRate)
        let predicate = HKQuery.predicateForObjects(from: workout)
        
        var distanceStrings = [HeartRateStat]()
        let heartRatePredicate = HKSamplePredicate.quantitySample(type: heartRateType, predicate: predicate)
        let descriptor = HKSampleQueryDescriptor(predicates: [heartRatePredicate], sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)], limit: nil)
        
        do {
            let results = try await descriptor.result(for: store!)
            
            for result in results {
                let heartRate = HeartRateStat(HeartRate: getHeartRateString(quantity: result.quantity, startDate: result.startDate, endDate: result.endDate))
                distanceStrings.append(heartRate)
            }
        } catch {
            print(error)
        }
        
        
        return distanceStrings
        
    }
    
    func getSeriesData(workout: HKWorkout, quantityType: HKQuantityType) async -> [HKQuantitySample] {
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        let samplePredicate = HKSamplePredicate.quantitySample(type: quantityType, predicate: workoutPredicate)
        let descriptor = HKSampleQueryDescriptor(predicates: [samplePredicate], sortDescriptors: [SortDescriptor(\.endDate, order: .forward)], limit: nil)
        var results: [HKQuantitySample] = [HKQuantitySample]()
        do {
            results = try await descriptor.result(for: store!)
        } catch {
            print(error)
        }
        return results
    }
    
    func getHeartRateString(quantity: HKQuantity, startDate: Date, endDate: Date) -> String {
        let dateInterval = DateInterval(start: startDate, end: endDate)
        let countPerMinute = HKUnit.count().unitDivided(by: .minute())
        return quantity.doubleValue(for: countPerMinute).formatted() + dateInterval.start.formatted()
    }
    
    
//    DID NOT WORK
//    func getDistanceForWorkout(workout: HKWorkout) -> Double {
//        var totalDistance = 0.00
//
//        guard let distanceType =
//                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
//        else {
//            fatalError("Unable to create a distance type")
//        }
//
//        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
//
//        let startDateSort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
//
//        let query = HKSampleQuery(sampleType: distanceType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [startDateSort], resultsHandler: { (sampleQuery, results, error) -> Void in
//            guard let distanceSamples = results as? [HKQuantitySample] else {
//                // error handling here
//                return
//            }
//            // use workouts distance samples here
//            for sample in distanceSamples {
//                totalDistance += sample.quantity.doubleValue(for: .mile())
//            }
//
//
//        })
//        store?.execute(query)
//        return totalDistance
//    }
    
    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []

            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { (query, locationsOrNil, done, errorOrNil) in

                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                    return
                }

                guard let currentLocationBatch = locationsOrNil else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                allLocations.append(contentsOf: currentLocationBatch)

                if done {
                    continuation.resume(returning: allLocations)
                }
            }

            store!.execute(query)
        }

        return locations
    }


    
    
}
