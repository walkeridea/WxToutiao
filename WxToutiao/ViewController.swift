//
//  ViewController.swift
//  WxToutiao
//
//  Created by walker on 2017/10/2.
//  Copyright © 2017年 walker. All rights reserved.
//

import UIKit
import Moya
import PageMenu

class ViewController: UIViewController {

    var pageMenu:CAPSPageMenu!
    var controllers:[UIViewController]=[]
    
    func showMenu(){
        Category.request { (cates) in
            guard let cates=cates else{
                print("网络错误")
                return
            }
            self.controllers=cates.map{
                let vc=self.storyboard?.instantiateViewController(withIdentifier: "sbId_newList") as! NewsListController
                vc.title=$0.title
                vc.parentNavi=self.navigationController
                vc.id=$0.id
                return vc
            }
            //菜单优化设置
            let param : [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(4.3),
                .scrollMenuBackgroundColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
                .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
                .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
                .selectionIndicatorColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
                .menuMargin(20.0),
                .menuHeight(40.0),
                .selectedMenuItemLabelColor(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
                .unselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
                .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 15.0)!),
                .useMenuLikeSegmentedControl(false),
                .menuItemSeparatorRoundEdges(true),
                .selectionIndicatorHeight(2.0),
                .menuItemSeparatorPercentageHeight(0.1),
                .menuItemWidth(40)
            ]
            
            let frame = CGRect(x: 0, y: 20 + 44, width: self.view.frame.width, height: self.view.frame.height - 20 - 44)
            self.pageMenu=CAPSPageMenu(viewControllers: self.controllers, frame: frame, pageMenuOptions: param)
            self.view.addSubview(self.pageMenu.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置返回按钮为空
        navigationItem.backBarButtonItem=UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        showMenu()
    }

}

