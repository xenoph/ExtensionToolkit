//
//  Extensions.swift
//  ExtensionToolkit
//
//  Created by Bjørn Vidar Dahle on 12/03/2018.
//  Copyright © 2018 Bjørn Vidar Dahle. All rights reserved.
//

import UIKit
import CoreData

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

extension NSManagedObject {
    open override func didChange(_ changeKind: NSKeyValueChange, valuesAt indexes: IndexSet, forKey key: String) {
        super.didChange(changeKind, valuesAt: indexes, forKey: key)
        guard let automappable = self as? Automappable else {
            return
        }
        if let autoMapTo = automappable.automapKeys()?[key] {
            setValue(value(forKey: key), forKey: autoMapTo)
        }
    }
}

public enum LineFill {
    case dotted
    case line
    case space
}

public extension UILabel {
    public func fillLine(_ fill: LineFill) {
        guard attributedText == self.attributedText else {
            var string = NSString(string: self.text!)
            var textSize: CGSize = string.size(withAttributes: [NSAttributedStringKey.font: self.font])
            
            while (textSize.width < self.bounds.width - 16) {
                self.text = self.text! + stringForFill(fill)
                string = NSString(string: self.text!)
                textSize = string.size(withAttributes: [NSAttributedStringKey.font: self.font])
            }
            return
        }
        
        let textSize: CGSize = self.attributedText!.size()
        let font = UIFont(name: "AvenirNext-Regular", size: self.font.pointSize) ?? UIFont.systemFont(ofSize: self.font.pointSize)
        let fillString: NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: font])

        while (textSize.width + fillString.size().width < self.bounds.width - 16) {
            let filler = NSAttributedString(string: stringForFill(fill), attributes: [NSAttributedStringKey.font: font])
            fillString.append(filler)
        }
        
        self.attributedText = NSMutableAttributedString(attributedString: self.attributedText!).appending(fillString)
    }
    
    fileprivate func stringForFill(_ fill: LineFill) -> String {
        if fill == .dotted {
            return "."
        }
        
        if fill == .line {
            return "_"
        }
        
        return " "
    }
}

public extension NSMutableAttributedString {
    public func appending(_ string: NSAttributedString) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        text.append(string)
        return text
    }
}
