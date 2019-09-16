//
//  LogViewCell.swift
//  IoTEnvViewer
//
//  Created by EnchantCode on 2019/09/14.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import UIKit

class LogViewCell: UITableViewCell {
    //--
    
    //--component
    @IBOutlet weak var data_1: UILabel!
    @IBOutlet weak var data_2: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //--
    func load(type: Int, target: MeasureData){
        //--device.latestをフォーマットする
        let latest = Date(timeIntervalSince1970: TimeInterval(target.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeStamp.text = dateFormatter.string(from: latest)
        
        //--typeによって読むデータを変える
        var data1 = "", data2 = ""
        switch type {
            
        case 0:
            //--温湿度センサ
            data1 = NSString(format: "%.1f", target.temp!) as String + "℃"
            data2 = NSString(format: "%.1f", target.humid!) as String + "%"
            break
            
        case 1:
            //--ドアセンサ
            data1 = "close"
            if(target.door!) {
                data1 = "open"
            }
            data2 = ""
            break
            
        case 2:
            //--人感センサ
            data1 = "none"
            if(target.human!) {
                data1 = "detect"
            }
            data2 = ""
            break
            
        default:
            data1 = "no data"
            data2 = "no data"
            break
        }
        
        self.data_1.text = data1
        self.data_2.text = data2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
