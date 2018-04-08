//
//  SettingTableViewController.swift
//  KLPlatform
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell") as! SettingViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.titleLbl.text = "Conversation between two people"
                break
            case 1:
                cell.titleLbl.text = "Group Conversation"
                break
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.titleLbl.text = "Settings"
                break
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Examples"
        case 1:
            return "Options"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Copyright © 2015\nJesse Squires\nMIT License"
        case 1:
            return "Thanks to all the contributers and MacMeDan for this swift example."
        default:
            return nil
        }
    }
    
    //Mark: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return
            case 1:
                return
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0:
                // 3
                return
            default:
                return
            }
        default:
            return
        }
    }

}
