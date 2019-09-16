//
//  DeviceList.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import Foundation

//--測定データ　このstructで測定データ配列作ってもいいかもね
struct MeasureData: Codable {
    var timestamp: Int = 0
    var temp: Float? = 0.00
    var humid: Float? = 0.00
    var door: Bool? = false
    var human: Bool? = false
}
//--デバイス情報
struct Device: Codable {
    var name:String = ""
    var deviceID: Int  = 0
    var type: Int = 0
    var lastData: MeasureData = MeasureData()
}
//--デバイスリスト
struct Devices: Codable{
    var Device_list: [Device] = []
}

class DeviceList{
    //--
    private var devices: Devices = Devices()
    private var handler = UserDefaults.standard

    //--デバイスリストをjsonデコード
    func decodeList(source:String){
        //--StringをDataに変換し、JSONデコード(ret: devices)
        let jsonData = source.data(using: .utf8)
        devices = try! JSONDecoder().decode(Devices.self, from: jsonData!)
    }
    
    //--デバイスリストをjsonエンコード
    func encodeList() -> String?{
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(devices)
            let jsonstr:String = String(data: data, encoding: .utf8)!
            return jsonstr
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //--デバイスリストをUDから読み込む
    func loadList(){
        if let dlistjson = handler.object(forKey: "devicelist") as! String?{
            decodeList(source: dlistjson)
            devices = getDeviceList()
        }else{
            print("no device list");
        }
    }
    
    //--UDにデバイスリストを保存
    func saveList(){
        handler.set(encodeList(), forKey: "devicelist")
    }
    
    //--デバイスリストの測定データ周りを更新
    func update(){
        //--for-in文の中はスコープが違うため、一回コピーして戻す
        for i in 0..<(devices.Device_list.count) {
            //--各デバイス毎に測定データを一つだけもらってくる
            var logs: Measurelog = Measurelog()
            var responce: String? = nil
            
            let url = "https://enchan-lab.net/Enchan/api/IoTEnvLogger/getMeasureData.php"
            let param = "deviceID=\(devices.Device_list[i].deviceID)&length=1"
            
            if let responceData = try? Data(contentsOf: URL(string: "\(url)?\(param)")!){
                responce = String(data: responceData, encoding: .utf8)!
            }else{
                print("error")
            }
            
            logs.decodeData(source: responce!)
            devices.Device_list[i].lastData = logs.getMeasureLogs().log[0]
        }
    }
    
    //--デバイスリストを祈雨造替から設定
    func setDeviceList(devices_: Devices){
        self.devices = devices_
    }
    
    //--デバイスリストを取得
    func getDeviceList() -> Devices{
        return self.devices
    }
    
    //--デバイスをリストに追加
    func addDevice(target: Device){
        devices.Device_list += [target]
    }
    
    //--指定インデックスのデバイスをリストから削除
    func removeDevice(index: Int){
        devices.Device_list.remove(at: index)
    }
    
}
