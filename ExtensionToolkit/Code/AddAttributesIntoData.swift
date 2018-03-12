//
//  AddDataAttributes.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 12/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import CoreData

class AddAttributesIntoData {
    func insertEntityAttributesIntoData(data: [String:Any], object: NSManagedObject, entity: NSEntityDescription) {
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
}
