
//
//  ViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 21..
//  Copyright © 2017년 Presto. All rights reserved.
//
import UIKit
import Kanna
import MarqueeLabel

extension UIImageView {
    func downloadImageFrom(_ link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    self.image = UIImage(data: data)
                }
            }
        }).resume()
    }
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}


class MainViewController: UIViewController, UITabBarControllerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var album: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var albumcover: UIImageView!
    @IBOutlet weak var myArtist: UIButton!
    var temp:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.string(forKey: "myArtist")==nil){
            let alert=UIAlertController(title: "초기 설정", message: "아티스트명을 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(configurationHandler: nil)
            let yesAction=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
                if let input=alert.textFields![0].text{
                    UserDefaults.standard.set(input, forKey: "myArtist")
                }
                let alert2=UIAlertController(title: "초기 설정", message: "아티스트를 설정합니다.\n아티스트명을 터치하여 언제든 변경할 수 있습니다.", preferredStyle: UIAlertControllerStyle.alert)
                let yesAction2=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
                    self.myArtist.setTitle(UserDefaults.standard.string(forKey: "myArtist"), for: .normal)
                    self.loadImages()
                }
                alert2.addAction(yesAction2)
                self.present(alert2,animated: true, completion: nil)
            }
            alert.addAction(yesAction)
            self.present(alert,animated: true, completion: nil)
        }
        else{
            loadImages()
        }
        myArtist.setTitle(UserDefaults.standard.string(forKey: "myArtist"), for: .normal)
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
    }
    
    @IBAction func clickMyArtist(_ sender: UIButton) {
        let alert=UIAlertController(title: "아티스트 변경", message: "아티스트명을 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        let yesAction=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
            if let input=alert.textFields![0].text{
                self.temp=UserDefaults.standard.string(forKey: "myArtist")!
                UserDefaults.standard.set(input, forKey: "myArtist")
            }
            let alert2=UIAlertController(title: "아티스트 변경", message: "아티스트를 변경합니다.", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction2=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
                
                self.loadImages()
            }
            alert2.addAction(yesAction2)
            self.present(alert2,animated: true, completion: nil)
        }
        alert.addAction(yesAction)
        self.present(alert,animated: true, completion: nil)
    }
    
    func loadImages(){
        self.label.text="최신 발매"
        var real:String=""
        let artistUrlEncoding=UserDefaults.standard.string(forKey: "myArtist")
        let url=URL(string: "http://music.naver.com/search/search.nhn?query="+(artistUrlEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!+"&x=0&y=0")
        if let doc=HTML(url: url!, encoding: .utf8){
            let info=doc.xpath("//dl[@class='lst_desc']//a/@href")
            if(info.first?.text==nil){
                let alert=UIAlertController(title: "오류", message: "관련 정보가 없습니다.", preferredStyle: UIAlertControllerStyle.alert)
                let action=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
                    UserDefaults.standard.set(self.temp, forKey: "myArtist")
                    self.myArtist.setTitle("클릭하여 아티스트 변경", for: .normal)
                }
                alert.addAction(action)
                self.present(alert,animated: true, completion: nil)
            }
            else{
                real=(info.first?.text)!
                let realUrl=URL(string: "https://music.naver.com"+real)
                UserDefaults.standard.set(realUrl!, forKey: "urlAlbumCover")
                if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
                    let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
                    albumcover.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleAspectFit)
                    let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
                    backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
                    backgroundImage.addBlurEffect()
                    self.view.addSubview(backgroundImage)
                    self.album.layer.zPosition=1
                    self.albumcover.layer.zPosition=1
                    self.date.layer.zPosition=1
                    self.myArtist.layer.zPosition=1
                    self.label.layer.zPosition=1
                }
                if let docAlbum=HTML(url: realUrl!, encoding: .utf8){
                    let infoAlbum=docAlbum.xpath("//strong[@class='tit']")
                    album.text=infoAlbum.first?.text!
                }
                if let docDate=HTML(url: realUrl!, encoding: .utf8){
                    let infoDate=docDate.xpath("//span[@class='date']")
                    date.text=infoDate.first?.text!
                }
                self.myArtist.setTitle(UserDefaults.standard.string(forKey: "myArtist"), for: .normal)
            }
        }
    }
    
    /*func searchProperArtist(action: UIAlertAction){
        
    }*/
    /*//문자열 비교
    var arrayArtistSearch=[String]()
    let url=URL(string: "http://music.naver.com/search/search.nhn?query="+input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!+"&x=0&y=0")
    if let doc=HTML(url: url!, encoding: .utf8){
        for i in doc.xpath("//ul[@class='lst_default_v2 lst_default_othermar']//dl[@class='lst_desc']//a/@alt"){
            arrayArtistSearch.append(i.text!)
        }
        let alert = UIAlertController(title: "아티스트 선택", message: "아티스트를 선택하세요.", preferredStyle: .alert)
        for j in arrayArtistSearch{
            alert.addAction(UIAlertAction(title: j, style: .default, handler: self.searchProperArtist))
        }
        self.present(alert, animated: true, completion: nil)
    }*/
}
