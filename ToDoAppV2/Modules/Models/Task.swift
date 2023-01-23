//
//  Task.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 19/1/23.
//

import Foundation


struct Task: Codable {
    
    var id: String
    var title: String
    var isDone: Bool
    
    func changeIsDoneProperty() -> Task {
        let task = Task(id: id, title: title, isDone: !isDone)
        return task
    }
    
}
