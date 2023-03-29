//
//  QuantitySample.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/28/23.
//

import Foundation

struct QuantitySample: Identifiable {
    let id = UUID()
    let quantity: Double
    let quantityType: QuantityType
    let startDate: Date
    let endDate: Date
    let workoutId: UUID
}
