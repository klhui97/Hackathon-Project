//
//  NewsViewController.swift
//  KLPlatform
//
//  Created by KL on 21/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var tableView: UITableView!
  var result: [newsData] = []
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    result = []
    self.tableView.reloadData()
    searchBar.resignFirstResponder()
    let model = GoogleNewsModel(keyword: searchBar.text!, from: "2018-03-20")
    model.fetchData { (success) in
      if (success){
        self.result = model.news
        DispatchQueue.main.async {
          let range = NSMakeRange(0, self.tableView.numberOfSections)
          let sections = NSIndexSet(indexesIn: range)
          self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        }
        print("reloaded")
      }else{
        print("fail")
      }
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  // MARK: - Table view data source
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return result.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
    cell.titleLbl.text = result[indexPath.row].title
    cell.titleLbl.sizeToFit()
    cell.dateLbl.text = result[indexPath.row].publishedAt
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    let vc = NewsContentViewController()
    vc.data = result[indexPath.row]
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    searchBar.becomeFirstResponder()
  }
  
}
