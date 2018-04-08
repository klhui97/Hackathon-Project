//
//  pdfViewController.swift
//  KLPlatform
//
//  Created by KL on 7/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import WebKit

class pdfViewController: UIViewController {

    @IBOutlet var pdfView: WKWebView!
    var dataNum = 1
    
    @objc func printAction(){
        let firstActivityItem = "Print"
        let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if dataNum == 1{
            if let pdf = Bundle.main.url(forResource: "sample1", withExtension: "pdf", subdirectory: nil, localization: nil)  {
                let req = NSURLRequest(url: pdf)
                pdfView.isHidden = false
                pdfView.load(req as URLRequest)
                self.navigationItem.title = "pdf1-writ-of-summons"
            }
        }else{
            if let pdf = Bundle.main.url(forResource: "sample2", withExtension: "pdf", subdirectory: nil, localization: nil)  {
                let req = NSURLRequest(url: pdf)
                pdfView.isHidden = false
                pdfView.load(req as URLRequest)
                self.navigationItem.title = "pdf2-acknowledgement-of-servic"
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(printAction))
    }
}
