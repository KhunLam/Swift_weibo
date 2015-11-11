//
//  LKNetworkTools.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/29.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import AFNetworking


// 创建枚举   empty空
// emptyTokenE.rawValue 拿到枚举对应的值
enum LKNetworkError: Int {
    case emptyToken = -1
    case emptyUid = -2
    // 枚举里面可以有属性
    var description: String {
        get {
            // 根据枚举的类型返回对应的错误
            switch self {
            case LKNetworkError.emptyToken: //-1
                return "accecc token 为空"
            case LKNetworkError.emptyUid: //-2
                return "uid 为空"
            }
        }

    }
    // 自定义error
    // domain: 自定义,表示错误范围
    // code: 错误代码:自定义.负数开头,
    // userInfo: 错误附加信息
    // 枚举可以定义方法
    func error() -> NSError {
        return NSError(domain: "cn.itcast.error.network", code: rawValue, userInfo: ["errorDescription" : description])
    }
}

class LKNetworkTools: NSObject  {

    // 属性
    private var afnManager: AFHTTPSessionManager
    
    // 创建单例
    static let sharedInstance: LKNetworkTools = LKNetworkTools()
    
    override init() {
        let urlString = "https://api.weibo.com/"
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: urlString))
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    }

    
//    // 创建AFN请求单例
//    static let sharedInstance:LKNetworkTools = {
//       let urlString = "https://api.weibo.com/"
//       let tool = LKNetworkTools(baseURL: NSURL(string: urlString))
//       // 因为解释器 没有text/plain类型  insert添加一个
//       tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        
//        return tool
//    }()
    
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
        requestPOST(urlString, parameters: parameters, finshed: finshed)
