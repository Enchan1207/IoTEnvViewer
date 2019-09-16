//
//  LogViewController.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    //--
    private var device: Device = Device()
    private var fetchlength = 10
    private var measureLog: MeasureLogs = MeasureLogs()

    //--components
    @IBOutlet weak var nameNavBar: UINavigationItem!
    @IBOutlet weak var sizeSelector: UISegmentedControl!
    @IBOutlet weak var logView: UITableView!
    @IBOutlet weak var dataGraph: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--logViewの設定
        self.logView.dataSource = self
        let customcell = UINib(nibName: "LogViewCell", bundle: nil);
        self.logView.register(customcell, forCellReuseIdentifier: "cell");
        
        //--navにデバイス名をセット
        self.nameNavBar.title = device.name
        
        reflesh() //データを更新
    }
    
    //--
    @IBAction func ontapReflesh(_ sender: Any) {
        reflesh() //データを更新
    }
    
    
    //--
    func reflesh(){
        //--サーバからデータを持ってくる
        fetchMeasureData(targetID:self.device.deviceID)
        fetchGraph(targetID: self.device.deviceID)
        self.logView.reloadData()
    }
    
    //--deviceIDをキーにして測定ログをfetch
    func fetchMeasureData(targetID: Int){
        var logs: Measurelog = Measurelog()
        var responce: String? = nil
        
        let url = "https://enchan-lab.net/Enchan/api/IoTEnvLogger/getMeasureData.php"
        let param = "deviceID=\(targetID)&length=\(self.fetchlength)"
        
        if let responceData = try? Data(contentsOf: URL(string: "\(url)?\(param)")!){
            responce = String(data: responceData, encoding: .utf8)!
        }else{
            print("error")
        }
        
        logs.decodeData(source: responce!)
        self.measureLog = logs.getMeasureLogs()
    }
    
    //--deviceIDをキーにしてグラフをfetch
    func fetchGraph(targetID: Int){
        var graph: UIImage = UIImage() //空の画像作っとくべきよ
        loadIndicator.startAnimating()
        
        DispatchQueue.global().async {
            //--グラフ画像データを取得
            let url = "https://enchan-lab.net/Enchan/api/IoTEnvLogger/drawGraph.php"
            let param = "deviceID=\(targetID)&length=\(self.fetchlength)"
            if let responceData = try? Data(contentsOf: URL(string: "\(url)?\(param)")!){
                graph = UIImage(data: responceData)!
            }else{
                print("error")
            }
            
            DispatchQueue.main.async {
                self.loadIndicator.stopAnimating()
                self.dataGraph.image = graph
            }
        }
        
    }
    
    //--デバイスを受け渡す(セッター)
    func setDevice(target: Device){
        self.device = target
    }
    
    //--フェッチデータ数が変わった時の処理
    @IBAction func onLengthChange(_ sender: Any) {
        let selectedIndex = self.sizeSelector.selectedSegmentIndex
        self.fetchlength = Int(self.sizeSelector.titleForSegment(at: selectedIndex)!)!
        
        reflesh()
    }
}

//--
extension LogViewController: UITableViewDataSource{
    //--セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measureLog.log.count
    }
    
    //--カスタムセル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.logView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogViewCell
        cell.load(type: self.device.type, target: self.measureLog.log[indexPath.row])
        return cell
    }
    
    //--カスタムセルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
