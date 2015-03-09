//
//  ViewController.swift
//  C.MotionMonitor
//
//  Created by bijiabo on 15/3/7.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import CoreMotion
import WebKit

class ViewController: UIViewController , WKNavigationDelegate {
  
  var montionManager : CMMotionManager!
  var queue : NSOperationQueue!
  @IBOutlet var debugLabel: UILabel!
  @IBOutlet var uiwebview: UIWebView!
  var updateTimer : NSTimer!
  var webView : WKWebView!
  var userContentController : WKUserContentController!
  var configuration : WKWebViewConfiguration!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userContentController = WKUserContentController()
    
    configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    
    webView = WKWebView(frame: view.frame, configuration: configuration)
    webView.navigationDelegate = self
    view.addSubview(webView)
    view.bringSubviewToFront(debugLabel)
    var url : NSURL! = NSURL(string: "http://192.168.1.102")
    var req : NSURLRequest = NSURLRequest(URL: url)
    webView.loadRequest(req)
    
    //uiwebview.loadRequest(req)
    uiwebview.hidden = true
    
    montionManager = CMMotionManager()
    queue = NSOperationQueue()
    
    if montionManager.accelerometerAvailable
    {
      self.montionManager.accelerometerUpdateInterval = 1.0 / 10.0
      self.montionManager.deviceMotionUpdateInterval = 1.0 / 10.0
      /*
      montionManager.startDeviceMotionUpdatesToQueue(self.queue, withHandler: {
        (data : CMDeviceMotion!, error : NSError! ) in
        if (error != nil)
        {
          self.montionManager.stopAccelerometerUpdates()
          println(error)
        }
        else
        {
          let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
          println(rotation)
        }
      })
      */
    }
    else
    {
      println("accelerometerActive none")
    }
    
    if montionManager.gyroAvailable
    {
      montionManager.gyroUpdateInterval = 1.0 / 10.0
    }
    else
    {
      println("This device has no gyroscope.")
    }

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    montionManager.startAccelerometerUpdates()
    montionManager.startDeviceMotionUpdates()
    montionManager.startGyroUpdates()
    
    updateTimer = NSTimer.scheduledTimerWithTimeInterval(2.0/10.0, target: self, selector: "updateDisplay", userInfo: nil, repeats: true)
  }
  
  func updateDisplay() -> Void {
    if montionManager.accelerometerAvailable
    {
      /*
      var accelerometerData : CMAccelerometerData = montionManager.accelerometerData
      
      debugLabel.text = NSString(format: "Accelerometer\n---\n x: %+.2f\n y: %+.2f\n z: %+.2f", accelerometerData.acceleration.x,
          accelerometerData.acceleration.y,
          accelerometerData.acceleration.z
      )
      
      let source = "updateAcceleormeter({x : \(accelerometerData.acceleration.x), y : \(accelerometerData.acceleration.y), z : \(accelerometerData.acceleration.z)})"
      webView.evaluateJavaScript(source, completionHandler: nil)
      */
    }
    
    if montionManager.deviceMotionAvailable
    {
      //println("device motion Available")
      var deviceMotion = montionManager.deviceMotion
      if deviceMotion != nil
      {
        let gravity = deviceMotion.gravity
        
        debugLabel.text = NSString(format: "gravity\n---\n x: %+.2f\n y: %+.2f\n z: %+.2f",
          gravity.x,
          gravity.y,
          gravity.z
        )
        
        let gravityJSON = NSString(format: "{x: %+.2f , y: %+.2f , z: %+.2f}",
          gravity.x * 90,
          gravity.y * 90,
          gravity.z * 90
        )

        let source = "updateAcceleormeter(\(gravityJSON))"
        webView.evaluateJavaScript(source, completionHandler: nil)
      }
    }
    
    if montionManager.gyroAvailable
    {
      //var gyroData : CMGyroData = montionManager.gyroData
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    println("finished navigation to url ")
    
    let source = "Router.go(\"sensorCollect\")"
    
    webView.evaluateJavaScript(source, completionHandler: nil)

  }
  
  
  
}

