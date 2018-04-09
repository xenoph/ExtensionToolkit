//
//  FetchData.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 13/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import CoreData

public class FetchData {
    public static func getJson(fromURL: String, completionHandler: @escaping([String:Any]) -> Void) {
        let url = NSURL(string: fromURL)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any] {
                completionHandler(jsonObj)
            } else {
                completionHandler([:])
            }
        }).resume()
    }
}
