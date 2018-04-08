//
//  Demo3ViewController.swift
//  KLPlatform
//
//  Created by KL on 6/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class Demo3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var sortedBy: UILabel!
    
    let data = ["My boss is not paying me", "I have been fired",  "I want to dismiss my staff", "I want to quit", "I hurt myself at work", "I have no holiday", "Can I work in Hong Kong?" , "My colleagues are racist", "I am under arrest", "I have been charged with a crime", "my landlord won’t return my deposit", "my tenant has not paid rent", "someone published lies about me", "I bought a broken product and cannot get a refund", "someone owes me money", "Other"]
    let keywordData = ["employment", "employment", "employment", "employment", "employment", "employment", "employment", "discrimination", "criminal", "criminal", "tenancy", "tenancy", "defamation", "consumer", "purely monetary", "all"]

    var memberList: [AccountDataModel] = []
    var filteredMemberList: [AccountDataModel] = []
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        if tableView.indexPathForSelectedRow?.row == 0{
            let vc = DemoInfoViewController()
            self.navigationItem.title = "Back"
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = Demo2ViewController()
            self.navigationItem.title = "Back"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return data.count
        }
        
        if tableView == self.userTableView{
            return filteredMemberList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
            cell.titleLbl.text = data[indexPath.row]
            return cell
        }
        
        let cell = Bundle.main.loadNibNamed("UserListTableViewCell", owner: self, options: nil)?.first as! UserListTableViewCell
        cell.nameLbl.text = filteredMemberList[indexPath.row].name
        cell.typeLbl.text = filteredMemberList[indexPath.row].type
        cell.regionLbl.text = filteredMemberList[indexPath.row].region
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView{
            sortedBy.text = "Ref. Lawyer: \(keywordData[indexPath.row])"
            if keywordData[indexPath.row] == "all"{
                filteredMemberList = memberList
            }else{
                filteredMemberList = memberList.filter({ (ac) -> Bool in
                    let text = keywordData[indexPath.row]
                    return (ac.type?.lowercased().contains(text.lowercased()))!
                })
            }
            let range = NSMakeRange(0, self.userTableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.userTableView.reloadSections(sections as IndexSet, with: .automatic)
        }
        
        if tableView == self.userTableView{
            let vc = ProfileViewController()
            vc.data = memberList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Specify your need"
    }
    
    func createFakeAc(){
        self.memberList.append(AccountDataModel(name: "Mr. Peter Y Y Chan ", type: "employment", contact: "63458766", intro: "employment lawyer for employees, judicial review, human rights", email: "Peterchan@aafirm.com", address: "4503, 45 floor, exchange tower, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Rebecca Yau", type: "employment", contact: "82348345", intro: "employment lawyer, judicial review, contract dispute", email: "Rebeccayau@kann.com", address: "flat 2402, 24 floor, Alliance Building, Sheung Wan", region: "Sheung Wan"))
        
        self.memberList.append(AccountDataModel(name: "Mr. David Peterson ", type: "dispute resolution", contact: "26784567", intro: "family, contract dispute, personal injury", email: "Dpeterson@peterson.com", address: " 4th floor, Landmark, Central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Laurence Pang ", type: "employment", contact: "35768902", intro: "employment lawyer, mediation, contract review", email: "Lpang@cdew.com", address: "Room 234, 2nd floor, wingon house, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Tom Lee ", type: "corporate", contact: "63458766", intro: "syndicated loan, ipo", email: "tomlee@voeux.com", address: "45 floor, gloucester house, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Diana Fan ", type: "general practice", contact: "63458766", intro: "employment, conveyancing, probate, family, tenancy", email: "dfan@chanlaufan.com", address: "room 1202, 12 floor, diner building, wanchai", region: "Wanchai"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Alex Cheung ", type: "family", contact: "63458766", intro: "divorce, custody, probate, will, trust", email: "alexcheung@cheungandco.com", address: "room 123, 12 floor, fullbright tower, mongkok", region: "Kowloon"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Nicole Lee ", type: "immigration", contact: "34782109", intro: "employment dispute, immigration, human rights", email: "nicolelee@.com", address: "flat 2304, 23rd floor, AMK Tower, Tsuen Wan", region: "Tsuen Wan"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Candy Lee ", type: "employment", contact: "23578790", intro: "employment lawyer, contract disputes, pension, administrative law", email: "CandyLee@leeandchan.com", address: "24th floor, alliance building, 130 connaught road, central", region: "Central"))
        
        filteredMemberList = memberList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createFakeAc()
    }

}
