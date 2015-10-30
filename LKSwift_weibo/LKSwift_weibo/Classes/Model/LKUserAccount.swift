//
//  LKUserAccount.swift
//  LKSwift_weibo
//
//  Created by lamkhun on 15/10/30.
//  Copyright © 2015年 lamKhun. All rights reserved.
//

import UIKit





class LKUserAccount: NSObject , NSCoding{
//MARK: -------------------私有属性-------------------
    /// 用于调用access_token，接口获取授权后的access token
    private var access_token: String?
    
    /// access_token的生命周期，单位是秒数  (注意 新浪这里返回的数据类型是Int )
    /// 对于基本数据类型不能定义为可选
    private var expires_in: NSTimeInterval = 0 {
        //属性监视器--
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
            print("expires_date:\(expires_date)")
        }
    }
    /// 将 access_token的生命周期 的单位变成date
    private var expires_date: NSDate?
    /// 当前授权用户的UID
    private var uid: String?
    //MARK: -------------------对外属性-------------------
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
        return "access_token:\(access_token), expires_in:\(expires_in), uid:\(uid): expires_date:\(expires_date)"
    }

    
    
// MARK: - 保存路径
    // 类方法访问属性需要将属性定义成 static(静态)
    // 对象方法访问static属性需要类名.属性名称
    static let accountPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/Account.plist"
    
    // MARK: - 保存对象 -- 解析对象
    func saveAccount() {
        // account.plist
        NSKeyedArchiver.archiveRootObject(self, toFile: LKUserAccount.accountPath)
    }

    // 类方法访问属性需要将属性定义成 static
    class func loadAccount() -> LKUserAccount? {
        
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? LKUserAccount
        
        return account
    }

    
    // MARK: - 归档和解档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
    }

}
