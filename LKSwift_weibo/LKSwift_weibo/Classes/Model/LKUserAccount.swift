//
//  LKUserAccount.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/30.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit





class LKUserAccount: NSObject , NSCoding{
    
    // 当做类方法. 返回值就是属性的类型
    // 有账号返回true
    class func userLogin() -> Bool {
        return LKUserAccount.loadAccount() != nil
    }
    
//MARK: -------------------对外属性-------------------
    /// 用于调用access_token，接口获取授权后的access token
    var access_token: String?
    
    /// access_token的生命周期，单位是秒数  (注意 新浪这里返回的数据类型是Int )
    /// 对于基本数据类型不能定义为可选
    var expires_in: NSTimeInterval = 0 {
        //属性监视器--
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
            print("expires_date:\(expires_date)")
        }
    }
    /// 将 access_token的生命周期 的单位变成date
    var expires_date: NSDate?
    /// 当前授权用户的UID
    var uid: String?
    
    /// 友好显示名称
    var name: String?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    

    //MARK: -------------------私有方法-------------------
    //MARK: -------------------对外方法-------------------
    /// KVC 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        // 将字典里面的每一个key的值赋值给对应的模型属性
        setValuesForKeysWithDictionary(dict)
    }
       // 当字典里面的key在模型里面没有对应的属性 要空实现这一方法
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    // 自定义 输出内容
    override var description: String {
        return "access_token:\(access_token), expires_in:\(expires_in), uid:\(uid): expires_date:\(expires_date), name:\(name), avatar_large:\(avatar_large)"
    }


    // 控制调用这个方法,不管成功还是失败,都需要告诉调用者
    // MARK: - 加载用户信息
    func loadUserInfo(finish: (error: NSError?) -> ()) {
        LKNetworkTools.sharedInstance.loadUserInfo { (result, error) -> () in
            if error != nil || result == nil {
                //错误 告诉调用者
                finish(error: error)
                return
            }
            // 加载成功 将 用户数据 赋值给 模型
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            // 保存到沙盒
            self.saveAccount()
            // 同步到内存中,把当前对象赋值给内存中的 userAccount
            LKUserAccount.userAccount = self
            finish(error: nil)
        }
    }
    
    // 类方法访问属性需要将属性定义成 static(静态)
    // 对象方法访问static属性需要类名.属性名称
// MARK: - 保存路径
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"
// MARK: - 保存对象 -- 解析对象
    func saveAccount() {
        // account.plist
        NSKeyedArchiver.archiveRootObject(self, toFile: LKUserAccount.accountPath)
    }
 
// MARK: - 加载解档数据
    //加载loadAccount 是用频繁,解档账号比较耗性能,只加载一次,保存到内存中,以后访问内存的中账号
    // 类方法访问属性需要将属性定义成 static
    private static var userAccount: LKUserAccount?
    // 类方法访问属性需要将属性定义成 static
    class func loadAccount() -> LKUserAccount? {
        // 判断内存有没有
        if userAccount == nil {
        // 内存中没有才来解档,并赋值给内存中的账号
        userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? LKUserAccount
        }
         // 判断如果有账号,还需要判断是否过期（）--过期时间 > 当前时间 就是有效
//  userAccount?.expires_date?新浪返回的过期时间   compare比较  NSDate()获得当前1时间
    // OrderedAscending (<)升序  OrderedSame (=)相等 OrderedDescending (>)降序
        if userAccount != nil && userAccount?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
//            print("账号有效")
            // 有效 返回账户
            return userAccount
        }

        return nil
    }

    // MARK: - 归档和解档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")

    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }

}
