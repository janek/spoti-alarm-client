//
//  ViewController.swift
//  raspi-alarm
//
//  Created by Janek Szynal on 23.12.2018.
//  Copyright © 2018 Janek Szynal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    

//    @IBOutlet weak var picker: UIDatePicker!

//    @IBOutlet weak var musicSourceSegmentedControl: UISegmentedControl!
//    @IBOutlet weak var roomSegmentedControl: UISegmentedControl!

    var setAlarmButton: UIButton!
    var feedbackLabel: UILabel!

    let deviceWidth = UIScreen.main.bounds.size.width
    let deviceHeight = UIScreen.main.bounds.size.height

    var mode: MusicMode = .Spotify
    var availableModes = [MusicMode.Spotify, .Luz] // TODO: change to allCases in Swift 5
    var room: Room = .Janek

    let networker = Networker.shared

    override func viewDidLoad() {

//        musicSourceSegmentedControl.addTarget(self, action: #selector(musicSourceValueChanged(segmentedControl:)), for: .valueChanged)
//        roomSegmentedControl.addTarget(self, action: #selector(roomValueChanged(segmentedControl:)), for: .valueChanged)
//        picker.setValue(Color.spotifyGreen.value, forKeyPath: "textColor") //TODO: set initial state, not initial colors

        setAlarmButton = UIButton(frame: CGRect(x: 100, y: 300, width: 50, height: 50)) // TODO: actual positioning
        setAlarmButton.setTitle("SET", for: .normal)
        setAlarmButton.backgroundColor = Color.spotifyGreen.value
        setAlarmButton.layer.cornerRadius = 10


        let labelHeight: CGFloat = 40
        feedbackLabel = UILabel(frame: CGRect(x: 0, y: deviceHeight - labelHeight, width: deviceWidth, height: labelHeight))

        view.addSubview(setAlarmButton)
        view.addSubview(feedbackLabel)
    }

    func setAlarmClock() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "mm"
//        let minutes = formatter.string(from: picker.date)
//        formatter.dateFormat = "H"
//        let hours = formatter.string(from: picker.date)
        
        networker.sendScheduleRequestToServer(minutes: "30", hours: "9", mode: self.mode, room: self.room, completion: { response in
            print(response)
            self.feedbackLabel.text = response + "\n" + self.feedbackLabel.text!
            self.feedbackLabel.sizeToFit()
        })
    }

    @objc func musicSourceValueChanged(segmentedControl: UISegmentedControl) {
        let chosenSourceString = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!

        switch chosenSourceString {
        case MusicMode.Spotify.rawValue:
//            picker.setValue(Color.spotifyGreen.value, forKeyPath: "textColor")
//            segmentedControl.tintColor = Color.spotifyGreen.value
            setAlarmButton.backgroundColor = Color.spotifyGreen.value
            feedbackLabel.textColor = Color.spotifyGreen.value
            mode = .Spotify
        case MusicMode.Luz.rawValue:
//            picker.setValue(Color.luzOrange.value, forKeyPath: "textColor")
//            segmentedControl.tintColor = Color.luzOrange.value
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

enum MusicMode: String {
    case Spotify = "Spotify"
    case Luz = "Luz"
}

enum Room: String {
    case Janek = "175"
    case Mila = "148"
}
