//
//  EndScreen.swift
//  ProbabilisticLearning
//
//  Created by Bryce Sandlund on 5/9/18.
//  Copyright © 2018 Bryce Sandlund. All rights reserved.
//

import UIKit

class EndScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        /*    if UIDevice.current.userInterfaceIdiom == .phone {
         return .allButUpsideDown
         } else {
         return .all
         }*/
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
