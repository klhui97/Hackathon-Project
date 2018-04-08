//
//  Demo1ViewController.swift
//  KLPlatform
//
//  Created by KL on 6/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class Demo1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var budgetLbl: UILabel!
    @IBOutlet var slider: UISlider!
    let data = ["employment", "criminal", "rental flats", "reputation damage", "consumer interest", "discrimination", "financial loss"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let vc = Demo3ViewController()
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeValue(_ sender: Any) {
        budgetLbl.text = "Budget(per hour): $ \(slider.value)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "A.I. analysis"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slider.value = 500
        budgetLbl.text = "Budget(per hour): $ \(slider.value)"
    }

}
