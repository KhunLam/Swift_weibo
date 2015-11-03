//
//  LKOauthViewController.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/29.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit
import SVProgressHUD

class LKOauthViewController: UIViewController {
    //MARK: -------------------私有属性-------------------
    //MARK: -------------------对外属性-------------------
    //MARK: -------------------私有方法-------------------
    /// 关闭控制器
     func close() {
        // 退出控制器
        dismissViewControllerAnimated(true, completion: nil)
        // 关闭正在加载
        SVProgressHUD.dismiss()
    }
    
    
    
    /// 自动填充账号密码
    func autoFill() {
        let js = "document.getElementById('userId').value='13642301623';" + "document.getElementById('passwd').value='kun36471508';"
        // webView执行js代码
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
    // MARK: - 懒加载
    private lazy var webView = UIWebView()
    
    //MARK: -------------------对外方法-------------------
    override func loadView() {
        view = webView
        
        // 设置代理
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设导航栏退出按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        /// 自动填充账号密码
         navigationItem.leftBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: "autoFill")

        // 加载网页
        let request = NSURLRequest(URL: LKNetworkTools.sharedInstance.oauthRUL())
        webView.loadRequest(request)
       
    }
    
    

}


// MARK: - 扩展 CZOauthViewController 实现 UIWebViewDelegate 协议
extension LKOauthViewController: UIWebViewDelegate {
    
    /// 开始加载请求
    func webViewDidStartLoad(webView: UIWebView){
        // 显示正在加载
        // showWithStatus 不主动关闭,会一直显示
        SVProgressHUD.showWithStatus("正在玩命加载...", maskType: SVProgressHUDMaskType.Black)
    }
    /// 加载请求完毕
    func webViewDidFinishLoad(webView: UIWebView){
        // 关闭正在加载
        SVProgressHUD.dismiss()
    }

   /// 询问是否加载 request
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        // 得到的就是 OAtuhURL授权地址
        // 若 点击授权  就会得到 回调地址+ code
        //urlString:Optional("http://www.baidu.com/?code=6c57029d0c97236b3ac44efe22336561")
        let urlString = request.URL!.absoluteString
        print("urlString:\(urlString)")
        
        // 加载的不是回调地址
        if !urlString.hasPrefix(LKNetworkTools.sharedInstance.redirect_uri) {
            return true // 直接返回 可以加载
        }
        
        
        // 判断点击的是 确定（加载） 还是 取消（拦截） 通过是否http://www.baidu.com/? 后是否 紧接  code=
        // http://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        // http://www.baidu.com/?code=6c57029d0c97236b3ac44efe22336561
        
        if let query = request.URL?.query {
            print("query:\(query)")//打印的 就是 没了http://www.baidu.com/? 的
            // 定义开头  是就是点击确定
            let codeString = "code="
        
            if query.hasPrefix(codeString) {
                // 确定
                // code=6c57029d0c97236b3ac44efe22336561
                // 转成NSString
                let nsQuery = query as NSString
                
                //截取后面的code值6c57029d0c97236b3ac44efe22336561  不要code=
                let code = nsQuery.substringFromIndex(codeString.characters.count)
                print("code: \(code)")
                //通过code值  获取access token
                 loadAccessToken(code)
            } else {
                // 取消
                
            }
        }
        return false
    }
    /// 加载失败回调
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        // 关闭正在加载
        SVProgressHUD.dismiss()
    }

    /**
     调用网络工具类去加载加载access token
     - parameter code: code
     */
    func loadAccessToken(code: String){
         LKNetworkTools.sharedInstance.loadAccessToken(code)
            { (result, error) -> () in
            // 如果 出错了 就提示
            if error != nil || result == nil {
               self.netError("网络不给力...")
               return
            }
            print("result: \(result)")
            // 将数据 给模型
            let account = LKUserAccount(dict: result!)
            // 保存到沙盒
            account.saveAccount()
            // 加载用户数据
            account.loadUserInfo({ (error) -> () in
                if error != nil {
                    print("加载用户数据出错: \(error)")
                    self.netError("加载用户数据出错...")
                    return
                }
                print("account:\(LKUserAccount.loadAccount())")
                self.close()
                // 切换控制器  ---> false 进入 欢迎界面
                (UIApplication.sharedApplication().delegate as! AppDelegate).switchRootController(false)
            })
        }
   }
//MARK: - 出错了 提示 方法
    private func netError(message: String) {
        SVProgressHUD.showErrorWithStatus(message, maskType: SVProgressHUDMaskType.Black)
        
        // 延迟关闭. dispatch_after 没有提示,可以拖oc的dispatch_after来修改
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.close()
        })
    }

}