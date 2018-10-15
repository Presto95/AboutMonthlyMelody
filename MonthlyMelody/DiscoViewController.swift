//
//  DiscoViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 24..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna

class DiscoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pageRegularCount=2
    var pageIrregularCount=2
    var pageParticipateCount=2
    var arrayPageRegularCount=[String]()
    var arrayPageIrregularCount=[String]()
    var arrayPageParticipateCount=[String]()
    var array=[String]()
    var arrayRegular=[String]()
    var arrayIrregular=[String]()
    var arrayParticipate=[String]()
    var albumUrl:String=""
    @IBOutlet weak var tableView: UITableView!
    let arraySection=["정규", "비정규", "참여"]
    @IBOutlet weak var right: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        right.layer.zPosition=1
        /*let realUrl=UserDefaults.standard.url(forKey: "urlAlbumCover")
        if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.view.addSubview(backgroundImage)
            self.tableView.layer.zPosition=1
        }*/
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true
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
        if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.view.addSubview(backgroundImage)
            self.tableView.layer.zPosition=1
        }
        arrayPageRegularCount.removeAll()
        arrayPageIrregularCount.removeAll()
        arrayPageParticipateCount.removeAll()
        arrayRegular.removeAll()
        arrayIrregular.removeAll()
        arrayParticipate.removeAll()
        let artistUrlEncoding=UserDefaults.standard.string(forKey: "myArtist")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url=URL(string: "http://music.naver.com/search/search.nhn?query="+artistUrlEncoding!+"&x=0&y=0")
        if let doc=HTML(url: url!, encoding: .utf8){
            let info=doc.xpath("//dl[@class='lst_desc']//dd[@class='desc']//a/@href")
            albumUrl="http://music.naver.com"+(info.first?.text)!
            let urlRegular=URL(string: "http://music.naver.com"+(info.first?.text)!+"&filteringOptions=REGULAR&sorting=newRelease&page=1")
            if let doc=HTML(url: urlRegular!, encoding: .utf8){
                for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                    arrayRegular.append(info.text!)
                }
                for info2 in doc.xpath("//div[@class='paginate2']//a | //div[@class='paginate2']//strong"){
                    arrayPageRegularCount.append(info2.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            let urlIrregular=URL(string: "http://music.naver.com"+(info.first?.text)!+"&filteringOptions=IRREGULAR&sorting=newRelease&page=1")
            if let doc=HTML(url: urlIrregular!, encoding: .utf8){
                for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                    arrayIrregular.append(info.text!)
                }
                for info2 in doc.xpath("//div[@class='paginate2']//a | //div[@class='paginate2']//strong"){
                    arrayPageIrregularCount.append(info2.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            let urlParticipate=URL(string: "http://music.naver.com"+(info.first?.text)!+"&filteringOptions=PARTICIPATION&sorting=newRelease&page=1")
            if let doc=HTML(url: urlParticipate!, encoding: .utf8){
                for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                    arrayParticipate.append(info.text!)
                }
                for info2 in doc.xpath("//div[@class='paginate2']//a | //div[@class='paginate2']//strong"){
                    arrayPageParticipateCount.append(info2.text!.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
        if(arrayPageRegularCount.count==0){
            arrayPageRegularCount.append("1")
        }
        else if(arrayPageRegularCount.count==1){
            
        }
        else{
            arrayPageRegularCount.removeLast()
            arrayPageRegularCount.removeFirst(arrayPageRegularCount.count-1)
        }
        if(arrayPageIrregularCount.count==0){
            arrayPageIrregularCount.append("1")
        }
        else if(arrayPageIrregularCount.count==1){
            
        }
        else{
            arrayPageIrregularCount.removeLast()
            arrayPageIrregularCount.removeFirst(arrayPageIrregularCount.count-1)
        }
        if(arrayPageParticipateCount.count==0){
            arrayPageParticipateCount.append("1")
        }
        else if(arrayPageParticipateCount.count==1){
            
        }
        else{
            arrayPageParticipateCount.removeLast()
            arrayPageParticipateCount.removeFirst(arrayPageParticipateCount.count-1)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return arrayRegular.count/4
        case 1:
            return arrayIrregular.count/4
        case 2:
            return arrayParticipate.count/4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arraySection[section] as String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! DiscoTableViewCell
        switch(indexPath.section){
        //정규
        case 0:
            cell.albumcover.downloadImageFrom(arrayRegular[indexPath.row*4], contentMode: .scaleAspectFit)
            cell.album.text=arrayRegular[indexPath.row*4+1]
            cell.artist.text=arrayRegular[indexPath.row*4+2]
            cell.date.text=arrayRegular[indexPath.row*4+3]
            if(indexPath.row==self.arrayRegular.count/4-1 && pageRegularCount<=Int(arrayPageRegularCount[0])!){
                let url=URL(string: albumUrl+"&filteringOptions=REGULAR&sorting=newRelease&page="+String(pageRegularCount))
                pageRegularCount=pageRegularCount+1
                if let doc=HTML(url: url!, encoding: .utf8){
                    for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                        arrayRegular.append(info.text!)
                    }
                }
                tableView.reloadData()
                cell.albumcover.downloadImageFrom(arrayRegular[indexPath.row*4], contentMode: .scaleAspectFit)
                cell.album.text=arrayRegular[indexPath.row*4+1]
                cell.artist.text=arrayRegular[indexPath.row*4+2]
                cell.date.text=arrayRegular[indexPath.row*4+3]
            }
        //비정규
        case 1:
            cell.albumcover.downloadImageFrom(arrayIrregular[indexPath.row*4], contentMode: .scaleAspectFit)
            cell.album.text=arrayIrregular[indexPath.row*4+1]
            cell.artist.text=arrayIrregular[indexPath.row*4+2]
            cell.date.text=arrayIrregular[indexPath.row*4+3]
            if(indexPath.row==self.arrayIrregular.count/4-1 && pageIrregularCount<=Int(arrayPageIrregularCount[0])!){
                let url=URL(string: albumUrl+"&filteringOptions=IRREGULAR&sorting=newRelease&page="+String(pageIrregularCount))
                pageIrregularCount=pageIrregularCount+1
                if let doc=HTML(url: url!, encoding: .utf8){
                    for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                        arrayIrregular.append(info.text!)
                    }
                }
                tableView.reloadData()
                cell.albumcover.downloadImageFrom(arrayIrregular[indexPath.row*4], contentMode: .scaleAspectFit)
                cell.album.text=arrayIrregular[indexPath.row*4+1]
                cell.artist.text=arrayIrregular[indexPath.row*4+2]
                cell.date.text=arrayIrregular[indexPath.row*4+3]
            }
        //참여
        case 2:
            cell.albumcover.downloadImageFrom(arrayParticipate[indexPath.row*4], contentMode: .scaleAspectFit)
            cell.album.text=arrayParticipate[indexPath.row*4+1]
            cell.artist.text=arrayParticipate[indexPath.row*4+2]
            cell.date.text=arrayParticipate[indexPath.row*4+3]
            if(indexPath.row==self.arrayParticipate.count/4-1 && pageParticipateCount<=Int(arrayPageParticipateCount[0])!){
                let url=URL(string: albumUrl+"&filteringOptions=PARTICIPATION&sorting=newRelease&page="+String(pageParticipateCount))
                pageParticipateCount=pageParticipateCount+1
                if let doc=HTML(url: url!, encoding: .utf8){
                    for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                        arrayParticipate.append(info.text!)
                    }
                }
                tableView.reloadData()
                cell.albumcover.downloadImageFrom(arrayParticipate[indexPath.row*4], contentMode: .scaleAspectFit)
                cell.album.text=arrayParticipate[indexPath.row*4+1]
                cell.artist.text=arrayParticipate[indexPath.row*4+2]
                cell.date.text=arrayParticipate[indexPath.row*4+3]
            }
        default:
            break
        }
        cell.backgroundColor=UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath) as! DiscoTableViewCell
        tableView.deselectRow(at: indexPath, animated: true)
        let artistUrlEncoding=cell.artist.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let albumUrlEncoding=cell.album.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let keywordUrlEncoding=artistUrlEncoding! + albumUrlEncoding!
        let url=URL(string: "http://music.naver.com/search/search.nhn?query="+keywordUrlEncoding+"&target=album")
        if let doc=HTML(url: url!, encoding: .utf8){
            if let _=doc.xpath("//a[@title='"+cell.album.text!+"']/@href").first?.text{
                let nextView=storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                nextView.albumPassed=cell.album.text!
                nextView.artistPassed=cell.artist.text!
                navigationController?.pushViewController(nextView, animated: true)
            }
            else{
                let alert=UIAlertController(title: "오류", message: "파싱된 정보를 찾을 수 없습니다.", preferredStyle: .alert)
                let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                    return
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
