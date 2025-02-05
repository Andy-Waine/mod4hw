//
//  ViewController.swift
//  mod4hw
//
//  Created by user272531 on 2/5/25.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var remainingTime: TimeInterval = 0
    var timer: Timer?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // update background image based on time of day
        updateBackground()
        
        backgroundImageView.alpha = 0.3
        
        view.sendSubviewToBack(backgroundImageView)
        
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    @IBAction func startStopTapped(_ sender: UIButton) {
        if timer == nil {
            startTimer()
        } else {
            stopMusic()
        }
    }

    func updateBackground() {
        let hour = Calendar.current.component(.hour, from: Date())
        let imageName = hour < 18 ? "day.jpg" : "night.jpg"
        backgroundImageView.image = UIImage(named: imageName)
    }
    
    @objc func updateClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        clockLabel.text = formatter.string(from: Date())
        
        updateBackground()
    }
    
    func startTimer() {
        remainingTime = datePicker.countDownDuration
        updateTimerLabel()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        startStopButton.setTitle("Stop Music", for: .normal)
    }
    
    @objc func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateTimerLabel()
        } else {
            timer?.invalidate()
            timer = nil
            playMusic()
        }
    }
    
    func updateTimerLabel() {
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) / 60 % 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "Time Remaining: %02d:%02d:%02d", hours, minutes, seconds)
    }

    func playMusic() {
        guard let path = Bundle.main.path(forResource: "alarm", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
    func stopMusic() {
        player?.stop()
        timer?.invalidate()
        timer = nil
        startStopButton.setTitle("Start Timer", for: .normal)
    }
}

