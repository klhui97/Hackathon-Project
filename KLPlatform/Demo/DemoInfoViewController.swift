//
//  DemoInfoViewController.swift
//  KLPlatform
//
//  Created by KL on 7/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class DemoInfoViewController: UIViewController {

    @IBOutlet var website: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var nextPage: UITextView!
    
    @objc func nextAction(){
        let vc = DemoInfo2ViewController()
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Solution"
    }
    
    @objc func webAction(){
        UIApplication.shared.open(URL(string : "https://e-services.judiciary.hk/appt_book/LBAppBookIntro.jsp?lang=EN")!, options: [:], completionHandler: { (status) in
            
        })
    }
    
    @objc func phoneAction(){
        if let url = URL(string: "tel://26250056"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(nextAction))
        nextPage.isUserInteractionEnabled = true
        nextPage.addGestureRecognizer(tap)
        
        let web = UITapGestureRecognizer(target: self, action: #selector(webAction))
        website.isUserInteractionEnabled = true
        website.addGestureRecognizer(web)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(phoneAction))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(phoneTap)
    }
}
