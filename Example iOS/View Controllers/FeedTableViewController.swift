//
//  FeedTableViewController.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import FeedKit
import UIKit

let feedURL = URL(string: "http://images.apple.com/main/rss/hotnews/hotnews.rss")!

class FeedTableViewController: UITableViewController {
    let parser = FeedParser(URL: feedURL)

    var rssFeed: RSSFeed?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Feed"

        Task {
            do {
                try await updateFeed(parser.parse())
            } catch {
                print(error)
            }
        }
    }

    func updateFeed(_ feed: Feed) {
        rssFeed = feed.rssFeed
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source

extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return rssFeed?.items?.count ?? 0
        default: fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reusableCell()
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .title: cell.textLabel?.text = rssFeed?.title ?? "[no title]"
        case .link: cell.textLabel?.text = rssFeed?.link ?? "[no link]"
        case .description: cell.textLabel?.text = rssFeed?.description ?? "[no description]"
        case .date: cell.textLabel?.text = rssFeed?.lastBuildDate?.description ?? "[no date]"
        case .items: cell.textLabel?.text = rssFeed?.items?[indexPath.row].title ?? "[no title]"
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension FeedTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let layout = TableViewLayout(indexPath: indexPath) else { fatalError() }
        switch layout {
        case .title: showDetailViewControllerWithText(rssFeed?.title ?? "[no title]")
        case .link: showDetailViewControllerWithText(rssFeed?.link ?? "[no link]")
        case .description: showDetailViewControllerWithText(rssFeed?.description ?? "[no link]")
        case .date: showDetailViewControllerWithText(rssFeed?.lastBuildDate?.description ?? "[no date]")
        case .items: showDetailViewControllerWithText(rssFeed?.items?[indexPath.row].description ?? "[no description]")
        }
    }
}

// MARK: - Navigation

extension FeedTableViewController {
    // MARK: - Navigation

    func showDetailViewControllerWithText(_ text: String) {
        let viewController = FeedDetailTableViewController(text: text)
        show(viewController, sender: self)
    }
}
