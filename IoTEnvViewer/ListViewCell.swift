//
//  ListViewCell.swift
//  TableViewEx
//
//  Created by EnchantCode on 2019/08/21.
//  Copyright © 2019 EnchantCode. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    //--
    private let iconname:[String] = ["TempHumid", "Door", "Human"]
    
    //--components
    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latestLabel: UILabel!
    @IBOutlet weak var dataLabel_1: UILabel!
    @IBOutlet weak var dataLabel_2: UILabel!
    
    //--データセット
    func load(device: Device){
        nameLabel.text = device.name
        typeIcon.image = UIImage(named: iconname[device.type])
        
        //--device.latestをフォーマットする
        let latest = Date(timeIntervalSince1970: TimeInterval(device.lastData.timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        latestLabel.text = dateFormatter.string(from: latest)
        
        //--測定データjsonから実際に表示するデータに変換
        var data1 = "", data2 = ""
        switch device.type {
            
        case 0:
            //--温湿度センサ
            let temp = device.lastData.temp
            let humid = device.lastData.humid
            if(temp != nil && humid != nil){
                data1 = NSString(format: "%.1f", temp!) as String + "℃"
                data2 = NSString(format: "%.1f", humid!) as String + "%"
            }else{
                data1 = "no data"
                data2 = "no data"
            }
            break
            
        case 1:
            //--ドアセンサ
            let door = device.lastData.door
            if(door != nil){
                data1 = "close"
                if(door!) {
                    data1 = "open"
                }
                data2 = ""
            }else{
                data1 = "no data"
            }
            break
            
        case 2:
            //--人感センサ
            let human = device.lastData.human
            if(human != nil){
                data1 = "none"
                if(device.lastData.human!) {
                    data1 = "detect"
                }
                data2 = ""
            }else{
                data1 = "no data"
                data2 = "no data"
            }
            break
            
        default:
            data1 = "no data"
            data2 = "no data"
            break
        }
        
        self.dataLabel_1.text = data1
        self.dataLabel_2.text = data2
    }
    
    //--
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //--
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
