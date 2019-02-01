//
//  Networker.swift
//  raspi-alarm
//
//  Created by Janek Szynal on 23.12.2018.
//  Copyright © 2018 Janek Szynal. All rights reserved.
//

import Foundation
import Alamofire

struct Networker {
//    let raspberryWebAddress = "https://bibo.serveo.net"
    let raspberryWebAddress = "http://192.168.178.199:3141"

    func sendScheduleRequestToServer(minutes: String, hours: String, mode: MusicMode, completion: @escaping (String)->()){
        AF.request(raspberryWebAddress + "/cronsave",
                   method: .post,
                   parameters: ["minutes": minutes, "hours": hours, "mode": mode.rawValue.lowercased()],
                   encoding: JSONEncoding.default).response { response in
                    if let error = response.error {
                        completion("ERROR: \(error.localizedDescription)")
                    } else {
                        let textResponse = String(data: response.data!, encoding: .utf8)
                        completion("\(response.result) while setting to \(hours):\(minutes)@\(mode.rawValue). Server response: \(textResponse ?? "<NONE>")")
                    }
        }
    }
}
