//
//  PostDataModel.swift
//  KLPlatform
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import Foundation
import Firebase

class PostDataModel{
  
  // MARK: - Variable
  var owner: String!
  var ownerName: String!
  var createdTime: NSNumber!
  var body: String!
  var title: String!
  var isSolved: Bool!
  var type: String!
  var view: Int!
  var createdDate: String!
  
  // MARK: - init
  init(title: String, content: String, type: String){
    owner = Auth.auth().currentUser?.uid
    ownerName = UserDefaults.standard.string(forKey: "userName")
    createdTime = NSDate().timeIntervalSince1970 as NSNumber
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    createdDate = formatter.string(from: date)
    body = content
    self.title = title
    isSolved = false
    self.type = type
    view = 0
  }
  
  init(snapShot: DocumentSnapshot){
    owner = snapShot.data()!["owner"] as? String
    createdTime = snapShot.data()!["createdTime"] as? NSNumber
    body = snapShot.data()!["body"] as? String
    title = snapShot.data()!["title"] as? String
    isSolved = snapShot.data()!["isSolved"] as? Bool
    type = snapShot.data()!["type"] as? String
    view = snapShot.data()!["view"] as? Int
    createdDate = snapShot.data()!["createdDate"] as? String
    ownerName = snapShot.data()!["ownerName"] as? String
  }
  
  func toAnyObject() -> [String: Any] {
    return ["owner": owner, "ownerName": ownerName, "createdTime": createdTime, "body": body , "title": title, "isSolved": isSolved, "type": type, "view": view, "createdDate": createdDate]
  }
}
