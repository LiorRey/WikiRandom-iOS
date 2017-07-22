//
//  WikiConnectionManager.swift
//  WikiRandom
//
//  Created by Team Hurrange on 20/04/2017.
//  Copyright © 2017 WikiRandom inc. All rights reserved.
//

import UIKit
import Alamofire

class WikiConnectionManager: NSObject
{
    static let manager = WikiConnectionManager()
    
    // this method responsible for genrating 4 results/articles from the Wikipedia Database
    func generateResults(lang : String, count : Int = 4,completion : @escaping ([WikiResult]) -> Void)
    {
        var arr : [WikiResult] = []
        func nextStep()
        {
            if arr.count == count
            {
                completion(arr)
                return
            }
            
            self.showRandomArticle(lang: lang) { (result) in
                guard let result = result else
                {
                    completion(arr)
                    return
                }
                
                arr.append(result)
                nextStep()
            }
        }
        
        nextStep()
    }
    
    // this method is reponsible for getting each of the result/article from Wikipedia Database
    private func showRandomArticle(lang : String, completion : @escaping (WikiResult?)->Void)
    {
        // the rest of the url that we use in the requset(his parameters as a Dictionary)
        let dict : [String:Any] = [
            "action":"query",
            "generator":"random",
            "grnnamespace":0,
            "indexpageids":"",
            "prop":"pageimages|categories|info",
            "inprop":"url",
            "pithumbsize":1000,
            "format":"json"
        ]
        
        // the base url of the wikipedia api
        let urlString = "https://\(lang).wikipedia.org/w/api.php"
        // the http request for the JSON format of each random wikipedia article(using Alamofire)
        Alamofire.request(urlString, method: .get, parameters: dict).responseJSON { (res) in
            
            // a "container" for the JSON file that we retrived
            guard let json = res.result.value as? [String:Any] else
            {
                return
            }
            
            // the quering of json file
            guard let query = json["query"] as? [String:Any],
                let pages = query["pages"] as? [String:[String:Any]],
                let pair = pages.first else
            {
                    return
            }
            
            let result = WikiResult(id: pair.key, dict: pair.value)
            
            completion(result)
        }
    }
}
