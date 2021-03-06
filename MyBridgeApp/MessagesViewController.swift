//
//  MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

var singleMessageTitle = "Message"
var messageId = String()
//var messageID =

//Change to MessagesTableViewController so other can be MessageViewController
class MessagesViewController: UITableViewController {
    
    var emails = [String]()
    var images = [UIImage]()
    
    //need to combine these into a dictionary
    var names = [[String]]()
    var IDsOfMessages = [String]()
    
    @IBAction func segueToBridgeViewController(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    func updateMessagesTable() {
        
        //messages users_in_message are displayed in box, when clicked, open message with SingleMessages MessageId = Messages ObjectId
        
        let query: PFQuery = PFQuery(className: "Messages")
        
        query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
        query.orderByDescending("updatedAt")
        
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            
            if let error = error {
                
                print(error)
                
            } else if let results = results {
                
                for result in results{
                    
                    self.names.append(result["names_in_message"] as! [String])
                    self.IDsOfMessages.append(result.objectId!)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableView.reloadData()
                    
                })
                
            }
            
            
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this should only update when a new message is created**
        //shouldn't be reloading the table more than once per viewDidLoad
        
        self.updateMessagesTable()
        
        /*if segueFromExitedMessage == true {
            
            IDsOfMessages.removeFirst()
            names.removeFirst()
            
            print("ids")
            print(IDsOfMessages)
            print("names")
            print(names)
            
            segueFromExitedMessage = false
            
            tableView.reloadData()
            
            
            
        }*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return IDsOfMessages.count
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        var stringOfNames = ""
        
        /*for (key, value) in users[indexPath.row] {
            
            stringOfNames = stringOfNames + value + " ,"
            
        }*/
        
        //take out 0th object if exitedMessage is true and turn it to false at the end
            
        for name in names[indexPath.row] {
        
            //add & between last two users - currently adds & only when there are two users
            
            if names[indexPath.row].count == 3 {
                    
                if name != PFUser.currentUser()?["name"] as? String {
                        
                    stringOfNames = stringOfNames + name + " & "
                        
                }
                    
            } else if name != PFUser.currentUser()?["name"] as? String {
                    
                stringOfNames = stringOfNames + name + ", "
                    
            }
                
        }
        
        stringOfNames = String(stringOfNames.characters.dropLast())
        stringOfNames = String(stringOfNames.characters.dropLast())
        
        cell.textLabel?.text = stringOfNames
        //set message cell labels to names of other users in message, timestamp of last sent message or otherwise of creation, and preview of text of last sent message
        //namesLabel.text = stringOfNames
        //timestampLabel.text = 
        //messagePreviewLabel.text =

        /*if images.count > indexPath.row {
            
            cell.imageView?.image = images[indexPath.row]
            
        }*/

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        singleMessageTitle = (currentCell.textLabel?.text)!
        messageId = IDsOfMessages[indexPath.row]
        
        previousViewController = "MessagesViewController"
        //messageId =
        
        //print(singleMessageTitle)
        /*if let cellText = cell.textLabel?.text {
            
            print(cellText)
            
            singleMessageTitle = cellText
            
        }*/
        
        performSegueWithIdentifier("showSingleMessageFromMessages", sender: self)
    

        
        //opening email to send mail
        /*let url = NSURL(string: "mailto:" + emails[indexPath.row])
        
        UIApplication.sharedApplication().openURL(url!)
        
        print(url!)*/
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
