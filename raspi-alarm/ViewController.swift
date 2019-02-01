//
//  ViewController.swift
//  raspi-alarm
//
//  Created by Janek Szynal on 23.12.2018.
//  Copyright © 2018 Janek Szynal. All rights reserved.
//

import UIKit

enum MusicMode: String {
    case Spotify = "Spotify"
    case Luz = "Luz"
}

class ViewController: UIViewController {

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var musicSourceSegmentedControl: UISegmentedControl!

    var mode: MusicMode = .Spotify
    var availableModes = [MusicMode.Spotify, .Luz] // TODO: change to allCases after updating to newer swift


    let networker = Networker()

    override func viewDidLoad() {
        musicSourceSegmentedControl.addTarget(self, action: #selector(musicSourceValueChanged(segmentedControl:)), for: .valueChanged)
    }

    @IBAction func setAlarmClock() {
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
            segmentedControl.tintColor = Color.spotifyGreen.value
            setAlarmButton.backgroundColor = Color.spotifyGreen.value
            mode = .Spotify
        case MusicMode.Luz.rawValue:
            segmentedControl.tintColor = Color.luzOrange.value
            setAlarmButton.backgroundColor = Color.luzOrange.value
            mode = .Luz
        default:
            segmentedControl.tintColor = Color.spotifyGreen.value
        }
    }
}

