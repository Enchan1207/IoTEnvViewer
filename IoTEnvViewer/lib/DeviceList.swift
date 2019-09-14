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
