//
//  ContentView.swift
//  HealthKitExport
//
//  Created by Adam Older on 2/23/23.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    private var repository: HKRepository = HKRepository()
    
    @StateObject var workoutViewModel = WorkoutViewModel()
    
    var body: some View {
        List{
            ForEach(workoutViewModel.workouts) { w in
                WorkoutView(w: w)
            }
        }
    }
                    
//        List(workoutViewModel.workouts) { w in
//            VStack(alignment: .leading) {
//                Text("Description " + w.workout!.description)
//                Text("Start Date " + w.workout!.startDate.formatted())
//                Text("Duration " + (w.workout?.duration.formatted() ?? ""))
//                Text("Total Distance " + w.totalDistance.formatted())
//                Text("Average Heart Rate " + w.AverageHeartRate.formatted())
//
//                }
//            HeartRateListView(heartRateList: w.HeartRateList)
//            }
//        .navigationTitle("test")
//        .onAppear() {
//                    repository.requestAuthentication { success in
//                        print("Auth Success? \(success)")
//
//                    }
//                }
//    }
        
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
