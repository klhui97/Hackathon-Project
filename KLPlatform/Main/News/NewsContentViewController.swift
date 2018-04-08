//
//  NewsContentViewController.swift
//  KLPlatform
//
//  Created by KL on 22/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var contentLBl: UILabel!
    @IBOutlet var publishDateLbl: UILabel!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    var data: newsData?
    
    func getImage(urlstring: String){
        guard let url = URL(string: urlstring) else {
            print("Cannot create url")
            return
        }
        
        print(urlstring)
        let session = URLSession.shared
        
        let getImageFromUrl = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error Occurred: \(e)")
                
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.loadingView.stopAnimating()
                            self.imageView.image = image
                        }
                    } else {
                        print("Image file is currupted")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        getImageFromUrl.resume()
    }
    
    @IBAction func readMoreAction(_ sender: Any) {
        let url = URL(string: (data?.url)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getImage(urlstring: (data?.img)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = data?.title
        contentLBl.text = data?.content
        publishDateLbl.text = data?.publishedAt
    }
}
