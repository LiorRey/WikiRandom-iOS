//
//  WikiResult.swift
//  WikiRandom
//
//  Created by Team Hurrange on 20/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit

class WikiResult: NSObject
{
    let id : String
    let categories : [String]
    let fullURL : URL?
    let imageURL : URL?
    
    init(id : String, dict : [String:Any])
    {
        self.id = id
        
        // Parse categories from json
        let rawCategories = dict["categories"] as? [[String:Any]] ?? []
        var arr : [String] = []
        for subDict in rawCategories
        {
            // Parse title from json
            if let title = subDict["title"] as? String
            {
                arr.append(title)
            }
        }
        
        self.categories = arr
        
        // Parse the full url from json
        if let urlString = dict["fullurl"] as? String
        {
            self.fullURL = URL(string: urlString)
        }
        else
        {
            self.fullURL = nil
        }
        
        // Parse the image url as known as "thumbnail" from json
        if let thumbnail = dict["thumbnail"] as? [String:Any],
            let urlString = thumbnail["source"] as? String
        {
            self.imageURL = URL(string: urlString)
        }
        else
        {
            // A defualt image for the webView, in case there is not image releted to the article
            self.imageURL = URL(string: "http://www.s-safety.co.uk/wp-content/uploads/2011/08/question-mark-300x278.jpg")
        }
        
        super.init()
    }
    
    // get a random category from all of the article categories , and return it as a string to the caller
    func randomCategory() -> String
    {
        //generating a random "index" number using the swift native random number method, and the categories array size
        let index = Int(arc4random_uniform(UInt32(categories.count)))
        
        let str = categories[index]
        if let range = str.range(of: ":")
        {
            return str.substring(from: range.upperBound)
        }
        else
        {
            return str
        }
    }
}
