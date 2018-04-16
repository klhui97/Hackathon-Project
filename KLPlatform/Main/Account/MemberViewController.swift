//
//  MemberViewController.swift
//  ChatDemoKL
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import Firebase

class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var nameLbl: UILabel!
  @IBOutlet var typeLbl: UILabel!
  @IBOutlet var contactLbl: UILabel!
  @IBOutlet var introTableView: UITableView!
  
  // MARK: - Confige
  var acData = AccountDataModel()
  let dbMember = Firestore.firestore().collection("Members").document((Auth.auth().currentUser?.uid)!)
  
  // MARK: - Action
  @IBAction func signOutAction(_ sender: Any) {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      
      let login = self.storyboard?.instantiateViewController(withIdentifier: "Login View") as! LoginViewController
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.window?.rootViewController = login
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  
  
  // MARK: - Function
  func listenMemberInfo(){
    dbMember.addSnapshotListener { (querySnapshot, error) in
      guard let snapshot = querySnapshot else {
        print("Error retreiving snapshot: \(error!)")
        return
      }
      print("MemberInfo updated")
      self.acData.encodeFireBaseData(data: snapshot.data()!, completion: { (_) in
        self.nameLbl.text = self.acData.name
        UserDefaults.standard.setValue(self.acData.name, forKey: "userName")
        self.typeLbl.text = self.acData.type
        self.contactLbl.text = self.acData.contact
        self.introTableView.reloadData()
      })
    }
  }
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    switch section {
    case 0:
      return "Introduction"
    case 1:
      return "Email & Address"
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    switch section {
    case 1:
      return " "
    default:
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Intro Cell") as! IntroViewCell
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = self.acData.introduction
      cell.textLabel?.sizeToFit()
      return cell
    case 1:
      if let email = self.acData.email, let address = self.acData.address {
        cell.textLabel?.text = email + "\n" + address
      }
      return cell
    default:
      return cell
    }
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    listenMemberInfo()
  }
}
