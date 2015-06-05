//
//  ViewController.swift
//  GCDTimerExample
//
//  Created by Hemanta Sapkota on 4/06/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import UIKit
import GCDTimer

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stories = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Use Timer
        let timer = GCDTimer(intervalInSecs: 30)
        timer.Event = {
            println("Reloading stories...")
            self.loadStories()
        }
        timer.start()
    }
    
    func loadStories() {
        // Load new HN stories 
        stories.removeAll(keepCapacity: false)
        
        let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
            for (var i = 0; i < 10; i++) {
                let itemUrl = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/\(json[i]).json?print=pretty")
                let itemTask = NSURLSession.sharedSession().dataTaskWithURL(itemUrl!) { (data, response, error) in
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let title = json["title"] as! String
                        self.stories.append(title)
                        self.tableView.reloadData()
                    })
                }
                itemTask.resume()
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController {
    
    class TableViewCell : UITableViewCell {
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        
        cell.textLabel?.text = stories[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}