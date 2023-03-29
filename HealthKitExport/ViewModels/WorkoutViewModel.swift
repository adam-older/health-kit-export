//
//  WorkoutViewModel.swift
//  HealthKitExport
//
//  Created by Adam Older on 2/24/23.
//

import Foundation
import HealthKit

final class WorkoutViewModel : ObservableObject {
    var hkWorkouts = [HKWorkout]()
    @Published var workouts: [WorkoutModel] = []
    
//    var repository: HKRepository
    private var workoutService: WorkoutService
    private var repository = HKRepository()
    
    @MainActor
    init() {
        self.workoutService = WorkoutService(repository: repository)
        Task {
            workouts = await workoutService.getWorkouts()
        }
    }
    
//    func loadWorkouts() {
//        Task {
//            hkWorkouts = await repository.readWorkouts() ?? []
//        }
//
//    }
}
