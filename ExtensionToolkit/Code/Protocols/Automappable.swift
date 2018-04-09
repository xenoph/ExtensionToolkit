//
//  Automappable.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 13/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

public protocol Automappable {
    func automapKeys() -> [String:String]?
}

