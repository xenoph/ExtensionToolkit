//
//  DataExtraction.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 13/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import CoreData

public class DataExtraction {
    
    public static var managedContext: NSManagedObjectContext!

    public static func retrieveJsonData(jsonObj: [String:Any], dataName: [String], primaryKey: [String], completionHandler: @escaping() -> Void) {
        for numb in 0..<dataName.count {
            if !DataExtraction.oldDataExists(name: dataName[numb]) {
                if let collArray = jsonObj[primaryKey[numb]] {
                    var result: [[String: Any]] = []
                    
                    if let array = collArray as? [[String: Any]] {
                        result = array
                    } else if let dictionary = collArray as? [String: Any] {
                        result = dictionary.compactMap({ item in item.value as? [String: Any] })
                    }
                    DataExtraction.saveDataToContext(dataName: dataName[numb], collection: result)
                }
            }
        }
        completionHandler()
    }
    
    public static func oldDataExists(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        do {
            return try DataExtraction.managedContext.count(for: fetchRequest) > 0
        } catch _ as NSError {
            return false
        }
    }
    
    public static func saveDataToContext(dataName: String, collection: [[String:Any]]) {
        for coll in collection {
            let entity = NSEntityDescription.entity(forEntityName: dataName, in: managedContext)!
            let collObject = NSManagedObject(entity: entity, insertInto: managedContext)
            DataExtraction.insertEntityAttributesIntoData(data: coll, object: collObject, entity: entity)
        }
        DataExtraction.saveContext()
    }
    
    public static func insertEntityAttributesIntoData(data: [String:Any], object: NSManagedObject, entity: NSEntityDescription) {
        for kvp in data {
            if let property = entity.propertiesByName[kvp.key] {
                if let attributeDescription = property as? NSAttributeDescription {
                    if attributeDescription.attributeType == .dateAttributeType, let dateString = kvp.value as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = dateFormatter.date(from: dateString)
                        object.setValue(date, forKey: kvp.key)
                    } else {
                        if kvp.value is NSNull {
                            object.setValue(nil, forKey: kvp.key)
                        } else {
                            object.setValue(kvp.value, forKey: kvp.key)
                        }
                    }
                }
            }
        }
    }

    public static func getDataArray<T:NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil) -> [T] {
        var dataArray: [T]
        do {
            var fetchRequest: NSFetchRequest<NSFetchRequestResult>
            if #available(iOS 10.0, *) {
                fetchRequest = type.fetchRequest()
            } else {
                fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self)) as! NSFetchRequest<NSFetchRequestResult>
            }
            fetchRequest.predicate = predicate
            dataArray = try DataExtraction.managedContext.fetch(fetchRequest).compactMap({ $0 as? T})
            return dataArray
        } catch let error as NSError {
            print("Could not get old data. \(error)")
        }
        return []
    }
    
    public static func saveContext () {
        if DataExtraction.managedContext.hasChanges {
            do {
                try DataExtraction.managedContext.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
