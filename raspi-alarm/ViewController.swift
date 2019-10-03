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

enum Room: String {
    case Janek = "199"
    case Mila = "113"
}

class ViewController: UIViewController {    

    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var setAlarmButton: UIButton!
    @IBOutlet weak var musicSourceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var roomSegmentedControl: UISegmentedControl!

    var mode: MusicMode = .Spotify
    var availableModes = [MusicMode.Spotify, .Luz] // TODO: change to allCases after updating to newer swift

    var room: Room = .Janek
    var availableRooms = [Room.Janek, .Mila]

    let networker = Networker.shared

    override func viewDidLoad() {
        musicSourceSegmentedControl.addTarget(self, action: #selector(musicSourceValueChanged(segmentedControl:)), for: .valueChanged)
        roomSegmentedControl.addTarget(self, action: #selector(roomValueChanged(segmentedControl:)), for: .valueChanged)
        picker.setValue(Color.spotifyGreen.value, forKeyPath: "textColor") //TODO: set initial state, not initial colors
    }

    @IBAction func setAlarmClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let minutes = formatter.string(from: picker.date)
        formatter.dateFormat = "H"
        let hours = formatter.string(from: picker.date)
        
        networker.sendScheduleRequestToServer(minutes: minutes, hours: hours, mode: self.mode, room: self.room, completion: { response in
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
            setAlarmButton.backgroundColor = Color.spotifyGreen.value
            feedbackLabel.textColor = Color.spotifyGreen.value
            mode = .Spotify
        case MusicMode.Luz.rawValue:
            picker.setValue(Color.luzOrange.value, forKeyPath: "textColor")
            segmentedControl.tintColor = Color.luzOrange.value
            setAlarmButton.backgroundColor = Color.luzOrange.value
            feedbackLabel.textColor = Color.luzOrange.value
            mode = .Luz
        default:
            segmentedControl.tintColor = Color.spotifyGreen.value
        }
    }

    @objc func roomValueChanged(segmentedControl: UISegmentedControl) {
        let chosenRoomString = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!


        switch chosenRoomString {
        case "Janek":
            room = .Janek
        case "Mila":
            room = .Mila
        default:
            assertionFailure()
        }
    }
}

