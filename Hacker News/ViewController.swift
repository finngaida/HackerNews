//
//  ViewController.swift
//  Hacker News
//
//  Created by Finn Gaida on 13.05.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import UIKit
import HackerSwifter

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get some data in
        Post.fetch(.Best) { (data, error, local) in
            
            // ouch, that was bad
            if let e = error {
                print("An error happened: \(e)")
            }
            
            // got data?
            if let d = data {
                self.data = d
                self.tableView.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let post = data[indexPath.row]
        cell.titleLabel.text = post.title
        cell.subtitleLabel.text = post.url?.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
