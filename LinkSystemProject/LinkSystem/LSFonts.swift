//
//  LSFonts.swift
//  LinkSystem
//
//  Created by Aamir  on 03/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation
import UIKit
/*
 - 0 : "AvenirNext-Medium"
 - 1 : "AvenirNext-DemiBoldItalic"
 - 2 : "AvenirNext-DemiBold"
 - 3 : "AvenirNext-HeavyItalic"
 - 4 : "AvenirNext-Regular"
 - 5 : "AvenirNext-Italic"
 - 6 : "AvenirNext-MediumItalic"
 - 7 : "AvenirNext-UltraLightItalic"
 - 8 : "AvenirNext-BoldItalic"
 - 9 : "AvenirNext-Heavy"
 - 10 : "AvenirNext-Bold"
 - 11 : "AvenirNext-UltraLight"
 */
enum LSFonts {
    static let PageHeading = UIFont(name: "AvenirNext-Bold", size: 53)!
    static let SectionHeadingBig = UIFont(name: "AvenirNext-DemiBold", size: 39)!
    static let SectionHeadingMedium = UIFont(name: "AvenirNext-DemiBold", size: 32)!
    static let ParagraphTitleBig = UIFont(name: "AvenirNext-Medium", size: 26)!
    static let ParagraphBody = UIFont(name: "AvenirNext-Regular", size: 18)!
    static let NavigationActionTitle = UIFont(name: "AvenirNext-DemiBold", size: 20)!
    static let ParagraphTitleMedium = UIFont(name: "AvenirNext-Medium", size: 19)!
    static let ParagraphBodySmall = UIFont(name: "AvenirNext-Medium", size: 13)!
    
    // Special font just for the recall page
    static let RecallFieldInput = UIFont(name: "AvenirNext-Medium", size: 40)!
    
    
    
    static func iconFontWith(size:Int) -> UIFont {
        return UIFont(name: "ionicons", size: CGFloat(size))!
    }
}

enum LSFontIcon {

    static var chevronDown:String? {
        do {
            let symbol = try "&#xf123;".convertHtmlSymbols()
            return symbol
        } catch {
            print("Error")
        }
        return nil
    }
    
    static var chevronUp:String? {
        do {
            let symbol = try "&#xf126;".convertHtmlSymbols()
            return symbol
        } catch {
            print("Error")
        }
        return nil
    }
    
    static var closeButtonRounded:String? {
        do {
            let symbol = try "&#xf129;".convertHtmlSymbols()
            return symbol
        } catch {
            print("Error")
        }
        return nil
    }
    
}


extension String {
    func convertHtmlSymbols() throws -> String? {
        guard let data = data(using: .utf8) else { return nil }
        return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
    }
}

