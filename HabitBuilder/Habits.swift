//
//  Habits.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/6/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import Foundation
import Firebase

class Habits {
    
    var habitsArray = [Habit]()
    var db: Firestore!
        
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        //whenever anything changes in “spots”, run the code in the curls that follow, which will load in the new data with any changes
        db.collection("habits").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            
            self.habitsArray = []
            
            for document in querySnapshot!.documents {
                let habit = Habit(dictionary: document.data())
                habit.documentID = document.documentID
                self.habitsArray.append(habit)
            }
            completed()
        }
    }
}
