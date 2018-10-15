//
//  AnotherTableViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 24..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna
import MessageUI

class AnotherTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let realUrl=UserDefaults.standard.url(forKey: "urlAlbumCover")
        print(realUrl!)
        if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.tableView.backgroundView=backgroundImage
        }*/
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!Reachability.isConnectedToNetwork()){
            let alert=UIAlertController(title: "안내", message: "인터넷 연결을 확인하세요.", preferredStyle: UIAlertControllerStyle.alert)
            let action=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(UIAlertAction)->Void in
                exit(0)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        let realUrl=UserDefaults.standard.url(forKey: "urlAlbumCover")
        print(realUrl!)
        if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.tableView.backgroundView=backgroundImage
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch(indexPath.row){
        case 0:
            let mc=MFMailComposeViewController()
            mc.mailComposeDelegate=self
            mc.setToRecipients(["yoohan95@gmail.com"])
            if MFMailComposeViewController.canSendMail(){
                self.present(mc,animated: true, completion: nil)
            }

        case 1:
            let alert=UIAlertController(title: "파싱 정보", message: "디스코그래피 : 네이버 뮤직\n차트 : www.kpopchart.kr\n갤러리 : 네이버 이미지 검색\n\n파싱 결과에 따라 일부 음반의 트랙 리스트는 표시되지 않을 수 있습니다.",preferredStyle: UIAlertControllerStyle.alert)
            let action=UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil)
        case 2:
            let alert=UIAlertController(title: "만든 사람", message: "윤종신 ⌈좋니⌋ 차트 올킬을 기념하며.\nDeveloped by Presto in SeoulTech",preferredStyle: UIAlertControllerStyle.alert)
            let action=UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil)
        case 3:
            if let url = URL(string: "https://icons8.com") {
                UIApplication.shared.open(url, options: [:])
            }
        default:
            break
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
