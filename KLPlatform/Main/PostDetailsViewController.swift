//
//  PostDetailsViewController.swift
//  KLPlatform
//
//  Created by KL on 24/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
  
  @IBOutlet var titleLbl: UILabel!
  @IBOutlet var dateLbl: UILabel!
  @IBOutlet var ownerNameLbl: UILabel!
  @IBOutlet var contentLbl: UILabel!
  
  var data: PostDataModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let post = data{
      titleLbl.text = post.title
      dateLbl.text = post.createdDate
      ownerNameLbl.text = post.ownerName
      contentLbl.text = post.body
    }
  }
}
