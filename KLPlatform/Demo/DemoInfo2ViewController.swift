//
//  DemoInfo2ViewController.swift
//  KLPlatform
//
//  Created by KL on 7/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class DemoInfo2ViewController: UIViewController {

    
    @IBOutlet var phone: UILabel!
    @IBOutlet var address: UILabel!
    
    @objc func addressAction(){
        let vc = MapViewController()
        vc.destinations = ["10/F, Cheung Sha Wan Government Offices, 303 Cheung Sha Wan Road, Kowloon"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func phoneAction(){
        if let url = URL(string: "tel://29278000"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "MECAB claim"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(phoneAction))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(phoneTap)
        
        let addressTap = UITapGestureRecognizer(target: self, action: #selector(addressAction))
        address.isUserInteractionEnabled = true
        address.addGestureRecognizer(addressTap)
    }
}
