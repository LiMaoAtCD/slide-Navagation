//
//  FirstViewController.swift
//  mici18
//
//  Created by AlienLi on 14/12/24.
//  Copyright (c) 2014年 ALN. All rights reserved.
//

import UIKit



class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showLeftPanel(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleLeftPanel", object: nil)
    }

    @IBAction func showRightPanel(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleRightPanel", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
