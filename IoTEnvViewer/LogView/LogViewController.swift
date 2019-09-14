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
        
        //--サーバからデータを持ってくる
        
        fetchMeasureData(targetID:self.device.deviceID)
        fetchGraph(targetID: self.device.deviceID)
    }
    
    //--deviceIDをキーにして測定ログをfetch
    func fetchMeasureData(targetID: Int){
        var logs: Measurelog = Measurelog()
        let fetch: String = """
            {
                "log" : [
                    {
                        "temp" : 25.4,
                        "humid" : 23.3,
                        "timestamp" : 1568364449
                    },
                    {
                        "temp" : 32.1,
                        "humid" : 24.5,
                        "timestamp" : 1568364449
                    }
                ]
            }
        """
        logs.decodeData(source: fetch)
        self.measureLog = logs.getMeasureLogs()
    }
    
    //--deviceIDをキーにしてグラフをfetch
    func fetchGraph(targetID: Int){
        loadIndicator.startAnimating()
        DispatchQueue.global().async {
            //--サーバに接続し、グラフ画像データを取得
            Thread.sleep(forTimeInterval: 5)
            
            DispatchQueue.main.async {
                self.loadIndicator.stopAnimating()
            }
        }
        
    }
    
    //--デバイスを受け渡す(セッター)
    func setDevice(target: Device){
        self.device = target
    }
    
    //--
    @IBAction func onLengthChange(_ sender: Any) {
        let selectedIndex = self.sizeSelector.selectedSegmentIndex
        self.fetchlength = Int(self.sizeSelector.titleForSegment(at: selectedIndex)!)!
        
        fetchMeasureData(targetID: self.device.deviceID)
        fetchGraph(targetID: self.device.deviceID)
    }
}

//--
extension LogViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measureLog.log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.logView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LogViewCell
        cell.load(type: self.device.type, target: self.measureLog.log[indexPath.row])
        return cell
    }
}
