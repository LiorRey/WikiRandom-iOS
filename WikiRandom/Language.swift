//
//  Language.swift
//  WikiRandom
//
//  Created by Team Hurrange on 06/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import Foundation

// an enum of the selected language
enum Language : Int
{
    case HEBREW = 1
    case ENGLISH
    case RUSSIAN
    
    // a function that returns 2 letters that represents a language to the caller, by the chosen language
    func stringValue() -> String
    {
        switch self
        {
            case .HEBREW : return "he"
            case .ENGLISH : return "en"
            case .RUSSIAN : return "ru"
        }
    }
}
