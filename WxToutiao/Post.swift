//
//  Post.swift
//  WxToutiao
//
//  Created by walker on 2017/10/2.
//  Copyright © 2017年 walker. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import Moya

/// 第一级
struct PostIndexResponse:Mappable {
    var status:String!
    var count:Int!
    var posts:[Post]!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        posts <- map["posts"]
    }
}

// 提交评论的响应
struct SubmitResponse:Mappable {
    var status:String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}

/// 第二级
struct Post:Mappable {
    var id:Int!
    var title:String!
    var content:String!
    var url:String!
    var comment_count:Int!
    
    var comments:[Comment]!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        url <- map["url"]
        comment_count <- map["comment_count"]
        
        comments <- map["comments"]
    }
    
}

// 文章中的评论
struct Comment:Mappable{
    var name:String!
    var content:String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        content <- map["content"]
    }
}

// 获取分类
extension Post{
    /// 根据id获取文章
    ///
    /// - Parameter completion: Post
    static func request(id:Int,completion:@escaping ([Post]?)->()){
        let provider=MoyaProvider<NetworkService>()
        
        provider.request(.showCateNewsList(id: id)) { (result) in
            switch result{
            case let .success(moyaRespose):
                guard let json=try? moyaRespose.mapJSON() as! [String:Any],
                    let jsonResponse = PostIndexResponse(JSON: json) else{
                        return
                }
                completion(jsonResponse.posts)
            case .failure(_):
                print("网路错误")
                completion(nil)
            }
        }
    }
    
    /// 提交评论
    ///
    /// - Parameters:
    ///   - id: id
    ///   - completion: 成功与否
    static func submit(postId:Int,name:String,email:String,content:String,completion:@escaping (Bool)->()){
        let provider=MoyaProvider<NetworkService>()
        
        provider.request(.submitComment(postId: postId, name: name, email: email, content: content)) { (result) in
            switch result{
            case let .success(moyaRespose):
                guard let json=try? moyaRespose.mapJSON() as! [String:Any],
                    let jsonResponse = SubmitResponse(JSON: json) else{
                        return
                }
                completion(jsonResponse.status == "ok" ? true : false)
            case .failure(_):
                print("网路错误")
                completion(false)
            }
        }
    }
    
}
