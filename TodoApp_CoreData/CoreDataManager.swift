//
//  CoreDataManager.swift
//  TodoApp_CoreData
//
//  Created by 초코크림 on 2023/05/15.
//

import Foundation
import CoreData

// singleton
class CoreDataManager{
    static let shared = CoreDataManager()
    private init(){}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TodoApp_CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData<T: NSManagedObject>(entity: T.Type) -> [T]?{
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: T.self.description())
    
        do{
            return try context.fetch(fetchRequest)
        }
        catch{
            print(error)
        }
        return nil
    }
    
    func create<T: NSManagedObject>(entity: T.Type, completion: (T) -> Void){
        let context = self.persistentContainer.viewContext
        guard let entityDesctiption = NSEntityDescription.entity(forEntityName: T.self.description(), in: context) else{
            return
        }
        guard let managedObject = NSManagedObject(entity: entityDesctiption, insertInto: context) as? T else{
            return
        }
        
        completion(managedObject)
        self.saveContext()
    }
    
    func update<T: NSManagedObject>(entity: T, completion: (T) -> Void){
        completion(entity)
        self.saveContext()
    }
    
    func delete(entity: NSManagedObject){
        let context = self.persistentContainer.viewContext
        
        context.delete(entity)
        self.saveContext()
    }
}
