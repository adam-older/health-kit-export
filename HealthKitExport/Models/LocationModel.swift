//
//  LocationModel.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/31/23.
//

import Foundation

struct LocationModel {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let horizontalAccuracy: Double
    let verticalAccuracy: Double
    let timeStamp: Date
    let speed: Double
    let speedAccuracy: Double
    let course: Double
    let courseAccuracy: Double
}
