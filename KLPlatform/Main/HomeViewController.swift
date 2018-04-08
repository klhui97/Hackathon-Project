//
//  HomeViewController.swift
//  KLPlatform
//
//  Created by KL on 17/3/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import UIKit
import Firebase
import TesseractOCR

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var sideView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var menuBtn: UIBarButtonItem!
    
    var announceData: [PostDataModel] = []
    var postData: [PostDataModel] = []
    
    // MARK: - Function
    private func setUpTableView(){
        let stringColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTableViewAction), for: .valueChanged)
        tableView.refreshControl?.tintColor = stringColor
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Loading", attributes: [NSAttributedStringKey.foregroundColor : stringColor])
        tableView.becomeFirstResponder()
    }
    
    private func fetchPost(){
        Firestore.firestore().collection("Posts").order(by: "createdTime", descending: true).limit(to: 30).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.postData = []
                self.tableView.reloadData()
                for document in querySnapshot!.documents {
                    self.postData.append(PostDataModel(snapShot: document))
                }
            }
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        }
    }
    
    private func subscribeSystemMessage(){
        let dbSystemPost = Firestore.firestore().collection("SystemPosts")
        dbSystemPost.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            
            self.announceData = []
            for document in snapshot.documents {
                self.announceData.append(PostDataModel(snapShot: document))
            }
            
            if self.segmentControl.selectedSegmentIndex == 0{
                self.tableView.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            return announceData.count
        case 1:
            return postData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell") as! PostListViewCell
        cell.typeLbl.layer.borderWidth = 2.0
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            cell.nameLbl.text = announceData[indexPath.row].ownerName
            cell.titleLbl.text = announceData[indexPath.row].title
            cell.titleLbl.sizeToFit()
            cell.typeLbl.text = announceData[indexPath.row].type
            return cell
        case 1:
            cell.nameLbl.text = postData[indexPath.row].ownerName
            cell.titleLbl.text = postData[indexPath.row].title
            cell.titleLbl.sizeToFit()
            cell.typeLbl.text = postData[indexPath.row].type
            return cell
        default:
            return cell
        }
    }
    
    // MARK: - Table View Click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Post details") as! PostDetailsViewController
            
            vc.data = announceData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Post details") as! PostDetailsViewController
            
            vc.data = postData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    // MARK: - Action
    
    @IBAction func demoBtn(_ sender: Any) {
        let vc = Demo1ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func chatBotV2Btn(_ sender: Any) {
        let chatView = DLchatbotViewController()
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        self.present(chatNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func ocr2Action(_ sender: Any) {
        let vc = OCRViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func userListBtn(_ sender: Any) {
        let vc = UserListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func freeServiceBtn(_ sender: Any) {
        let vc = UserListViewController()
        var sampleData: [AccountDataModel] = []
        sampleData.append(AccountDataModel(name: "The Duty Lawyer Service", type: "Family, Land, Criminal and Employment, etc.", contact: "2522 8018", intro: "The Duty Lawyer Service has a Tel-Law Scheme which provides recorded legal information, in Cantonese, Putonghua and English, on a wide range of legal topics over the telephone. The tapes only provide a brief introduction on the particular legal topic. If you intend to initiate legal action, you should first consult a solicitor.\nThe Tel-Law Scheme is a fully computerized system and operates 24 hours a day. The telephone numbers of the Scheme are 2521 3333 and 2522 8018.", email: "", address: "Suites 808-9 Harcourt House, 39 Gloucester Road, Wanchai, Hong Kong", region: "Wanchai"))
        sampleData.append(AccountDataModel(name: "Brenda Chark & Co.", type: "Arbitration, Company, Employment Law etc.", contact: "3590 5620", intro: "Brenda Chark & Co has an outstanding reputation for its extensive knowledge in the technical, practical and legal aspects of maritime and shipping practice. The Founder Brenda Chark leads a team who are committed to excellence and prepared to work round the clock to achieve clients commercial objectives, with an eye for legal strategies.\nBrenda has regularly advised international insurance companies on regulatory matters and has successfully assisted overseas clients with obtaining authorisation to provide compulsory insurance cover in Hong Kong.\nBrenda has also substantial experience in handing both litigation and arbitration in Hong Kong and England. Brenda also monitors proceedings overseas, notably in the US, Singapore and South Africa. She works closely with lawyers around the world, for instance, to ascertain the risk of threatened arrest of vessels and secure the release of clients vessels.\nAlthough lawyers in Hong Kong are divided into barristers and solicitors, Brenda regularly handles legal  and arbitral hearings and has successfully pursued or defended legal and arbitral proceedings. We also work closely with overseas lawyers to protect and advance our clients interests.", email: "brenda@brendachark.com", address: "9E&F, CNT TOWER, 338 HENNESSY ROAD, WANCHAI, HONG KONG", region: "Wanchai"))
        sampleData.append(AccountDataModel(name: "C.L.Chow & Macksion Chan", type: "Notarial Services, Trusts, Family Planning, etc.", contact: "28107979", intro: "Our law firm is based in Hong Kong. We have vast experience in cross-border legal works. Our areas of practice include: litigation, arbitration and mediation; commercial work; merger and acquisition; securities and capital market; investment fund; conveyancing; banking law; international trade; housing development, construction law, mining and energy law.\nWe have strong presence in Greater China and broad international network. In China, we have a representative office in Guangzhou, and we are in associations with leading law firms in China. In terms of our international network, we also have closing working relationships with law firms in Taiwan, Singapore, U.K., Australia, New Zealand, U.S., British Virgin Islands, Cayman Islands, and Jersey.", email: "clchow@clcmc.com.hk", address: "3/F, ALLIANCE BUILDING, 130-136 CONNAUGHT ROAD CENTRAL, HONG KONG", region: "Central"))

        vc.displayOrgList(data: sampleData)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ocrAction(_ sender: Any) {
        let vc = CameraOCRViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if (menuLeadingConstraint.constant == 0){
            menuLeadingConstraint.constant = -180
        }else{
            menuLeadingConstraint.constant = 0
        }
    }
    
    @IBAction func segmentOnClick(_ sender: Any) {
        self.menuLeadingConstraint.constant = -180
        switch self.segmentControl.selectedSegmentIndex {
        case 0:
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        case 1:
            fetchPost()
        default:
            return
        }
    }
    
    
    @IBAction func refreshBtnAction(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 1{
            fetchPost()
        }
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) { // swipe action
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if (translation > 50){ // swipe left
                if self.menuLeadingConstraint.constant < 0{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.menuLeadingConstraint.constant = 0
                        self.view.layoutIfNeeded()
                    })
                }
            }else if (translation < 50){ // swipe right
                if self.menuLeadingConstraint.constant > -180 { // menu is showing
                    UIView.animate(withDuration: 0.5, animations: {
                        self.menuLeadingConstraint.constant = -180
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    @objc func refreshTableViewAction(){
        tableView.refreshControl?.endRefreshing()
        if self.segmentControl.selectedSegmentIndex == 1{
            fetchPost()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidDisappear(_ animated: Bool) {
        self.menuLeadingConstraint.constant = -180
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        subscribeSystemMessage()
        blurView.layer.cornerRadius = 15
        menuBtn.accessibilityLabel = "Menu button"
    }

}
