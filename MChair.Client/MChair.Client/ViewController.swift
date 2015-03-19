//
//  ViewController.swift
//  MChair.Client
//
//  Created by bijiabo on 15/3/19.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class ViewController: webkitViewController {

  @IBOutlet var navigationbar: UINavigationBar!
  
  override func viewDidLoad() {
    
    navigationBar = navigationbar
    defaultPath = ["path":"/sensors/client","routerName":"sensorClient"]
    
    super.viewDidLoad()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }


}

