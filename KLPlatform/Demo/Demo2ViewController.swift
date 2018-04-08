//
//  Demo2ViewController.swift
//  KLPlatform
//
//  Created by KL on 6/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import MobileCoreServices

class Demo2ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var textView: UITextView!
    
    @IBAction func confirmAction(_ sender: Any) {
        let vc = Demo5ViewController()
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipAction(_ sender: Any) {
        let vc = Demo5ViewController()
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        self.present(imagePickerController, animated: true) {
            self.confirmBtn.isHidden = false
            self.textView.text = "Sample Employment Contract (hereinafter This contract of employment is entered into between THE BEST COMPANY LIMITED (hereinafter referred to as 'Employee') referred to as 'Employer') and EM PUN YEE on 8th April 2017 1. Commencement of Employmentt 2. Probation Periodt 3. Position and under the terms and conditions of employment below : Effective from IStMa 2017 until either party terminates the contract. D for a fixed term contract for a period of ending on Z Yes Sales Manager * day(s) /week(s) / month(s)/ year(s), I month(S) 4. 5. 6. 7. 8. 9. Section Employed Registered Address/ Place of work Working Hourst Rest Days Wages (a) wage ratet Termination of Employment Contractt Employee Room 12345, Core F, Cyberport 3, 100 Cyberport Road / 2 IFC, Central, Hon Kon Fixed, at 5 from 9 and O Shift work required, from or days per week, 8 *am+Hto 6 *am/pm to hours per day *am/pm to *am/pm to hours per day *am/pm *am/pm *am/pm On every Sat & Sun , pay day(s) per *week/month, *with / without pay O On rotation, (The employee is entitled to not less than I rest day in every period of 7 days) Basic wages of S 13,000 plus the following allowance(s) : O Meal allowance of S O Travelling allowance of S per O ; per * day / week/ month per * day / week/ month A notice period of an equivalent amount of wages in lieu of notice (notice period not less than 7 days). During the probation period (if applicable) : within the first month : without notice or wages in lieu of notice * day(s)/ week(s)/ month(s) after the first month : a notice period of or an equivalent amount of wages in lieu of notice (notice period not less than 7 days). 2 IC, Residence Bel-air, Cyberport Road, Pok Fu Lam residence address in the clause(s) as appropriate t Please put a * Please delete the vsord(s) as inappropriate (2/2017)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Smart Scan"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
