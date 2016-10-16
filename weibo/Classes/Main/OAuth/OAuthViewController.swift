//
//  OAuthViewController.swift
//  weibo
//
//  Created by dalu on 2016/10/16.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        loadPage()
    }
}

// MARK: - UI
extension OAuthViewController{
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        navigationItem.title = "登录页面"
        
    }
    
    func loadPage(){
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        guard let url = URL(string : urlString) else{
            return
        }
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
        
    }
}

// MARK: - Event
extension OAuthViewController{
    func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    
    func fillItemClick() {
        let jsCode = "document.getElementById('userId').value='1606020376@qq.com';document.getElementById('passwd').value='haomage'"
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

//webview的代理（已经拖线设置了）
extension OAuthViewController : UIWebViewDelegate{
    //start load
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.url else{
            return true
        }
        let urlStr = url.absoluteString
        
        guard urlStr.contains("code=") else {
            return true
        }
        let code = urlStr.components(separatedBy: "code=").last!
        loadAccessToken(code: code)
        return false
    }
}

// MARK: - Net
extension OAuthViewController{
    func loadAccessToken(code : String){
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result,error) in
            if error != nil{
                print(error)
                return
            }
            guard let accountDict = result else{
                print("no data")
                return
            }
            
            let account = UserAccount(dict: accountDict)
            //闭包里面调用当前对象的方法，需要self.
            self.loadUserInfo(account: account)
        }
    }
    
    func loadUserInfo(account : UserAccount){
        guard let access_token = account.access_token else{
            return
        }
        guard let uid = account.uid else{
            return
        }
        NetworkTools.shareInstance.loadUserInfo(access_token: access_token, uid: uid) { (result,error) in
            if error != nil{
                print(error)
                return
            }
            guard let userInfoDict = result else{
                return
            }
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            print(account)
        }
    }
}
