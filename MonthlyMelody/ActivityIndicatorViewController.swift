//
//  ActivityIndicatorViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 28..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            let storyboard = self.storyboard
            let ivc = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            ivc?.modalTransitionStyle = .crossDissolve
            self.present(ivc!, animated: true, completion: { _ in })
            
            // do stuff 42 seconds later
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
