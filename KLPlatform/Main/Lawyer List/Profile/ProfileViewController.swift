//
//  ProfileViewController.swift
//  KLPlatform
//
//  Created by KL on 30/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import MessageUI

class ProfileViewController: UIViewController {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var introLbl: UITextView!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    var data: AccountDataModel?
    
    @objc func callAction(sender:UITapGestureRecognizer) {
        if let num = phoneLbl.text{
            if let url = URL(string: "tel://\(num)!"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func showMapAction(sender:UITapGestureRecognizer) {
        let vc = MapViewController()
        if let address = self.data?.address{
            vc.destinations = [address]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func emailAction(sender:UITapGestureRecognizer) {
        // Check if the device is capable to send email
        guard MFMailComposeViewController.canSendMail() else {
            print("This device doesn't allow you to send mail.")
            return
        }
        
        let email: String = emailLbl.text!
        let toRecipients = [email]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.navigationController?.title = "Email to \(nameLbl.text!)"
        mailComposer.setToRecipients(toRecipients)
        

        present(mailComposer, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        introLbl.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = data?.name
        typeLbl.text = data?.type
        phoneLbl.text = data?.contact
        introLbl.text = data?.introduction
        emailLbl.text = data?.email
        addressLbl.text = data?.address
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(callAction))
        phoneLbl.isUserInteractionEnabled = true
        phoneLbl.addGestureRecognizer(tap)
        
        let addresstap = UITapGestureRecognizer(target: self, action: #selector(showMapAction))
        addressLbl.isUserInteractionEnabled = true
        addressLbl.addGestureRecognizer(addresstap)
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(emailAction))
        emailLbl.isUserInteractionEnabled = true
        emailLbl.addGestureRecognizer(emailTap)
        
    }
}

extension ProfileViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Failed to send: \(error?.localizedDescription ?? "")")
        }
        
        dismiss(animated: true, completion: nil)
    }
}
