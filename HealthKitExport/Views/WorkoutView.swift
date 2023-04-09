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
            HeartRateListView(heartRateSamples: w.HeartRateSamples)
            LocationView(locationList: w.LocationList)
            }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(w: DummyData().workouts[0])
    }
}
