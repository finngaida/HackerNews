//
//  ViewController.swift
//  Hacker News
//
//  Created by Finn Gaida on 13.05.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import UIKit
import HackerSwifter
import SwiftLinkPreview
import SwitchLoader
import SafariServices

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var data: [Post] = []
    let loader = Loader(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75
        
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
        
        // set up the loader
        let colors: [UIColor] = [UIColor(red: 0.941, green: 0.478, blue: 0, alpha: 1)] //[.red, .blue, .green, .yellow, .black, .purple]
        let random = colors[Int(arc4random_uniform(UInt32(colors.count-1)))]
        let loaderFrame = UIView(frame: CGRect(x: 0, y: -500, width: self.view.frame.width, height: 500))
        loaderFrame.backgroundColor = random
        loader.center = CGPoint(x: loaderFrame.center.x, y: loaderFrame.frame.height - 50)
        loader.loaderColor = .white
        loader.switchColor = random
        
        loaderFrame.addSubview(loader)
        self.tableView.addSubview(loaderFrame)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSafari" {
            
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
        
        if var url = post.url?.absoluteString {
            if url.range(of: "http://www.") != nil { url = url.substring(from: url.index(url.startIndex, offsetBy: 11)) }
            else if url.range(of: "https://www.") != nil { url = url.substring(from: url.index(url.startIndex, offsetBy: 12)) }
            else if url.range(of: "http://") != nil { url = url.substring(from: url.index(url.startIndex, offsetBy: 7)) }
            else if url.range(of: "https://") != nil { url = url.substring(from: url.index(url.startIndex, offsetBy: 8)) }
            cell.subtitleLabel.text = url
        }
        
        if let url = post.url {
            
            DispatchQueue.global(qos: .userInitiated).async {
                let preview = SwiftLinkPreview()
                preview.preview(url.absoluteString, onSuccess: { (dict) in
                    if let imgURLS = dict["image"] as? String, let imgURL = URL(string: imgURLS), let data = try? Data(contentsOf: imgURL, options: Data.ReadingOptions.mappedIfSafe) {
                        DispatchQueue.main.async {
                            let img = UIImage(data: data)
                            cell.previewView.image = img
                            cell.previewView.layer.masksToBounds = true
                            cell.previewView.layer.cornerRadius = 5
                        }
                    }
                }, onError: { (error) in
                    print("couldn't load: \(error)")
                })
            }
        }
        
        self.registerForPreviewing(with: self, sourceView: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = data[indexPath.row].url else { return }
        let sf = SafariViewController(url: url, entersReaderIfAvailable: true)
        self.present(sf, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = -scrollView.contentOffset.y-64
        loader.transform = CGAffineTransform(rotationAngle: CGFloat.pi * (y/100+0.5))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let y: CGFloat = -scrollView.contentOffset.y-64
        if y > 100 {
            scrollView.contentInset = UIEdgeInsets(top: 164, left: 0, bottom: 0, right: 0)
            loader.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                scrollView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
                scrollView.scrollRectToVisible(CGRect(x: 0, y: 64, width: 0, height: 0), animated: true)
                self.loader.stopAnimating()
            })
        }
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: false, completion: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? TableViewCell, let index = self.tableView.indexPath(for: cell) else { return nil }
        guard data.count > index.row, let url = data[index.row].url else { return nil }
        
        return SafariViewController(url: url, entersReaderIfAvailable: false)
    }
    
}
