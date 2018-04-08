//
//  LoginViewController.swift
//  honework
//
//  Created by KL on 19/1/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var saveEmailSwitch: UISwitch!
    
    // MARK: - Action
    @IBAction func savePasswordAction(_ sender: Any) {
        if saveEmailSwitch.isOn{
            saveEmailSwitch.isOn = false
        }else{
            saveEmailSwitch.isOn = true
        }
    }
    
    @IBAction func resetPwAction(_ sender: Any) {
        resetPassword()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        loading.startAnimating()
        
        if saveEmailSwitch.isOn{
            UserDefaults.standard.set(emailTxt.text!, forKey: "email")
            UserDefaults.standard.set(true, forKey: "shouldSaveEmail")
        }else{
            UserDefaults.standard.set(false, forKey: "shouldSaveEmail")
        }

        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
            if error == nil {
                print("login success")
                self.login()
            }else{
                self.loading.stopAnimating()
                self.presentAlert(title: "Fail", message: "Wrong email or password")
            }
        }
    }
    
    // MARK: - Function
    func registerAccount(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if (error != nil){
                print("error")
                return
            }else{
                print("success")
            }
        }
    }
    
    func login(){
        self.loading.stopAnimating()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main Navi")
        self.present(vc!, animated: true)
    }
    
    func resetPassword(){
        let alertController = UIAlertController(title: "Reset password", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            self.loading.startAnimating()
            Auth.auth().sendPasswordReset(withEmail: (alertController.textFields?[0].text)!, completion: { (error) in
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error"
                    message = "Please try again！"
                } else {
                    title = "Done"
                    message = "Password reset link has been sent to your email."
                }
                self.loading.stopAnimating()
                self.presentAlert(title: title, message: message)
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "example@abc.com"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func quickLogin(){
        if (Auth.auth().currentUser != nil){
            login()
        }
    }
    
    func presentAlert(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Enter", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadSavedEmail(){
        if UserDefaults.standard.bool(forKey: "shouldSaveEmail"){
            saveEmailSwitch.isOn = true
            if let email = UserDefaults.standard.string(forKey: "email"){
                emailTxt.text = email
            }
        }else{
            saveEmailSwitch.isOn = false
        }
    }
    
    // MARK: - View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTxt) {
            passwordTxt.becomeFirstResponder()
        }else{
            textField.endEditing(true)
        }
        
        return true
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedEmail()
        emailTxt.delegate = self
        passwordTxt.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        quickLogin()
    }
    
}
