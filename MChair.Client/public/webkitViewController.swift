//
//  webkitViewController.swift
//  enengyPlatform
//
//  Created by bijiabo on 15/3/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import WebKit

class webkitViewController: UIViewController, WKNavigationDelegate, UINavigationBarDelegate
{
  var webView : WKWebView!
  var activityIndicatorView : UIActivityIndicatorView!
  var navigationBar : UINavigationBar!
  var userContentController : WKUserContentController!
  var configuration : WKWebViewConfiguration!
  var hostDomain : String = "http://192.168.1.3" //"http://192.168.1.104"
  var defaultPath : Dictionary<String,String> = ["path":"/","routerName":"nodesList"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let handler = webkitNotificationScriptMessageHandler(viewController: self)
    userContentController = WKUserContentController()
    userContentController.addScriptMessageHandler(handler, name: "notification")
    
    configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    
    var webViewFrame = view.frame
    webViewFrame.origin.y = navigationBar.frame.size.height+1.0
    webViewFrame.size.height -= navigationBar.frame.size.height-1.0
    webView = WKWebView(frame: webViewFrame, configuration: configuration)
    webView.navigationDelegate = self
    
    view.addSubview(webView)
    view.sendSubviewToBack(webView)
    
    let url : NSURL! = NSURL(string: hostDomain + defaultPath["path"]! as String)
    let req : NSURLRequest = NSURLRequest(URL: url)
    webView.loadRequest(req)
    
    //add loading view
    activityIndicatorView = UIActivityIndicatorView(frame: webViewFrame)
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    activityIndicatorView.color = UIColor.grayColor()
    activityIndicatorView.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:0.5)
    view.addSubview(activityIndicatorView)
    activityIndicatorView.startAnimating()
    view.bringSubviewToFront(activityIndicatorView)
    
    view.bringSubviewToFront(navigationBar)
  }
  
  func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
    
    let source = "Router.go(\"" + (defaultPath["routerName"] as String!) + "\")"
    
    webView.evaluateJavaScript(source, completionHandler: nil)
    
    return true
  }
  
  func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    activityIndicatorView.stopAnimating()
  }
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    println("did finish navigation")
    
  }
  
}