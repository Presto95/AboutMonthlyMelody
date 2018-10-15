//
//  ChartViewController.swift
//  MonthlyMelody
//
//  Created by Presto on 2017. 8. 22..
//  Copyright © 2017년 Presto. All rights reserved.
//

import UIKit
import Kanna

class ChartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var buttonSearch: UIBarButtonItem!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var information: UILabel!
    
    var defaults:String=""
    
    var arrayAlbumCover=[String]()
    var arrayMelon=[String]()
    var arrayGenie=[String]()
    var arrayBugs=[String]()
    var arrayMnet=[String]()
    var arrayNaver=[String]()
    var arraySoribada=[String]()
    var arrayArtist=[String]()
    var selectedArtist:String=""
    var dimmingView: UIView?=nil
    let arraySection=["멜론", "지니", "벅스", "엠넷", "네이버뮤직", "소리바다"]
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minute=currentMinute()
        if(minute=="59" || minute=="01" || minute=="02"){
            let alert=UIAlertController(title: "알림", message: "현재 실시간 순위 업데이트 중입니다.\n잠시 후 다시 시도하세요.", preferredStyle: .alert)
            let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                return
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(dimmingView!)
        dimmingView?.isHidden = true
        let url=URL(string: "http://www.kpopchart.kr/?a=")
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//select[@class='aritstSelectBox']//option"){
                arrayArtist.append(info.text!)
            }
        }
        arrayArtist.remove(at: 0)
        dateAndTime.text=currentDate() + " " + currentTime()
        let pickerViewRow = UserDefaults.standard.integer(forKey: "pickerViewRow")
        let url2=URL(string: "http://www.kpopchart.kr/?a=" + arrayArtist[pickerViewRow].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//img[@class='data-albumimage']/@src"){
                arrayAlbumCover.append(info.text!)
            }
        }
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MELON']/@data-songname | //div[@data-site='MELON']/@data-rank"){
                arrayMelon.append(info.text!)
            }
        }
        //각 음원사별로 데이터를 따로따로 어레이에 저장해서 각 섹션에 표시
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='GENIE']/@data-songname | //div[@data-site='GENIE']/@data-rank"){
                arrayGenie.append(info.text!)
            }
        }
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='BUGS']/@data-songname | //div[@data-site='BUGS']/@data-rank"){
                arrayBugs.append(info.text!)
            }
        }
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MNET']/@data-songname | //div[@data-site='MNET']/@data-rank"){
                arrayMnet.append(info.text!)
            }
        }
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='NAVER']/@data-songname | //div[@data-site='NAVER']/@data-rank"){
                arrayNaver.append(info.text!)
            }
        }
        if let doc=HTML(url: url2!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='SORIBADA']/@data-songname | //div[@data-site='SORIBADA']/@data-rank"){
                arraySoribada.append(info.text!)
            }
        }
        self.chartTableView.reloadData()
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
            self.chartTableView.layer.zPosition=1
            self.dateAndTime.layer.zPosition=1
            self.information.layer.zPosition=1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:
            return arrayMelon.count/2
        case 1:
            return arrayGenie.count/2
        case 2:
            return arrayBugs.count/2
        case 3:
            return arrayMnet.count/2
        case 4:
            return arrayNaver.count/2
        case 5:
            return arraySoribada.count/2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! ChartTableViewCell
        switch(indexPath.section){
        case 0:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row], contentMode: .scaleAspectFit)
            cell.title.text=arrayMelon[indexPath.row*2]
            cell.rank.text=arrayMelon[indexPath.row*2+1]
        case 1:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row + arrayMelon.count/2], contentMode: .scaleAspectFit)
            cell.title.text=arrayGenie[indexPath.row*2]
            cell.rank.text=arrayGenie[indexPath.row*2+1]
        case 2:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row + arrayMelon.count/2 + arrayGenie.count/2], contentMode: .scaleAspectFit)
            cell.title.text=arrayBugs[indexPath.row*2]
            cell.rank.text=arrayBugs[indexPath.row*2+1]
        case 3:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row + arrayMelon.count/2 + arrayGenie.count/2 + arrayBugs.count/2].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, contentMode: .scaleAspectFit)
            cell.title.text=arrayMnet[indexPath.row*2]
            cell.rank.text=arrayMnet[indexPath.row*2+1]
        case 4:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row + arrayMelon.count/2 + arrayGenie.count/2 + arrayBugs.count/2 + arrayMnet.count/2], contentMode: .scaleAspectFit)
            cell.title.text=arrayNaver[indexPath.row*2]
            cell.rank.text=arrayNaver[indexPath.row*2+1]
        case 5:
            cell.albumcover.downloadImageFrom("http://www.kpopchart.kr"+arrayAlbumCover[indexPath.row + arrayMelon.count/2 + arrayGenie.count/2 + arrayBugs.count/2 + arrayMnet.count/2 + arrayNaver.count/2], contentMode: .scaleAspectFit)
            cell.title.text=arraySoribada[indexPath.row*2]
            cell.rank.text=arraySoribada[indexPath.row*2+1]
        default:
            break
        }
        cell.backgroundColor=UIColor.clear
        
        return cell
    }

    @IBAction func searchArtist(_ sender: UIBarButtonItem) {
        let minute=currentMinute()
        if(minute=="59" || minute=="01" || minute=="02"){
            let alert=UIAlertController(title: "알림", message: "차트가 보이지 않는 경우 1~2분 후 다시 시도해 주세요.", preferredStyle: .alert)
            let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                return
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        dimmingView?.isHidden=false
        dimmingView?.layer.zPosition=1
        buttonSearch.isEnabled=false
        buttonRefresh.isEnabled=false
        if let items = self.tabBarController?.tabBar.items {
            for i in 0..<5{
                items[i].isEnabled=false
            }
        }
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: view.frame.height-400, width: view.frame.width, height: 400))
        picker.backgroundColor = .white
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("donePicker")))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("donePicker")))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        picker.selectRow(UserDefaults.standard.integer(forKey: "pickerViewRow"), inComponent: 0, animated: true)
        picker.backgroundColor=UIColor.clear
        picker.layer.zPosition=1
        self.view.addSubview(picker)
    }
    
    @IBAction func refreshChart(_ sender: UIBarButtonItem) {
        dateAndTime.text=currentDate() + " " + currentTime()
        let minute=currentMinute()
        if(minute=="59" || minute=="01" || minute=="02"){
            let alert=UIAlertController(title: "알림", message: "현재 실시간 순위 업데이트 중입니다.\n잠시 후 다시 시도하세요.", preferredStyle: .alert)
            let action=UIAlertAction(title: "확인", style: .default){(action: UIAlertAction)-> Void in
                return
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        arrayAlbumCover.removeAll()
        arrayMelon.removeAll()
        arrayGenie.removeAll()
        arrayBugs.removeAll()
        arrayMnet.removeAll()
        arrayNaver.removeAll()
        arraySoribada.removeAll()
        let pickerViewRow = UserDefaults.standard.integer(forKey: "pickerViewRow")
        let url=URL(string: "http://www.kpopchart.kr/?a=" + arrayArtist[pickerViewRow].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//img[@class='data-albumimage']/@src"){
                arrayAlbumCover.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MELON']/@data-songname | //div[@data-site='MELON']/@data-rank"){
                arrayMelon.append(info.text!)
            }
        }
        //각 음원사별로 데이터를 따로따로 어레이에 저장해서 각 섹션에 표시
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='GENIE']/@data-songname | //div[@data-site='GENIE']/@data-rank"){
                arrayGenie.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='BUGS']/@data-songname | //div[@data-site='BUGS']/@data-rank"){
                arrayBugs.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MNET']/@data-songname | //div[@data-site='MNET']/@data-rank"){
                arrayMnet.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='NAVER']/@data-songname | //div[@data-site='NAVER']/@data-rank"){
                arrayNaver.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='SORIBADA']/@data-songname | //div[@data-site='SORIBADA']/@data-rank"){
                arraySoribada.append(info.text!)
            }
        }
        self.chartTableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString: NSAttributedString!
        attributedString=NSAttributedString(string: arrayArtist[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayArtist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayArtist[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let items = self.tabBarController?.tabBar.items {
            for i in 0..<5{
                items[i].isEnabled=true
            }
        }
        buttonSearch.isEnabled=true
        buttonRefresh.isEnabled=true
        dimmingView?.isHidden=true
        arrayAlbumCover.removeAll()
        arrayMelon.removeAll()
        arrayGenie.removeAll()
        arrayBugs.removeAll()
        arrayMnet.removeAll()
        arrayNaver.removeAll()
        arraySoribada.removeAll()
        selectedArtist=arrayArtist[row]
        let artistUrlEncoding=selectedArtist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url=URL(string: "http://www.kpopchart.kr/?a="+artistUrlEncoding!)
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//img[@class='data-albumimage']/@src"){
                arrayAlbumCover.append(info.text!)
            }
        }
        //각 음원사별로 데이터를 따로따로 어레이에 저장해서 각 섹션에 표시
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MELON']/@data-songname | //div[@data-site='MELON']/@data-rank"){
                arrayMelon.append(info.text!)
            }
        }
        //각 음원사별로 데이터를 따로따로 어레이에 저장해서 각 섹션에 표시
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='GENIE']/@data-songname | //div[@data-site='GENIE']/@data-rank"){
                arrayGenie.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='BUGS']/@data-songname | //div[@data-site='BUGS']/@data-rank"){
                arrayBugs.append(info.text!)
                
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='MNET']/@data-songname | //div[@data-site='MNET']/@data-rank"){
                arrayMnet.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='NAVER']/@data-songname | //div[@data-site='NAVER']/@data-rank"){
                arrayNaver.append(info.text!)
            }
        }
        if let doc=HTML(url: url!, encoding: .utf8){
            for info in doc.xpath("//div[@data-site='SORIBADA']/@data-songname | //div[@data-site='SORIBADA']/@data-rank"){
                arraySoribada.append(info.text!)
            }
        }
        UserDefaults.standard.set(row, forKey: "pickerViewRow")
        self.chartTableView.reloadData()
        pickerView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.arraySection[section] as String
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func currentDate()->String{
        let today=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy년 M월 d일"
        let dateString=dateFormatter.string(from: today)
        return dateString
    }
    
    func currentTime()->String{
        let now=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="HH시"
        return dateFormatter.string(from: now)
    }
    
    func currentMinute()->String{
        let now=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="mm"
        return dateFormatter.string(from: now)
    }
    
    func makeAddress()->String{
        let raw=Date()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyyMMddHH"
        let address=dateFormatter.string(from: raw)
        return address
    }

}
