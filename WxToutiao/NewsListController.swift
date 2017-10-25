//
//  NewsListController.swift
//  WxToutiao
//
//  Created by walker on 2017/10/2.
//  Copyright © 2017年 walker. All rights reserved.
//

import UIKit

class NewsListController: UITableViewController {
    
    var id=0
    
    var newsList:[Post]=[]
    
    //上级导航栏传递到下一级
    var parentNavi:UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        tableView.estimatedRowHeight=100
        tableView.rowHeight=UITableViewAutomaticDimension
        
        refreshControl=UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
        // 观察通知是否发送
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NotificationHelper.updateList, object: nil)
    }
    
    @objc func getData(){
        Post.request(id: id) { (posts) in
            if let posts=posts {
                OperationQueue.main.addOperation {
                    self.newsList=posts
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }else{
                print("网路错误")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! TextCell
        let news=newsList[indexPath.row]
        
        cell.titleLabel.text=news.title
        cell.commentLabel.text="评论：\(news.comment_count!)"

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news=newsList[tableView.indexPathForSelectedRow!.row]
        
        let detailVC=storyboard?.instantiateViewController(withIdentifier: "SDID_DETAIL") as! DetailController
        
        detailVC.post=news
    
        parentNavi?.pushViewController(detailVC, animated: true)
    }

}
