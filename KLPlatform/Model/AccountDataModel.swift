//
//  AccountDataModel.swift
//  KLPlatform
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import Foundation
import Firebase

class AccountDataModel{
  
  // MARK: - Variable
  var name: String? = " "
  var type: String? = " "
  var contact: String? = " "
  var introduction: String? = " "
  var email: String? = " "
  var address: String? = " "
  var region: String? = " "
  
  init(){
    
  }
  
  init(name: String, type: String, contact: String, intro: String, email: String, address: String, region: String){
    self.name = name
    self.type = type
    self.contact = contact
    self.introduction = intro
    self.email = email
    self.address = address
    self.region = region
  }
  
  init(snapShot: DocumentSnapshot){
    name = snapShot.data()!["name"] as? String
    type = snapShot.data()!["type"] as? String
    contact = snapShot.data()!["contact"] as? String
    introduction = snapShot.data()!["introduction"] as? String
    email = snapShot.data()!["email"] as? String
    address = snapShot.data()!["address"] as? String
    region = snapShot.data()!["region"] as? String
  }
  
  func encodeFireBaseData(data: [String : Any], completion: (_ result: Bool)->()){
    name = data["name"] as? String
    type = data["type"] as? String
    contact = data["contact"] as? String
    introduction = data["introduction"] as? String
    email = data["email"] as? String
    address = data["address"] as? String
    region = data["region"] as? String
    completion(true)
  }
}
