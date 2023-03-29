//
//  WorkoutView.swift
//  HealthKitExport
//
//  Created by Adam Older on 3/27/23.
//

import SwiftUI
import HealthKit

struct WorkoutView: View {
    let w: WorkoutModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Description " + w.workout!.description)
            Text("Start Date " + w.workout!.startDate.formatted())
            Text("Duration " + (w.workout?.duration.formatted() ?? ""))
            Text("Total Distance " + w.totalDistance.formatted())
            Text("Average Heart Rate " + w.AverageHeartRate.formatted())
            HeartRateListView(heartRateList: w.HeartRateList)

            }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(w: WorkoutModel(workout: HKWorkout(activityType: .running, start: .now, end: .now+1, duration: 3600, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 200), totalDistance: HKQuantity(unit: .mile(), doubleValue: 2), metadata: [:]), totalDistance: 2, AverageHeartRate: 150, HeartRateList: [HeartRateStat(HeartRate: "120"), HeartRateStat(HeartRate: "110"), HeartRateStat(HeartRate: "122")]))
    }
}
