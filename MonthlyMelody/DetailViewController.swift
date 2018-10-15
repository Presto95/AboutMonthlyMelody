//
//  DetailViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 24..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna

//배경은 선택된 앨범의 앨범아트로 꾸미기

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var album: UILabel!
    var albumPassed=""   //전 뷰에서 넘어온 앨범명
    var artistPassed=""
    var albumcover=""
    var numbers=[String]()
    var titles=[String]()
    @IBOutlet weak var right: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        right.layer.zPosition=1
        album.text=albumPassed
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
                    for info in doc2.xpath("//td[@class='order']"){
                        var temp=info.text!
                        temp=temp.trimmingCharacters(in: .whitespacesAndNewlines)
                        numbers.append(temp)
                    }
                    for info2 in doc2.xpath("//td[@class='name']"){
                        var temp=info2.text!
                        temp=temp.trimmingCharacters(in: .whitespacesAndNewlines)
                        titles.append(temp)
                    }
                }
                numbers.remove(at: 0)
                titles.remove(at: 0)
                let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
                backgroundImage.downloadImageFrom(albumcover, contentMode: .scaleAspectFill)
                backgroundImage.addBlurEffect()
                backgroundImage.clipsToBounds=true
                self.view.insertSubview(backgroundImage, at: 0)
                
            }
            else{
                let alert=UIAlertController(title: "오류", message: "관련 정보를 찾을 수 없습니다.", preferredStyle: .alert)
                let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                    return
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableViewCell
        cell.number.text=numbers[indexPath.row]
        cell.song.text=titles[indexPath.row]
        cell.backgroundColor=UIColor.clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        let nextView=storyboard?.instantiateViewController(withIdentifier: "LyricViewController") as! LyricViewController
        nextView.albumPassed=self.album.text!
        nextView.songPassed=cell.song.text!
        nextView.artistPassed=self.artistPassed
        navigationController?.pushViewController(nextView, animated: true)

    }
}
