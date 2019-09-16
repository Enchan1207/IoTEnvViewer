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
    private let list: DeviceList = DeviceList()
    
    //--components
    fileprivate let refreshCtl = UIRefreshControl()
    @IBOutlet weak var ListView: UITableView!
    
    //--didloadだとアプリ起動時にしか実行されないので、viewWillappearで
    override func viewWillAppear(_ animated: Bool) {
        //--デバイスリスト読み込み + 更新
        loadDeviceList()
        refreshDeviceList()
    }
    
    //--アプリ起動時の設定
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--UITableViewの設定
        self.ListView.delegate = self
        self.ListView.dataSource = self
        let customcell = UINib(nibName: "ListViewCell", bundle: nil);
        self.ListView.register(customcell, forCellReuseIdentifier: "cell");
        
        //--アプリがバックグラウンドに遷移したとき、デバイスリストを保存する
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(ListViewController.saveDeviceList),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        //--RefleshControlの設定
        self.ListView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(ListViewController.refresh(sender:)), for: .valueChanged)
    }
    
    //--UITableViewを引っ張った時に呼び出される関数
    @objc func refresh(sender: UIRefreshControl) {
        //--
        refreshDeviceList()
        refreshCtl.endRefreshing()
    }
    
    //--デバイスリスト読み込み
    func loadDeviceList(){
        list.loadList()
        deviceList = list.getDeviceList()
        self.ListView.reloadData()
    }
    
    //--現在のデバイスリストを保存
    @objc func saveDeviceList() {
        list.saveList()
    }
    
    //--デバイスリストの測定データ周りを更新
    func refreshDeviceList(){
        list.update()
        deviceList = list.getDeviceList()
        self.ListView.reloadData()
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
    
    //--スワイプ削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.removeDevice(index: indexPath.row)
            list.saveList()
            list.loadList()
            deviceList = list.getDeviceList()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            ListView.reloadData();
        }
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
    
    //--カスタムセルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96;
    }
}
