//
//  ViewController.swift
//  Twitter
//
//  Created by Robert McGee on 3/20/20.
//  Copyright © 2020 Robert McGee. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView?.load(URLRequest(url:URL(string: "https://mobile.twitter.com/login")!))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        webView.frame = self.view.safeAreaLayoutGuide.layoutFrame
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 52, left: 0, bottom: 52, right: 0)
        
        self.view.addSubview(webView!)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.host {
            //open links from Twitter in the app
            if (host == "mobile.twitter.com" || host == "twitter.com" || host == "cards-frame.twitter.com") {
                print("allowing host: \(host)")
                decisionHandler(.allow)
                return
            }
            //open external links in Brave
            else {
                print("sending to brave: \(host)")
                let urlToPass = navigationAction.request.url?.absoluteString
                let braveURL = URL(string:"brave://open-url?url=\(urlToPass!)")
                //
                UIApplication.shared.open(braveURL!, options: [:]) { (Bool) in
                    let canOpen = Bool
                    if(canOpen){
                        print("we good")
                        UIApplication.shared.open(braveURL!, options: [:], completionHandler: nil)
                    } else {
                        print("go get brave")
                        let braveAppStoreURL = URL(string: "https://apps.apple.com/us/app/brave-private-web-browser/id1052879175")!
                        UIApplication.shared.open(braveAppStoreURL, options: [:], completionHandler: nil)
                    }
                }
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.cancel)
    }
}
