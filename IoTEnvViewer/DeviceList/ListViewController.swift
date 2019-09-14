//
//  ViewController.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import UIKit

//--デバイスリスト表示
class ListViewController: UIViewController {
    //--
    private var deviceList: Devices = Devices()
    private let handler = UserDefaults.standard
    
    //--components
    @IBOutlet weak var ListView: UITableView!
    
    //--
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--UITableViewの設定
        self.ListView.delegate = self
        self.ListView.dataSource = self
        let customcell = UINib(nibName: "ListViewCell", bundle: nil);
        self.ListView.register(customcell, forCellReuseIdentifier: "cell");
        
        //--デバイスリスト読み込み
        let list: DeviceList = DeviceList()
        
        if let dlistjson = handler.object(forKey: "devicelist") as! String?{
            list.decodeList(source: dlistjson)
            self.deviceList = list.getDeviceList()
        }else{
            print("no device list");
        }
        
        //--アプリがバックグラウンドに遷移したとき、デバイスリストを保存する
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(ListViewController.saveDeviceList),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    //--現在のデバイスリストを保存
    @objc func saveDeviceList() {
        if(self.deviceList.Device_list.count != 0){
            handler.set(self.deviceList, forKey: "devicelist")
        }else{
            print("no data")
        }
    }
}

//--
extension ListViewController: UITableViewDelegate{
    //--セル選択時、各デバイスの測定ログ閲覧画面に遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //--遷移先のページを指定
        let next = self.storyboard?.instantiateViewController(withIdentifier: "LogScreen") as! LogViewController;
        next.setDevice(target: self.deviceList.Device_list[indexPath.row])
        show(next, sender: nil);
    }
}

//--
extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceList.Device_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ListView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListViewCell
        cell.load(device: self.deviceList.Device_list[indexPath.row])
        return cell
    }
}
