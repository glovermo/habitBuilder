//
//  Habit.swift
//  HabitBuilder
//
//  Created by Morgan Glover on 12/6/19.
//  Copyright © 2019 Morgan Glover. All rights reserved.
//

import Foundation
import Firebase

class Habit {
    
    var name: String
    var iconName: String
    var iconColor: String
    var goalCount: Int
    var goalTotal: Int
    var streakCount: Int
    var completed: Bool
    var lastCompletedDate: Date
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeStampDate = Timestamp(date: lastCompletedDate)
        return ["name": name, "iconName": iconName, "iconColor": iconColor, "goalCount": goalCount, "goalTotal": goalTotal, "streakCount": streakCount, "completed": completed, "lastCompletedDate": timeStampDate, "postingUserID": postingUserID]
    }
    
    init(name: String, iconName: String, iconColor: String, goalCount: Int, goalTotal: Int, streakCount: Int, completed: Bool, lastCompletedDate: Date, postingUserID: String, documentID: String) {
        self.name = name
        self.iconName = iconName
        self.iconColor = iconColor
        self.goalCount = goalCount
        self.goalTotal = goalTotal
        self.streakCount = streakCount
        self.completed = completed
        self.lastCompletedDate = lastCompletedDate
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(name: "", iconName: "", iconColor: "", goalCount: 0, goalTotal: 0, streakCount: 0, completed: Bool(), lastCompletedDate: Date(), postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let iconName = dictionary["iconName"] as! String? ?? ""
        let iconColor = dictionary["iconColor"] as! String? ?? ""
        let goalCount = dictionary["goalCount"] as! Int? ?? 0
        let goalTotal = dictionary["goalTotal"] as! Int? ?? 0
        let streakCount = dictionary["streakCount"] as! Int? ?? 0
        let completed = dictionary["completed"] as! Bool? ?? false
        let date = dictionary["lastCompletedDate"] as! Timestamp? ?? Timestamp()
        let lastCompletedDate = date.dateValue()
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, iconName: iconName, iconColor: iconColor, goalCount: goalCount, goalTotal: goalTotal, streakCount: streakCount, completed: completed, lastCompletedDate: lastCompletedDate, postingUserID: postingUserID, documentID: "")
    }
    
    func saveData(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the userID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completed(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave = self.dictionary
        // If we HAVE saved a record, we'll have a document ID
        if self.documentID != "" {
            let ref = db.collection("habits").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("*** Error updating document \(self.documentID) \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ Document updated with ref ID \(ref.documentID)")
                    completed(true)
                }
            }
        } else {
            var ref: DocumentReference? = nil // let firestore create the document ID
            ref = db.collection("habits").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("*** Error creating new document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("^^^ New document created with ref ID \(ref?.documentID ?? "unknown")")
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
        }
    }
    
    func deleteData() {
        let db = Firestore.firestore()
        db.collection("habits").document(self.documentID).delete{ error in
            if let error = error {
                print("*** ERROR: \(error.localizedDescription) deleting review \(self.documentID)")
            }
        }
    }
}
