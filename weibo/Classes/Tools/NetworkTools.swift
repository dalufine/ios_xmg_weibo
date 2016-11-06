//
//  NetworkTools.swift
//  weibo
//
//  Created by dalu on 2016/10/16.
//  Copyright © 2016年 dalu. All rights reserved.
//

import AFNetworking

enum RequestType :String {
    case GET = "GET"
    case POST = "POST"
}

class NetworkTools : AFHTTPSessionManager{
    //let 是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}
//封装请求
extension NetworkTools{
    func request(methodType : RequestType, url : String,params : [String : Any],finished:@escaping (_ result : Any?,_ error : Error?) -> ()){
        let successCallBack = {
            (task : URLSessionDataTask?, result : Any?) -> Void in
            finished(result, nil)
        }
        let failCallBack = {
            (task : URLSessionDataTask?, error : Error) -> Void in
            finished(nil, error)
        }
        if methodType == .GET{
            get(url, parameters: params, progress: nil, success: successCallBack, failure: failCallBack)
        }else if methodType == .POST{
            post(url, parameters: params, progress: nil, success: successCallBack, failure: failCallBack)
        }
    }
}
//请求token
extension NetworkTools{
    func loadAccessToken(code : String,finished : @escaping (_ result : [String : Any]?,_ error : Error?) -> ()) {
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        let params = ["client_id":app_key,"client_secret":app_secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        request(methodType: .POST, url: urlStr, params: params) { (res, err) in
            finished(res as? [String : Any],err)
        }
    }
}

//请求用户信息
extension NetworkTools{
    func loadUserInfo(access_token : String,uid : String,finished : @escaping (_ result : [String : Any]?,_ error : Error?) -> ()){
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token":access_token,"uid":uid]
        request(methodType: .GET, url: urlString, params: params) { (res, err) in
            finished(res as? [String : Any],err)
        }
    }
}

//请求微博首页数据
extension NetworkTools{
    func loadStatuses(since_id: Int, max_id: Int,finished : @escaping (_ result:[[String : Any]]?,_ error : Error?)->()){
        
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        //需要解包，不然拿到的是Optional("sfewfwef")
        let params = ["access_token":(UserAccountViewModel.shareIntance.account?.access_token)!,"since_id": "\(since_id)","max_id": "\(max_id)"]
        request(methodType: .GET, url: urlStr, params: params) { (result, error) in
            guard let resultDict = result as? [String : Any] else{
                finished(nil,error)
                return
            }
            
            finished(resultDict["statuses"] as? [[String : Any]],error)
        }
    }
}

//发送微博
extension NetworkTools{
    func sendStatus(statusText : String, isSuccess : @escaping (_ isSuccess : Bool) -> ()){
        
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let params = ["access_token":(UserAccountViewModel.shareIntance.account?.access_token)!,"status":statusText]
        
        request(methodType: .POST, url: urlString, params: params) { (res, err) in
            if res != nil {
                isSuccess(true)
            }else{
                isSuccess(false)
            }
        }
    }
    
    func sendStatus(statusText : String,image : UIImage, isSuccess : @escaping (_ isSuccess : Bool) -> ()){
        
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        let params = ["access_token":(UserAccountViewModel.shareIntance.account?.access_token)!,"status":statusText]
        
        post(urlString, parameters: params, constructingBodyWith: {(formData) -> Void in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
        }, progress: nil, success: {(_,_) -> Void in
            isSuccess(true)
        }, failure: {(_,err) -> Void in
            print(err)
            isSuccess(false)
        })
    }
    
}
