//
//  MeasureLogs.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import Foundation

//--
struct MeasureLogs:Codable {
    var log: [MeasureData] = []
}

//--
class Measurelog{
    //--
    private var logs: MeasureLogs = MeasureLogs()
    
    //--測定データをjsonデコード
    func decodeData(source:String){
        //--StringをDataに変換し、JSONデコード(ret: devices)
        let jsonData = source.data(using: .utf8)
        logs = try! JSONDecoder().decode(MeasureLogs.self, from: jsonData!)
    }
    
    //--測定データをjsonエンコード
    func encodeData() -> String?{
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(logs)
            let jsonstr:String = String(data: data, encoding: .utf8)!
            return jsonstr
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //--測定データを取得
    func getMeasureLogs() -> MeasureLogs{
        return self.logs
    }
}
