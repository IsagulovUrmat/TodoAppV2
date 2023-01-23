//
//  CoreDataExtension.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 23/1/23.
//

import UIKit
import CoreData

extension AppDelegate {

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
