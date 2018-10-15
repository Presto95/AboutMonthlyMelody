//
//  BugReportViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 26..
//  Copyright © 2017년 Presto. All rights reserved.
//
import MessageUI
import UIKit

class BugReportViewController: UIViewController, MFMessageComposeViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let mc=MFMailComposeViewController()
        mc.mailComposeDelegate=self as! MFMailComposeViewControllerDelegate
        mc.setToRecipients(["yoohan95@gmail.com"])
        mc.setSubject("CSS "+UserDefaults.standard.string(forKey: "name")!+" 버그 제보합니다.")
        mc.setMessageBody("내용을 입력하세요.", isHTML: false)
        if MFMailComposeViewController.canSendMail(){
            self.present(mc,animated: true, completion: nil)
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
