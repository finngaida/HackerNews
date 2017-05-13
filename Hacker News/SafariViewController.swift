//
//  SafariViewController.swift
//  Hacker News
//
//  Created by Finn Gaida on 13.05.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {
    
    var url: URL?
    
    override init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        self.url = URL
    }

    override var previewActionItems: [UIPreviewActionItem] {
        let readLater = UIPreviewAction(title: "Read later", style: .default) { (action, controller) in
            guard let sf = controller as? SafariViewController, let url = sf.url else { return }
            try? SSReadingList.default()?.addItem(with: url, title: nil, previewText: nil)
        }
        let share = UIPreviewAction(title: "Share", style: .default) { (action, controller) in
            guard let sf = controller as? SafariViewController, let url = sf.url else { return }
            let share = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            controller.present(share, animated: true, completion: nil)
        }
        return [readLater, share]
    }

}
