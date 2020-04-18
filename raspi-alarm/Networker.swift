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

    let timeoutInterval = 3.0

    var deviceAddress = "192.168.178.175"
    var baseURL: String {return "http://\(deviceAddress):3141"}


    func sendScheduleRequestToServer (
            minutes: String = "30",
            hours: String = "9",
            mode: MusicMode = .Spotify,
            completion: @escaping (String)->()
    ) {
        AF.request(baseURL + "/cronsave",
                   method: .post,
                   parameters: ["minutes": minutes, "hours": hours, "mode": mode.rawValue.lowercased()],
                   encoding: JSONEncoding.default).response { response in
                    if let error = response.error {
                        completion("ERROR@\(self.deviceAddress): \(error.localizedDescription)")
                    } else {
                        let textResponse = String(data: response.data!, encoding: .utf8)
                        completion("\(response.result): \(mode.rawValue) at \(hours):\(minutes). \(self.deviceAddress) response: \(textResponse ?? "<NONE>")")
                    }
        }
    }

    // TODO: generalized "request to raspi" functions
    func sendStatusRequestToServer(completion: @escaping (String)->()) {
        AF.request(baseURL + "/areyourunning", method: .get, requestModifier: { $0.timeoutInterval = self.timeoutInterval }).response {
            response in
            if let error = response.error {
                completion("ERROR@\(self.deviceAddress): \(error.localizedDescription)")
            } else {
                let textResponse = String(data: response.data!, encoding: .utf8)
                completion(textResponse ?? "No response")
            }

        }
    }

    func sendClearRequestToServer(completion: @escaping (String)->()) {
        AF.request(baseURL + "/playpause", method: .get, requestModifier: { $0.timeoutInterval = self.timeoutInterval }).response {
            response in
            if let error = response.error {
                completion("ERROR@\(self.deviceAddress): \(error.localizedDescription)")
            } else {
                let textResponse = String(data: response.data!, encoding: .utf8)
                completion(textResponse ?? "No response")
            }
        }
    }

    func sendPlayRequestToServer(completion: @escaping (String)->()) {
        AF.request(baseURL + "/spotiplay", method: .get, requestModifier: { $0.timeoutInterval = self.timeoutInterval }).response {
            response in
            if let error = response.error {
                completion("ERROR@\(self.deviceAddress): \(error.localizedDescription)")
            } else {
                let textResponse = String(data: response.data!, encoding: .utf8)
                completion(textResponse ?? "No response")
            }
        }
    }

}
