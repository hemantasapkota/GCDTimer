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
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Use Timer
        let timer = GCDTimer(intervalInSecs: 30)
        timer.Event = {
            print("Reloading stories...")
            self.loadStories()
        }
        timer.start()
    }
    
    func loadStories() {
        // Load new HN stories 
        stories.removeAll(keepingCapacity: false)
        
        let url = NSURL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty")
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if data == nil {
                print("\(error)")
                return
            }

            let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
            for var i in (0..<10) {
                let itemUrl = NSURL(string: "https://hacker-news.firebaseio.com/v0/item/\(json[i]).json?print=pretty")
                print("\(itemUrl)")
                let itemTask = URLSession.shared.dataTask(with: itemUrl! as URL) { (data, response, error) in
                    let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    DispatchQueue.main.async {
                        let title = json["title"] as! String
                        self.stories.append(title)
                        self.tableView.reloadData()
                    }
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

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        cell.textLabel?.text = stories[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
