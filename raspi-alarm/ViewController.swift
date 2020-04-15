//
//  ViewController.swift
//  raspi-alarm
//
//  Created by Janek Szynal on 23.12.2018.
//  Copyright © 2018 Janek Szynal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet var serverRequestButtons: [UIButton]!
    @IBOutlet weak var musicSourceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var roomSegmentedControl: UISegmentedControl!

    var mode: MusicMode = .Spotify
    var availableModes = [MusicMode.Spotify, .Luz] // TODO: change to allCases after updating to newer swift


    var networker = Networker()
    let forceWhiteMode = true


    override func viewDidLoad() {
        if forceWhiteMode {
            view.backgroundColor = .white
            serverRequestButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        }
        musicSourceSegmentedControl.addTarget(self, action: #selector(musicSourceValueChanged(segmentedControl:)), for: .valueChanged)
        picker.setValue(Color.spotifyGreen.value, forKeyPath: "textColor") //TODO: set initial state, not initial colors
    }

    @IBAction func triggerServerRequestFromButton(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case "SET":
            setAlarmClock()
        case "IP":
            //XXX: this is not a request button, maybe it belongs somewhere else
            let alert = UIAlertController(title: "Input Server Address", message: "Please enter an IP for the `spotify-alarm-clock` server", preferredStyle: .alert)

            alert.addTextField { field in field.text = self.networker.deviceAddress }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0]
                self.networker.deviceAddress = textField.text!
            }))
            self.present(alert, animated: true, completion: nil)

        case "STATUS":
            networker.sendStatusRequestToServer(completion: { response in
                print(response)
                self.feedbackLabel.text = response + "\n" + self.feedbackLabel.text!
                self.feedbackLabel.sizeToFit()})
        default:
            print("OKOK")
        }
    }

    func setAlarmClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let minutes = formatter.string(from: picker.date)
        formatter.dateFormat = "H"
        let hours = formatter.string(from: picker.date)
        
        networker.sendScheduleRequestToServer(minutes: minutes, hours: hours, mode: self.mode, completion: { response in
            print(response)
            self.feedbackLabel.text = response + "\n" + self.feedbackLabel.text!
            self.feedbackLabel.sizeToFit()
        })
    }

    @objc func musicSourceValueChanged(segmentedControl: UISegmentedControl) {
        let chosenSourceString = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!

        switch chosenSourceString {
        case MusicMode.Spotify.rawValue:
            picker.setValue(Color.spotifyGreen.value, forKeyPath: "textColor")
            segmentedControl.tintColor = Color.spotifyGreen.value
            serverRequestButtons.forEach({$0.backgroundColor = Color.spotifyGreen.value})
            feedbackLabel.textColor = Color.spotifyGreen.value
            mode = .Spotify
        case MusicMode.Luz.rawValue:
            picker.setValue(Color.luzOrange.value, forKeyPath: "textColor")
            segmentedControl.tintColor = Color.luzOrange.value
            serverRequestButtons.forEach({$0.backgroundColor = Color.luzOrange.value})
            feedbackLabel.textColor = Color.luzOrange.value
            mode = .Luz
        default:
            segmentedControl.tintColor = Color.spotifyGreen.value
        }
    }
}

enum MusicMode: String {
    case Spotify = "Spotify"
    case Luz = "Luz"
}
