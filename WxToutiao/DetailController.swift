//
//  DetailController.swift
//  WxToutiao
//
//  Created by walker on 2017/10/2.
//  Copyright © 2017年 walker. All rights reserved.
//

import UIKit
import WebKit
import LeoDanmakuKit
import LLSwitch
import WZLBadge

class DetailController: UIViewController,LLSwitchDelegate {
    
    var webView:WKWebView!
    var post:Post!
    var isDanmuOn=true
//    var url:URL!
//    var content:String!
    
    @IBOutlet weak var danmuView: LeoDanmakuView!
    @IBOutlet weak var denmuSwitch: LLSwitch!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBAction func commentBtnTap(_ sender: UIButton) {
        print("点击了显示评论按钮")
        doJavaScriptFunction()
    }
    
    
    @IBAction func editBegin(_ sender: UITextField) {
        denmuSwitch.isHidden=true
        commentBtn.isHidden=true
    }
    
    @IBAction func editDid(_ sender: UITextField) {
        denmuSwitch.isHidden=false
        commentBtn.isHidden=false
        
        guard let commentText=sender.text else {
            return
        }
        loadDanmu(postAComment: commentText)
        print("发表评论")
        
        Post.submit(postId: post.id, name: "walker", email: "320553500@qq.com", content: commentText) { (finish) in
            print("评论成功\(finish)")
            
            OperationQueue.main.addOperation {
                self.showCommentBadge(self.post.comment_count+1)
                // 发送通知，刷新表格
                NotificationCenter.default.post(name: NotificationHelper.updateList, object: nil)
            }
        }
        
        sender.text=""
    }
    
    func didTap(_ llSwitch: LLSwitch!) {
        if isDanmuOn{
            denmuSwitch.setOn(false, animated: true)
            danmuView.stop()
            danmuView.isHidden=true
            print("弹幕关闭")
        }else{
            denmuSwitch.setOn(true, animated: true)
            danmuView.resume()
            danmuView.isHidden=false
            print("弹幕开启")
        }
        isDanmuOn = !isDanmuOn
    }
    
    func showCommentBadge(_ count:Int){
        if count > 0 {
            commentBtn.badgeCenterOffset=CGPoint(x: -4, y: 5)
            commentBtn.showBadge(with: .number, value: count, animationType: .bounce)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title=post.title
        
        showCommentBadge(post.comments.count)
        
        denmuSwitch.delegate=self
        loadHtml()
        loadDanmu(coments: post.comments)
    }
    
    func loadDanmu(coments:[Comment]?=nil,postAComment:String?=nil){
        if isDanmuOn{
            danmuView.resume()
            
            if let coments=coments{
                let danmu:[LeoDanmakuModel]=coments.map{
                    let model=LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                    model?.text=$0.content.html2String
                    return model!
                }
                danmuView.addDanmaku(with: danmu)
            }
            
            if let comment=postAComment{
                let model=LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                model?.text=comment
                danmuView.addDanmaku(model)
            }
            
        }else{
            danmuView.stop()
        }
        
    }
    
    func loadHtml(){
        let frame=CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height-44-20)
        webView=WKWebView(frame:frame)
        // 插入到最后面
        view.insertSubview(webView, at: 0)
        
//        <script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
        let header="""
            <html>
                <head>
                    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=0">
                    <script src="
        """
            + BASEURL +
        """
        /wp-content/uploads/2017/08/scroll.js"></script>

                    <style type="text/css">
                        body { font-size:100%;background:green; }
                        img { width:100% !important;}
                    </style>

                </head>
                <body>
        """
        
        let comment = """
            <hr id="commentAnchor">
        """
            + commentHtml(comments: post.comments) +
        """
                </body>
            <html>
        """
        
        //打开网址
        //        webView.load(URLRequest(url: url))
        //        webView.loadHTMLString(content, baseURL: nil)
        print(header)
        
        webView.loadHTMLString(header+post.content+comment, baseURL: nil)
    }
    
    func doJavaScriptFunction()   {
        
        //隐藏页面的所有文字 - 使用jqury处理
//         let js2="$(\"p\").hide()"
        
//        let js2="""
//            window.location.hash= 'commentAnchor'
//        """
        
        let js2 = """
            ScrollToControl('commentAnchor')
        """
        
        webView.evaluateJavaScript(js2) { (result, error) in
            print("js执行结果：",result ?? "",error ?? "")
        }
        
    }
    
    func commentHtml(comments: [Comment]) -> String {
        var result = ""
        
        for comment in comments {
            let paragraph = "<p> <h5>\(comment.name!)</h5> <h6>\(comment.content!)</h6> <hr size=1>  </p>"
            result += paragraph
        }
        
        return result
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
