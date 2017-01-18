//
//  ViewController.swift
//  Preso
//
//  Created by Ricky Roy on 12/30/16.
//  Copyright © 2016 Snowbourne LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openTestPresentation(_ sender: UIButton) {
        let path = Bundle.main.path(forResource: "space", ofType: "pdf")
        let renderer = SBImgRenderPdf(path: URL(fileURLWithPath: path!))
        
    }

}

