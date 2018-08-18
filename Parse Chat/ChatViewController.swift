//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Teran on 8/17/18.
//  Copyright © 2018 Brandon Teran. All rights reserved.
//

import UIKit
import Parse


class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var messages: [PFObject] = []
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if messageTextField.text != "" {
            let message = PFObject(className: "Message")
            message["text"] = messageTextField.text
            message["user"] = PFUser.current()
            message.saveInBackground(block: {(success: Bool?, error: Error?) in
                if success == true {
                    print ("message sent")
                }
                else {
                    print ("message not sent")
                }
            })
        }
    }
    
    
    @objc func onTimer() {
        let query = PFQuery(className: "Message")
        query.whereKeyExists("text").includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                self.messages = objects!
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.messages = (self.messages[indexPath.row])
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
