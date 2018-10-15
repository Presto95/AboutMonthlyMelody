//
//  GalleryCollectionViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 24..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna

private let reuseIdentifier = "imageCell"

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var keyword: String=""
    private var arrayImgSource=[String]()
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let docAlbumCover=HTML(url: realUrl!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.view.addSubview(backgroundImage)
            self.collectionView.layer.zPosition=1
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
    }
    override func viewDidDisappear(_ animated: Bool) {
        myActivityIndicator.removeFromSuperview()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImgSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.image.downloadImageFrom(arrayImgSource[indexPath.row], contentMode: .scaleAspectFill)
        cell.backgroundColor=UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        let newImageView=UIImageView(image: cell.image.image)
        newImageView.layer.zPosition=1
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(GalleryViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
  
    @IBAction func clickSearch(_ sender: UIBarButtonItem) {
        arrayImgSource.removeAll()
        let alert=UIAlertController(title: "검색", message: "검색 키워드를 입력하세요.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        let yesAction=UIAlertAction(title: "확인", style: UIAlertActionStyle.default){(action: UIAlertAction)-> Void in
            if let input=alert.textFields![0].text{
                self.keyword=input
                let keywordToUrlEncoding=self.keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url=URL(string: "https://search.naver.com/search.naver?where=image&sm=tab_jum&ie=utf8&query="+keywordToUrlEncoding!)
                if let doc=HTML(url: url!, encoding: .utf8){
                    for info in doc.xpath("//img[@class='_img']/@data-source"){
                        self.arrayImgSource.append(info.text!)
                    }
                }
                if(self.arrayImgSource.isEmpty){
                    let alert=UIAlertController(title: "알림", message: "검색 결과가 없습니다.", preferredStyle: .alert)
                    let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                        return
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)

                }
                
            }
            self.collectionView.reloadData()
        }
        let noAction=UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert,animated: true, completion: nil)
    }
}