//        afnManager.POST(urlString, parameters: parameters, success: { (_, result) -> Void in
//            //成功
//            finshed(result: result as? [String: AnyObject], error: nil)
//            }) { (_, error: NSError) -> Void in
//            //失败
//            finshed(result: nil, error: error)
//        }
    }
    
    // MARK: - 获取用户信息 至少需要 access_token 与 uid
    func loadUserInfo(finshed: (result: [String: AnyObject]?, error: NSError?) -> ()){

//        // 判断accessToken
//        if LKUserAccount.loadAccount()?.access_token == nil {
//            print("没有accessToken")
//            let error = LKNetworkError.emptyToken.error()
//            // 告诉调用者
//            finshed(result: nil, error: error)
//            return
//        }
        
        // 守卫,和可选绑定相反
        // parameters 代码块里面和外面都能使用
        guard var parameters = tokenDict() else {
            // 能到这里来表示 parameters 没有值
            print("没有accessToken")
            
            let error = LKNetworkError.emptyToken.error()
            // 告诉调用者
            finshed(result: nil, error: error)
            return
        }

        
        // 判断uid
        if LKUserAccount.loadAccount()?.uid == nil {
            print("没有uid")
            let error = LKNetworkError.emptyUid.error()
            
            // 告诉调用者
            finshed(result: nil, error: error)
            return
        }
        // url
        let urlString = "2/users/show.json"

        // 参数
//        let parameters = [
//            "access_token": LKUserAccount.loadAccount()!.access_token!,
//            "uid": LKUserAccount.loadAccount()!.uid!
//        ]
        // 添加元素   access_token已经在守卫 添加字典了
        parameters["uid"] = LKUserAccount.loadAccount()!.uid!
        
        // 发送请求
        requestGET(urlString, parameters: parameters, finshed: finshed)
//        afnManager.GET(urlString, parameters: parameters, success: { (_, result) -> Void in
//            finshed(result: result as? [String: AnyObject], error: nil)
//            }) { (_, error) -> Void in
//                finshed(result: nil, error: error)
//        }
    }
    
    // MARK: - 获取微博数据
    /**
    加载微博数据  刷新  --与--  加载之前的
    - parameter since_id: 若指定此参数，则返回ID比since_id大的微博,默认为0
    - parameter max_id:   若指定此参数，则返回ID小于或等于max_id的微博,默认为0
    - parameter finished: 回调 参数
    */
    func loadStatus(since_id: Int, max_id: Int,finshed : NetworkFinishedCallback){
        
        //        // 可选绑定 ----》 能进去 有值  但参数accessToken 只能在内部使用
        //        if let accessToken = LKUserAccount.loadAccount()?.access_token{
        //
        //            // access token 有值
        //            let urlString = "2/statuses/home_timeline.json"
        //
        //            let parameters = ["access_token":accessToken]
        //
        //            requestGET(urlString, parameters: parameters, finshed: finshed)
        //        }
        
        // 守卫,和可选绑定相反
        // parameters 代码块里面和外面都能使用  能进入方法说明token没有值
        guard var parameters = tokenDict() else {
            // 告诉调用者
            finshed(result: nil, error: LKNetworkError.emptyToken.error())
            return
        }
        // 添加参数 since_id和max_id
        // 判断是否有传since_id,max_id
        if since_id > 0 {
            parameters["since_id"] = since_id
        } else if max_id > 0 {
            // 会吧最后一条微博返回 -- 多减一
            parameters["max_id"] = max_id - 1
        }
        // 网络请求
        let urlString = "2/statuses/home_timeline.json"
         //调试 Apache 请求
//        let urlString = "http://localhost/statue/statuses.json"
       // GET 获取网络数据
        requestGET(urlString, parameters: parameters, finshed: finshed)

        // 网络不给力,加载本地数据
//        loadLocalStatus(finished)
    }
    //网络 不给里  开发时 可以加载 本地数据    json格式
    //        private func loadLocalStatus(finished: NetworkFinishedCallback) {
    //            // 获取路径
    //            let path = NSBundle.mainBundle().pathForResource("statuses", ofType: "json")
    //
    //            // 加载文件数据
    //            let data = NSData(contentsOfFile: path!)
    //
    //            // 转成json
    //            do {
    //                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
    //                // 有数据
    //                finished(result: json as? [String : AnyObject], error: nil)
    //            } catch {
    //                print("出异常了")
    //                如果do里面的代码出错了,不会崩溃,会走这里
    // 强制try 如果这句代码有错误,程序立即停止运行
    // let statusesJson = try! NSJSONSerialization.JSONObjectWithData(nsData, options: NSJSONReadingOptions(rawValue: 0))
    //            }

    
    // MARK: - 发布微博
    /**
    发布微博
    - parameter image:   微博图片,可能有可能没有
    - parameter status:   微博文本内容
    - parameter finished: 回调闭包
    */
    func sendStatus(image: UIImage?, status: String, finished: NetworkFinishedCallback) {
        // 判断token
        guard var parameters = tokenDict() else {
            // 能到这里来说明token没有值
            
            // 告诉调用者
            finished(result: nil, error: LKNetworkError.emptyToken.error())
            return
        }
        
        // token有值, 拼接参数
        parameters["status"] = status
        
        
        // 判断是否有图片
        if let im = image {
            // 有图片,发送带图片的微博
            let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
            //发送 AFMultipartFormData 请求 可以带图片
            afnManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (multipartFormData) -> Void in
                
                
                //multipartFormData ---- 需要给服务器的 图片二进制数据 参数
                // data: 上传图片的2进制
                // name: api 上面写的传递参数名称 "pic"(新浪规定)
                // fileName: 上传到服务器后,保存的名称,没有指定可以随便写
                // mimeType: 资源类型(新浪规定):
                // image/png
                // image/jpeg
                // image/gif
                
                //将图片转为2进制
               let data = UIImagePNGRepresentation(im)!
                //
                multipartFormData.appendPartWithFileData(data, name: "pic", fileName: "sb", mimeType: "image/png")
                
                }, success: { (_, result) -> Void in
                    finished(result: result as? [String: AnyObject], error: nil)
                }, failure: { (_, error) -> Void in
                    finished(result: nil, error: error)
            })
        } else {
            // 没有图片
            // url
            let urlString = "2/statuses/update.json"
            
            afnManager.POST(urlString, parameters: parameters, success: { (_, result) -> Void in
                finished(result: result as? [String: AnyObject], error: nil)
                }) { (_, error) -> Void in
                    finished(result: nil, error: error)
            }
        }
        
    }

    //MARK: - 判断access token是否有值,没有值返回nil,如果有值生成一个字典
    func tokenDict() -> [String: AnyObject]? {
        if LKUserAccount.loadAccount()?.access_token == nil {
            return nil
        }
        return ["access_token": LKUserAccount.loadAccount()!.access_token!]
    }

    
    // MARK: - 类型别名 =OC typedefined  (闭包)block
    typealias NetworkFinishedCallback = (result:[String: AnyObject]?,
        error:NSError?)->()

    // MARK: - 封装AFN.GET
    func requestGET(URLString: String, parameters: AnyObject?,finshed:NetworkFinishedCallback){
        afnManager.GET(URLString, parameters: parameters, success: { (_, result) -> Void in
            finshed(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
            finshed(result: nil, error: error)
        }
    }
    // MARK: - 封装AFN.POST
    func requestPOST(URLString: String, parameters: AnyObject?,finshed:NetworkFinishedCallback){
        afnManager.POST(URLString, parameters: parameters, success: { (_, result) -> Void in
            //成功
             finshed(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
            //失败
             finshed(result: nil, error: error)
        }
    }


}
