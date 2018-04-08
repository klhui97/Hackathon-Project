//
//  NewPostViewController.swift
//  KLPlatform
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var bodyTextField: UITextView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    // MARK: - Confige
    let dbMember = Firestore.firestore().collection("Posts")
    
    // MARK: - Action
    @IBAction func sendAction(_ sender: Any) {
        loadingView.startAnimating()
        view.endEditing(true)
        addPost()
    }
    
    // MARK: - Function
    func addPost(){
        // Daata Vaildation
        if let title = titleTextField.text, let content =  bodyTextField.text, let type = typeTextField.text{
            if title.count < 1 || title.count > 60{
                loadingView.stopAnimating()
                presentAlert(title: "Error", message: "Words in title should be between 1 and 60.")
            }else if content.count < 1 || content.count > 300{
                loadingView.stopAnimating()
                presentAlert(title: "Error", message: "Words in content should be between 1 and 40.")
            }else{
                let post = PostDataModel(title: title, content: content, type: type)
                dbMember.addDocument(data: post.toAnyObject()) { (error) in
                    if error != nil{
                        self.presentAlert(title: "Fail to upload", message: "Please try again")
                        return
                    }
                    self.loadingView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func presentAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Enter", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
