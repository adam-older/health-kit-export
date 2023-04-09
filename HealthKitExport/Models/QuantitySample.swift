//
//  QuantitySample.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/28/23.
//

import Foundation
import HealthKit

struct QuantitySample: Identifiable {
    let id = UUID()
    private(set) var quantityType: QuantityType!
    private(set) var quantity: Double!
    private(set) var startDate: Date!
    private(set) var endDate: Date!
    private(set) var workoutId: UUID!
    
    init(quantityType: QuantityType, hKQuantitySample: HKQuantitySample, workoutModelId: UUID) {
        
        self.quantityType = quantityType
        self.quantity = convertQuantityUnits(quantityType: quantityType, hkQuantity: hKQuantitySample.quantity)
        self.startDate = hKQuantitySample.startDate
        self.endDate = hKQuantitySample.endDate
        self.workoutId = workoutModelId
    }
    
    init(quantityType: QuantityType, quantity: Double, startDate: Date, endDate: Date, workoutId: UUID) {
        self.quantity = quantity
        self.quantityType = quantityType
        self.startDate = startDate
        self.endDate = endDate
        self.workoutId = workoutId
    }
    
    private func convertQuantityUnits(quantityType: QuantityType, hkQuantity: HKQuantity) -> Double {
        switch quantityType {
        case QuantityType.HeartRate:
            let countPerMinute = HKUnit.count().unitDivided(by: .minute())
            return hkQuantity.doubleValue(for: countPerMinute)
        default:
            return 0.00
        }
    }
}
