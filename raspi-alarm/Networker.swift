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
    static var shared = Networker()



    func sendScheduleRequestToServer(minutes: String, hours: String, mode: MusicMode, room: Room, completion: @escaping (String)->()){
        let address = "http://192.168.178.\(room.rawValue):3141"
        AF.request(address + "/cronsave",
                   method: .post,
                   parameters: ["minutes": minutes, "hours": hours, "mode": mode.rawValue.lowercased()],
                   encoding: JSONEncoding.default).response { response in
                    if let error = response.error {
                        completion("ERROR: \(error.localizedDescription)")
                    } else {
                        let textResponse = String(data: response.data!, encoding: .utf8)
                        completion("\(response.result) while setting to \(hours):\(minutes)@\(mode.rawValue)-pi:\(room.rawValue). Server response: \(textResponse ?? "<NONE>")")
                    }
        }
    }
}
