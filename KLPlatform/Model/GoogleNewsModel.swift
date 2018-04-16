//
//  GoogleNewsModel.swift
//  KLPlatform
//
//  Created by KL on 21/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//
//  This model is using News API from https://newsapi.org
//
//

import Foundation
import Alamofire

struct newsData{
  var title: String?
  var publishedAt: String?
  var content: String?
  var url: String?
  var img: String?
}

class GoogleNewsModel{
  
  var news: [newsData] = []
  var keyword: String
  var from: String
  
  init(keyword: String, from: String){
    self.keyword = keyword
    self.from = from
  }
  
  
  func fetchData(completion: @escaping (_ result: Bool)->()){
    // Add URL parameters
    let urlParams = [
      "apiKey": SecretKey.googleNewAPI,
      "q": keyword,
      "from": from,
      "sortBy": "popularity"
    ]
    
    // Fetch Request
    Alamofire.request("https://newsapi.org/v2/everything", parameters: urlParams)
      .validate()
      .responseJSON { (response) in
        if let json = response.result.value as? [String: Any] {
          if let array = json["articles"] as? [[String: Any]] {
            for data in array{
              print(data)
              // Convert Date format to YYYY-MM-DD
              let longDate: String = (data["publishedAt"] as! String)
              let splitDate = longDate.split(separator: "T")
              let date = String(describing: splitDate[0]) as String
              
              if let title = data["title"], let content = data["description"], let url = data["url"], let image = data["urlToImage"]{
                self.news.append(newsData(title: title as? String, publishedAt: date as String, content: (content as! String), url: url as? String, img: image as? String))
              }
              
            }
            completion(true)
          }
        }
        
    }
  }
}
