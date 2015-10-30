//
//  ViewController.swift
//  enphase
//
//  Created by Adam Kuert on 10/26/15.
//  Copyright © 2015 Adam Kuert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let solar_data = SolarData()
    var ui_text = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let sub_view = UIView(frame: UIScreen.mainScreen().bounds)
        sub_view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(sub_view)
        
        ui_text = UITextField(frame: CGRectMake(100, 100, 100, 50))
        ui_text.text = "fetching..."
        ui_text.textAlignment = .Center
        ui_text.textColor = UIColor.blackColor()
        sub_view.addSubview(ui_text)
        
        solar_data.getData(withCallback: drawTotal)
    }
    
    func drawTotal(total: String){
        ui_text.text = total
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

