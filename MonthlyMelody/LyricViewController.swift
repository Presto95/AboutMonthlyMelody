//
//  LyricViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 29..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna

class LyricViewController: UIViewController {

    var albumPassed=""
    var artistPassed=""
    var songPassed=""
    var albumcover=""
    @IBOutlet weak var albumLyric: UILabel!
    @IBOutlet weak var songLyric: UILabel!
    @IBOutlet weak var lyricLyric: UITextView!
    @IBOutlet weak var right: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        right.layer.zPosition=1
        lyricLyric.text=""
        albumLyric.text=albumPassed
        songLyric.text=songPassed
        //배경 화면 설정
        let artistUrlEncoding=artistPassed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let albumUrlEncoding=albumPassed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let keywordUrlEncoding=artistUrlEncoding! + albumUrlEncoding!
        let url=URL(string: "http://music.naver.com/search/search.nhn?query="+keywordUrlEncoding+"&target=album")
        if let doc=HTML(url: url!, encoding: .utf8){
            if let searchQuery=doc.xpath("//a[@title='"+albumPassed+"']/@href").first?.text{
                let realUrlString="http://music.naver.com"+searchQuery
                let realUrl=URL(string: realUrlString)
                if let doc2=HTML(url: realUrl!, encoding: .utf8){
                    albumcover=(doc2.xpath("//img[@alt='"+albumPassed+"']/@src").first?.text!)!
                }
                if let doc3=HTML(url: realUrl!, encoding: .utf8){
                    var arrayResult=[String]()
                    for info in doc3.xpath("//a[@title='"+songPassed+"']/@href"){
                        if let infoNotNil = info.text{
                            arrayResult.append(infoNotNil)
                        }
                    }
                    var songId:String=""
                    let length=arrayResult.count
                    if(length == 0){
                        let alert=UIAlertController(title: "오류", message: "파싱된 정보가 없습니다.", preferredStyle: .alert)
                        let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    var newArray=arrayResult
                    for i in 0..<newArray.count{
                        newArray[i]=newArray[i].substring(from: newArray[i].index(newArray[i].startIndex, offsetBy: 1))
                    }
                    for element in newArray{
                        if let number = Int(element){
                            songId=String(number)
                            break
                        }
                    }
                    if(songId == ""){
                        let alert=UIAlertController(title: "오류", message: "파싱된 정보가 없습니다.", preferredStyle: .alert)
                        let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                    let url2=URL(string: "http://music.naver.com/lyric/index.nhn?trackId="+songId)
                    if let doc4=HTML(url: url2!, encoding: .utf8){
                        for info in doc4.xpath("//div[@id='lyricText']"){
                            var text=info.toHTML!.replacingOccurrences(of: "<br>", with: "\r\n\r\n")
                            text=text.replacingOccurrences(of: "<div id=\"lyricText\" class=\"show_lyrics\">", with: "")
                            text=text.replacingOccurrences(of: "</div>", with: "")
                            lyricLyric.text=lyricLyric.text + text
                        }
                    }
                }
            }
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom(albumcover, contentMode: .scaleAspectFill)
            backgroundImage.addBlurEffect()
            backgroundImage.clipsToBounds=true
            self.view.insertSubview(backgroundImage, at: 0)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
