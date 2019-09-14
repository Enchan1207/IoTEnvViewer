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
            
        }else{
            print("Invalid request")
        }
    }
    
    //--デバイスのコンフィグを取得しDevice型で返す
    func getConfig(id: Int) -> Device?{
        return Device(name: "", deviceID: id, type: 0, lastData: MeasureData(timestamp: 0, temp: 23.3, humid: 23.3, door: nil, human: nil))
        
//        return nil
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
