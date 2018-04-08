//
//  Demo5ViewController.swift
//  KLPlatform
//
//  Created by KL on 7/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class Demo5ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @objc func confirmAction(){
        let vc = Demo4ViewController()
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Review"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmAction))
        self.navigationItem.rightBarButtonItem = btn
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height*2 - 250)
    }

}
