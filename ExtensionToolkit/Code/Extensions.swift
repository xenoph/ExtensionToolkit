//
//  Extensions.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 12/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import UIKit

public extension Int {
    /*
     Takes a hh:mm:ss string and attempts to parse it to an int
     Returns total seconds
     - parameter hms: A String with the format HH:MM:SS
     - returns: An Int
     */
    public static func parseHMS(hms: String) -> Int {
        var totalSeconds = 0
        let stringValues = hms.split(separator: ":")
        let hours = Int(stringValues[0]) ?? 0
        let minutes = Int(stringValues[1]) ?? 0
        let seconds = Int(stringValues[2]) ?? 0
        
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        
        totalSeconds += (seconds + hoursToSeconds + minutesToSeconds)
        
        return totalSeconds
    }
}

public extension CGFloat {
    public static func parseHMS(hms: String) -> CGFloat {
        return CGFloat(Int.parseHMS(hms: hms))
    }
}
