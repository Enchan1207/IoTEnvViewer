//
//  AddViewController.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    //--
    private var deviceID: Int = 0
    private var deviceName: String = ""
    
    //--components
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var nameField: UITextField!

    //--
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //--「完了」ボタンが押されたら、入力値をもとにデバイスを検索する
    @IBAction func ontapSubmit(_ sender: Any) {
        print("\(self.deviceID) : \(self.deviceName)")
        var device = getConfig(id:self.deviceID)
        
        if device != nil {
            print("device found.add device list.")
            device!.name = self.deviceName
            
            //--取得したデバイスをリストに追加して保存して戻る
            let deviceList = DeviceList()
            deviceList.loadList()
            //デバイスリストの中に追加を試みているデバイスがあればスキップ
            var stat: Bool = true
            for devinlist in deviceList.getDeviceList().Device_list {
                if(devinlist.deviceID == device!.deviceID){
                    stat = false
                }
            }
            if(stat){
                deviceList.addDevice(target: device!)
                deviceList.saveList()
            }else{
                print("Already exists")
            }
        }else{
            print("Invalid request")
        }
        self.navigationController?.popViewController(animated: true) //animatedはせ戻る時のアニメの有無か
    }
    
    //--デバイスのコンフィグを取得しDevice型で返す 指定IDのデバイスが存在しなければnilを返す
    func getConfig(id: Int) -> Device?{
        var responce: String? = nil
        let url = "https://enchan-lab.net/Enchan/api/IoTEnvLogger/getInfo.php"
        let param = "deviceID=\(id)"
        
        if let responceData = try? Data(contentsOf: URL(string: "\(url)?\(param)")!){
            responce = String(data: responceData, encoding: .utf8)!
        }else{
            print("error")
        }
        
        if(responce! != ""){
            return decodeDevice(source: responce!)
        }else{
            return nil
        }
    }
    
    //--Deviceをjsonデコード
    func decodeDevice(source:String) -> Device{
        //--StringをDataに変換し、JSONデコード(ret: devices)
        let jsonData = source.data(using: .utf8)
        return try! JSONDecoder().decode(Device.self, from: jsonData!)
    }
    
    //--フィールドの入力値をプロパティに投げる
    @IBAction func ontypedID(_ sender: Any) {
        let content = self.idField.text!
        if let typedValue = Int(content){
            self.deviceID = typedValue
        }else{
            self.deviceID = 0
        }
    }
    @IBAction func ontypedName(_ sender: Any) {
        let content = self.nameField.text!
        self.deviceName = content
    }
}
