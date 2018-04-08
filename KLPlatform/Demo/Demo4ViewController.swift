//
//  Demo4ViewController.swift
//  KLPlatform
//
//  Created by KL on 6/4/2018.
//  Copyright © 2018 KL. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import ApiAI
import AVFoundation


class Demo4ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    var outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
    let speechSynthesizer = AVSpeechSynthesizer()
    var isMute = false
    var suggestions: [String] = []
    let VIEWHEIGHT: CGFloat = 50
    
    // MARK: - Suggestion
    func showSuggestinoKeyword(){
        let viewWidth = self.view.bounds.width
        let buttonHeight: CGFloat = VIEWHEIGHT - 20
        let buttonWidth = (self.view.bounds.width - 40)/3
        
        view.viewWithTag(100)?.removeFromSuperview()
        let selectableView = UIView(frame: CGRect(x: 0, y: self.inputToolbar.frame.origin.y - VIEWHEIGHT, width: viewWidth, height: VIEWHEIGHT))
        var tmpX: CGFloat = 10
        selectableView.tag = 100
        
        for suggestion in suggestions{
            let button = RoundButton(frame: CGRect(x: tmpX, y: 10, width: buttonWidth, height: buttonHeight))
            button.setTitle(suggestion, for: .normal)
            button.addTarget(self, action:#selector(sendSuggestionChat), for: .touchUpInside)
            selectableView.addSubview(button)
            tmpX += 10 + buttonWidth
        }
        
        self.view.addSubview(selectableView)
    }
    
    @objc func sendSuggestionChat(sender:UIButton!) {
        view.viewWithTag(100)?.removeFromSuperview()
        let body = sender.titleLabel?.text
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: body)
        messages.append(message!)
        finishSendingMessage()
        passMessageToBot(body: body!)
    }
    
    // MARK: - Speech to Text Function
    func speechAndText(text: String) {
        if !isMute{
            let speechUtterance = AVSpeechUtterance(string: text)
            if NLP.determineLanguage(for: text) == "zh-Hant"{
                speechUtterance.voice  = AVSpeechSynthesisVoice(language: "zh-HK") //usg chinese
            }
            speechSynthesizer.speak(speechUtterance)
        }
    }
    
    // MARK: - Diaglog Flow Api
    func passMessageToBot(body: String){
        let request = ApiAI.shared().textRequest()
        request?.query = body
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            //print(response.result.fulfillment.messages[0]) // return the whole response
            let textResponse = response.result.fulfillment.messages[0]["speech"] as! String
            if textResponse == "Maybe you try to type a single key word?"{
                self.showSuggestinoKeyword()
            }
            self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: textResponse))
            self.finishSendingMessage()
            self.speechAndText(text: textResponse)
        }, failure: { (request, error) in
            print(error!)
        })
        ApiAI.shared().enqueue(request)
    }
    
    // MARK: - Override setting
    override func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollToBottom(animated: true)
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        if view.viewWithTag(100) != nil{
            self.showSuggestinoKeyword()
        }
    }
    
    override func finishSendingMessage() {
        super.finishSendingMessage()
        self.scrollToBottom(animated: true)
    }
    
    // MARK: - Input tool bar button
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: text))
        messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Okay. Got it. Just a moment! I am producing your documents and your forms."))
        self.finishSendingMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = Demo6ViewController()
            self.navigationItem.title = "Back"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        
        let sheet = UIAlertController(title: "More fuction", message: nil, preferredStyle: .actionSheet)
        let translateAction = UIAlertAction(title: "中文翻譯", style: .default) { (action) in
            let lastMessageIndex = self.messages.count - 1
            GoogleTranslateAPI.requestTranslation(target: "zh-TW", textToTranslate: self.messages[self.messages.count - 1].text) { (success, result) in
                self.messages.append(JSQMessage(senderId: self.messages[lastMessageIndex].senderId, displayName: self.messages[lastMessageIndex].senderDisplayName, text: result))
                self.finishSendingMessage()
                self.speechAndText(text: result)
            }
            self.scrollToBottom(animated: true)
        }
        let suggestAction = UIAlertAction(title: "Suggestion", style: .default) { (action) in
            self.suggestions = NLP.getThreeRandomNonRepeatedKeyword()
            self.showSuggestinoKeyword()
            self.scrollToBottom(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) in
            self.scrollToBottom(animated: true)
        }
        sheet.addAction(translateAction)
        sheet.addAction(suggestAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func appendFakeMessage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Hi I am Larry. To fill in the rest of the form I will have to ask you some questions."))
            self.finishSendingMessage()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Hi I am Larry. To fill in the rest of the form I will have to ask you some questions."))
                self.finishSendingMessage()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Are you an employee or employer?"))
                    self.finishSendingMessage()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "Employee"))
                        self.finishSendingMessage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "When did you stop working for your employer?"))
                            self.finishSendingMessage()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "8 April 2018"))
                                self.finishSendingMessage()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Did you receive advance notice from your employer?"))
                                    self.finishSendingMessage()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "no"))
                                        self.finishSendingMessage()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Did your employer explain why you were dismissed?"))
                                            self.finishSendingMessage()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "yes"))
                                                self.finishSendingMessage()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "I made a report to HR about a sexual harassment act I saw in the office. Management said I should mind my own business and told me to resign. I refused to resign, my boss terminated my contract."))
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "When did you report?"))
                                                        self.finishSendingMessage()
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            self.messages.append(JSQMessage(senderId: "UserId", displayName: "UserId", text: "In March."))
                                                            self.finishSendingMessage()
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                self.messages.append(JSQMessage(senderId: "bot", displayName: "bot", text: "Okay. Do you have any other question?"))
                                                                self.finishSendingMessage()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = "UserId"
        self.senderDisplayName = "UserId"
        
        // Navigation item
        setupNavigationBar()
        
        // Register footer in the collection view
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        self.collectionView.delegate = self
        
        /// View Controll Setting
        self.collectionView.contentInsetAdjustmentBehavior = .never
        collectionView?.collectionViewLayout.springinessEnabled = false
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appendFakeMessage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.inputToolbar.contentView.textView.endEditing(true)
    }
    
    // MARK: - Navigation bar
    func setupNavigationBar() {
        navigationItem.title = "[Last]: Chat with Larry"
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        let button = UIBarButtonItem(image: UIImage(named: "mute"), style: .plain, target: self, action: #selector(muteButtonPressed))
        button.accessibilityLabel = "Disable play reply message automatically"
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func backButtonTapped() {
        self.inputToolbar.contentView.textView.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @objc func muteButtonPressed(_ sender: UIBarButtonItem) {
        if isMute{
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "mute")
            self.navigationItem.rightBarButtonItem?.accessibilityLabel = "Enable play reply message automatically"
            isMute = false
        }else{
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "notmute")
            self.navigationItem.rightBarButtonItem?.accessibilityLabel = "Disable play reply message automatically"
            isMute = true
        }
    }
    
    // MARK: - JSQMessage View Controll
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        if (messages[indexPath.row].senderId == self.senderId){
            return JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: UIImage(named:"avatar_user")!, diameter: 100)
        }
        return JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: UIImage(named:"avatar_bot")!, diameter: 100)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        
        return reusableView
    }
    
}
