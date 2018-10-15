//
//  BiographyTableViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 22..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna




class DiscoTableViewController: UITableViewController {
    
    var pageCount=2 //페이지 수
    var array=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.contentInset=UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let url2=URL(string: "https://music.naver.com/artist/album.nhn?artistId=182&page=1")
        if let docAlbumCover=HTML(url: url2!, encoding: .utf8){
            let infoAlbumCover=docAlbumCover.xpath("//img[@width='228']/@src")
            let backgroundImage=UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.downloadImageFrom((infoAlbumCover.first?.text!)!, contentMode: .scaleToFill)
            backgroundImage.addBlurEffect()
            self.tableView.backgroundView=backgroundImage
        }
        
        /*for i in 0..<10{
            let url=URL(string: "http://music.naver.com/artist/album.nhn?artistId=182&page="+String(i))
            if let doc=HTML(url: url!, encoding: .utf8){
                for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                    array.append(info.text!)
                }
            }
        }*/
        let url=URL(string: "http://music.naver.com/artist/album.nhn?artistId=182&page=1")
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                array.append(info.text!)
            }
        }
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.navigationController?.navigationBar.isTranslucent=true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count/4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! DiscoTableViewCell
        
        //테스트
        if(array.count != 0){
            cell.albumcover.downloadImageFrom(array[indexPath.row*4], contentMode: .scaleAspectFit)
            cell.album.text=array[indexPath.row*4+1]
            cell.artist.text=array[indexPath.row*4+2]
            cell.date.text=array[indexPath.row*4+3]
            //array.removeFirst(3)
        }
        
        if(indexPath.row==self.array.count/4 - 1 && pageCount<=9){
            //2페이지..9페이지
            
            let url=URL(string: "http://music.naver.com/artist/album.nhn?artistId=182&page="+String(pageCount))
            pageCount=pageCount+1
            if let doc=HTML(url: url!, encoding: .utf8){
                for info in doc.xpath("//img[@alt='앨범 커버']/@src | //strong[@class='tit'] | //span[@class='name'] | //span[@class='date']"){
                    array.append(info.text!)
                }
                // //div[@class='data-songname']/@data-site | //div[@class='data-songname']/@data-songname | //div[@class='data-songname']/@data-rank
            }
            tableView.reloadData()
            cell.albumcover.downloadImageFrom(array[indexPath.row*4], contentMode: .scaleAspectFit)
            cell.album.text=array[indexPath.row*4+1]
            cell.artist.text=array[indexPath.row*4+2]
            cell.date.text=array[indexPath.row*4+3]
            
        }
        cell.backgroundColor=UIColor.clear
        return cell
    }
    
    /*override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement=array.count/4 - 1
        if !loaindg
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell=tableView.cellForRow(at: indexPath) as! DiscoTableViewCell
        let alert=UIAlertController(title: cell.album.text!, message: cell.date.text!, preferredStyle: .alert)
        let action=UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true, completion: nil)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
