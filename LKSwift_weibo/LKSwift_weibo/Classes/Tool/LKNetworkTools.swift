//
//  LKNetworkTools.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/29.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import AFNetworking


class LKNetworkTools: AFHTTPSessionManager  {

    // 创建AFN请求单例
    static let sharedInstance:LKNetworkTools = {
       let urlString = "https://api.weibo.com/"
       let tool = LKNetworkTools(baseURL: NSURL(string: urlString))
       // 因为解释器 没有text/plain类型  insert添加一个
       tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool
    }()
    
    // MARK: - OAtuh授权
    /// 申请应用时分配的AppKey
    private let client_id = "1261718255"
    
    ///重定向 回调地址
    let redirect_uri = "http://www.baidu.com/"
    
    
    /// 申请应用时分配的AppSecret
    private let client_secret = "90e49788bb8b5d5580daa919b7d9be3d"
    
    /// 请求的类型，填写authorization_code
    private let grant_type = "authorization_code"
    
    
    // OAtuhURL地址 授权方法  返回地址
//    https://api.weibo.com/oauth2/authorize?client_id=1261718255&redirect_uri=http://www.baidu.com
    func oauthRUL() -> NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
    
    // MARK: - 加载AccessToken
    // 加载AccessToken --https://api.weibo.com/（baseURL不要) oauth2/access_token
    // POST得到闭包返回数据   然后再通过自己的闭包 给外界
    ///加载AccessToken

    func loadAccessToken(code: String,finshed:(result: [String: AnyObject]?, error: NSError?) -> ())->(){
//         url
        let urlString = "oauth2/access_token"
        // 参数 字典
        let parameters = [
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": grant_type,
            "code": code,
            "redirect_uri": redirect_uri
        ]
//         result: 请求结果 成功回调 失败回调   闭包返回数据
        POST(urlString, parameters: parameters, success: { (_, result) -> Void in
            //成功
            finshed(result: result as? [String: AnyObject], error: nil)
            }) { (_, error: NSError) -> Void in
            //失败
            finshed(result: nil, error: error)
        }
    }
    
}
