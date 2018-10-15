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

class GalleryCollectionViewController: UICollectionViewController {

    private var keyword: String=""
    private var arrayImgSource=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url2=URL(string: "https://music.naver.com/artist/album.nhn?artistId=182&page=1")
        if let docAlbumCover=HTML(url: url2!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            //self.tableView.backgroundView=backgroundImage
            self.collectionView?.backgroundView=backgroundImage
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayImgSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        cell.image.downloadImageFrom(arrayImgSource[indexPath.row], contentMode: .scaleAspectFit)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
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
                
            }
            self.collectionView?.reloadData()
        }
        let noAction=UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert,animated: true, completion: nil)
    }

}
