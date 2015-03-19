//
//  webkitNotificationScriptMessageHandler.swift
//  enengyPlatform
//
//  Created by bijiabo on 15/3/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//
import WebKit

class webkitNotificationScriptMessageHandler: NSObject, WKScriptMessageHandler
{
  var vc : AnyObject!
  
  init(viewController : AnyObject) {
    vc = viewController
  }
  
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
  {
    
    if let action = message.body["action"] as? String
    {
      switch action
      {
      case "pushNavigationItem":
        if vc.navigationBar.items.count<2
        {
          vc.navigationBar.pushNavigationItem(UINavigationItem(title: message.body["title"] as String!), animated: true)
        }
        
      case "popNavigationItemAnimated":
        if vc.navigationBar.items.count>1
        {
          vc.navigationBar.popNavigationItemAnimated(true)
        }
        
        
      default:
        println("")
      }
    }
    
  }
  
}
