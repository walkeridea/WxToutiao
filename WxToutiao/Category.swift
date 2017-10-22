//
//  Category.swift
//  WxToutiao
//
//  Created by walker on 2017/10/2.
//  Copyright © 2017年 walker. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

/// 第一级
struct CategoryIndexResponse:Mappable {
    var status:String!
    var count:Int!
    var categories:[Category]!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        categories <- map["categories"]
    }
}

/// 第二级
struct Category:Mappable {
    var id:Int!
    var title:String!
    var count:Int!
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        count <- map["post_count"]
    }
    
}

// 获取分类
extension Category{
    static func request(completion:@escaping ([Category]?)->()){
        let provider=MoyaProvider<NetworkService>()
        provider.request(.category) { (result) in
            switch result{
            case let .success(moyaRespose):
                guard let json=try? moyaRespose.mapJSON() as! [String:Any],
                    let jsonResponse = CategoryIndexResponse(JSON: json) else{
                        return
                }
                completion(jsonResponse.categories)
            case .failure(_):
                print("网路错误")
                completion(nil)
            }
        }
    }
}
