//
//  UserListViewController.swift
//  KLPlatform
//
//  Created by KL on 30/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import Firebase

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var memberList: [AccountDataModel] = []
    var filterMemberList: [AccountDataModel] = []
    var searchTxt: String?
    var isLawyerMode = true
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == ""{
            filterMemberList = memberList
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        }else{
            self.startFilter()
        }
    }
    
    func startFilter(){
        filterMemberList = memberList.filter({ (ac) -> Bool in
            guard let text = searchBar.text else {return false}
            return (ac.type?.lowercased().contains(text.lowercased()))! || (ac.region?.lowercased().contains(text.lowercased()))! || (ac.name?.lowercased().contains(text.lowercased()))!
        })
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func getMemberData(){
        Firestore.firestore().collection("Members").order(by: "name", descending: true).limit(to: 30).getDocuments() { (querySnapshot, err) in
            if err != nil {
                return
            }else{
                self.memberList = []
                self.tableView.reloadData()
                for document in querySnapshot!.documents {
                    self.memberList.append(AccountDataModel(snapShot: document))
                }
                self.filterMemberList = self.memberList
            }
            
            //////////////////
            // create fake account
            
            //////////////////
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        }
    }
    
    @objc func refreshTableViewAction(){
        tableView.refreshControl?.endRefreshing()
        
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
    
    func tableViewSetup(){
        self.tableView.tableFooterView = UIView()
        let stringColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView.refreshControl = UIRefreshControl()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTableViewAction), for: .valueChanged)
        tableView.refreshControl?.tintColor = stringColor
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Loading", attributes: [NSAttributedStringKey.foregroundColor : stringColor])
        tableView.refreshControl?.beginRefreshing()
        if isLawyerMode{
            self.createFakeAc()
        }else{
            tableView.refreshControl?.endRefreshing()
            self.startFilter()
        }
    }
    
    // MARK: - Table View Data
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLawyerMode{
            return filterMemberList.count
        }else{
            return memberList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("UserListTableViewCell", owner: self, options: nil)?.first as! UserListTableViewCell
        
        if isLawyerMode{
            cell.nameLbl.text = filterMemberList[indexPath.row].name
            cell.typeLbl.text = filterMemberList[indexPath.row].type
            cell.regionLbl.text = filterMemberList[indexPath.row].region
        }else{
            cell.nameLbl.text = memberList[indexPath.row].name
            cell.typeLbl.text = memberList[indexPath.row].type
            cell.regionLbl.text = memberList[indexPath.row].region
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if isLawyerMode{
            let vc = ProfileViewController()
            vc.data = filterMemberList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ProfileViewController()
            vc.data = memberList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func displayOrgList(data: [AccountDataModel]){
        self.isLawyerMode = false
        self.memberList = data
    }
    
    func createFakeAc(){
        self.memberList = []
        self.memberList.append(AccountDataModel(name: "Mr. Peter Y Y Chan ", type: "employment", contact: "63458766", intro: "employment lawyer for employees, judicial review, human rights", email: "Peterchan@aafirm.com", address: "4503, 45 floor, exchange tower, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Rebecca Yau", type: "employment", contact: "82348345", intro: "employment lawyer, judicial review, contract dispute", email: "Rebeccayau@kann.com", address: "flat 2402, 24 floor, Alliance Building, Sheung Wan", region: "Sheung Wan"))
        
        self.memberList.append(AccountDataModel(name: "Mr. David Peterson ", type: "dispute resolution", contact: "26784567", intro: "family, contract dispute, personal injury", email: "Dpeterson@peterson.com", address: " 4th floor, Landmark, Central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Laurence Pang ", type: "employment", contact: "35768902", intro: "employment lawyer, mediation, contract review", email: "Lpang@cdew.com", address: "Room 234, 2nd floor, wingon house, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Tom Lee ", type: "corporate", contact: "63458766", intro: "syndicated loan, ipo", email: "tomlee@voeux.com", address: "45 floor, gloucester house, central", region: "Central"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Diana Fan ", type: "general practice", contact: "63458766", intro: "employment, conveyancing, probate, family, tenancy", email: "dfan@chanlaufan.com", address: "room 1202, 12 floor, diner building, wanchai", region: "Wanchai"))
        
        self.memberList.append(AccountDataModel(name: "Mr. Alex Cheung ", type: "family", contact: "63458766", intro: "divorce, custody, probate, will, trust", email: "alexcheung@cheungandco.com", address: "room 123, 12 floor, fullbright tower, mongkok", region: "Kowloon"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Nicole Lee ", type: "immigration", contact: "34782109", intro: "employment dispute, immigration, human rights", email: "nicolelee@.com", address: "flat 2304, 23rd floor, AMK Tower, Tsuen Wan", region: "Tsuen Wan"))
        
        self.memberList.append(AccountDataModel(name: "Ms. Candy Lee ", type: "employment", contact: "23578790", intro: "employment lawyer, contract disputes, pension, administrative law", email: "CandyLee@leeandchan.com", address: "24th floor, alliance building, 130 connaught road, central", region: "Central"))
        
        self.filterMemberList = memberList
        tableView.refreshControl?.endRefreshing()
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let text = searchTxt{
            searchBar.text = text
        }
        
        if isLawyerMode{
            self.navigationItem.title = "Find lawyer"
        }else{
            self.navigationItem.title = "Find service"
            self.searchBar.isUserInteractionEnabled = false
        }
        tableViewSetup()
    }

}
