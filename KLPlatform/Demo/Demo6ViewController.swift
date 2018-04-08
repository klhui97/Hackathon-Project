//
//  Demo6ViewController.swift
//  KLPlatform
//
//  Created by KL on 7/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import WebKit

class Demo6ViewController: UIViewController {

    @IBOutlet var website: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var pdf1: UILabel!
    @IBOutlet var pdf2: UILabel!
    @IBOutlet var location: UILabel!
    
    @objc func webAction(){
        UIApplication.shared.open(URL(string : "http://www.judiciary.hk/en/others/contactus.htm")!, options: [:], completionHandler: { (status) in
        })
    }
    
    @objc func phoneAction(){
        if let url = URL(string: "tel://28690869"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func locationAction(){
        let vc = MapViewController()
        vc.destinations = ["12 Harbour Road, Wan Chai, Victoria, Hong Kong Island"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewAction(){
        let vc = pdfViewController()
        vc.dataNum = 1
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func view2Action(){
        let vc = pdfViewController()
        vc.dataNum = 2
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Finished!"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let web = UITapGestureRecognizer(target: self, action: #selector(webAction))
        website.isUserInteractionEnabled = true
        website.addGestureRecognizer(web)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(phoneAction))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(phoneTap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        pdf1.isUserInteractionEnabled = true
        pdf1.addGestureRecognizer(viewTap)
        
        let view2Tap = UITapGestureRecognizer(target: self, action: #selector(view2Action))
        pdf2.isUserInteractionEnabled = true
        pdf2.addGestureRecognizer(view2Tap)
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(locationAction))
        location.isUserInteractionEnabled = true
        location.addGestureRecognizer(locationTap)
    }

}
