//
//  Alerts.swift
//  XBike
//
//  Created by Jóse Bustamante on 11/08/22.
//

import UIKit

class MyAlert {
    
    static let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 20
        return alert
    }()
    
    static var count: Int = 0
    static var myTargetView: UIView?
    static var hour: String = "0"
    static var minutes: String = "0"
    static var seconds: String = "0"
    static var timer: Timer?
    static var currentController: UIViewController!
    static var distance: Double!
    static var times: [String] = [String]()
    static var distances: [String] = [String]()
    
    static let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    static let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static let storeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Store", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Your time was"
        return label
    }()
    
    static let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Distance"
        return label
    }()
    
    static let distanceInKMLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.text = "10 km"
        return label
    }()
    
    static let okLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Your progress has been correctly stored!"
        return label
    }()
    
    static let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Ok", for: .normal)
        return button
    }()
    
    init() { }
    
    static func showAlert(with title: String, message: String, on viewController: UIViewController) {
        count = 0
        titleLabel.text = "00:00:00"
        stopButton.isEnabled = false
        startButton.isEnabled = true
        currentController = viewController
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.maxY - 412, width: targetView.frame.width - 80, height: 240)
        }
        
        titleLabel.font = titleLabel.font.withSize(32)
        
        let orangeView = UIView()
        orangeView.backgroundColor = .orange
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        
        startButton.addTarget(self, action: #selector(startCount), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopCount), for: .touchUpInside)
        alertView.addSubview(startButton)
        alertView.addSubview(titleLabel)
        alertView.addSubview(stopButton)
        alertView.addSubview(orangeView)
        targetView.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            orangeView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            orangeView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            orangeView.widthAnchor.constraint(equalToConstant: 2),
            orangeView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            startButton.trailingAnchor.constraint(equalTo: orangeView.leadingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.leadingAnchor.constraint(equalTo: orangeView.trailingAnchor, constant: 16),
            stopButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        ])
    }
    
    static func showDoneAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.center = targetView.center
        }
        
        okLabel.font = timeLabel.font.withSize(24)
        
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okButton)
        alertView.addSubview(okLabel)
        targetView.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            okLabel.topAnchor.constraint(equalTo: alertView.centerYAnchor, constant: -16),
            okLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            okLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            okLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            okButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            okButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 32),
            okButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -32)
        ])
        
    }
    
    static func showAlertStore(with title: String, message: String, kilometers: Double, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        distance = kilometers
        
        UIView.animate(withDuration: 0.25) {
            self.alertView.center = targetView.center
        }
        
        timeLabel.font = timeLabel.font.withSize(24)
        titleLabel.font = titleLabel.font.withSize(32)
        distanceLabel.font = distanceLabel.font.withSize(24)
        distanceInKMLabel.font = distanceInKMLabel.font.withSize(32)
        distanceInKMLabel.text = "\(String(format: "%2f", kilometers)) km"//"\(kilometers) km"
        
        let orangeView = UIView()
        orangeView.backgroundColor = .orange
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        
        storeButton.addTarget(self, action: #selector(storeCount), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(timeLabel)
        alertView.addSubview(distanceLabel)
        alertView.addSubview(storeButton)
        alertView.addSubview(titleLabel)
        alertView.addSubview(deleteButton)
        alertView.addSubview(orangeView)
        alertView.addSubview(distanceInKMLabel)
        targetView.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16),
            timeLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            distanceLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            distanceInKMLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            distanceInKMLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            orangeView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            orangeView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16),
            orangeView.widthAnchor.constraint(equalToConstant: 2),
            orangeView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            storeButton.trailingAnchor.constraint(equalTo: orangeView.leadingAnchor, constant: -16),
            storeButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: orangeView.trailingAnchor, constant: 16),
            deleteButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc static func stopCount() {
        startButton.isEnabled = false
        timer?.invalidate()
        UserDefaults.standard.set(titleLabel.text!, forKey: "countToSave")
        dismissAlert()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            NotificationCenter.default.post(name: Notification.Name("didPressStop"), object: nil, userInfo: nil)
        }
    }
    
    @objc static func storeCount() {
        dismissAlert()
        if times.isEmpty {
            if let storeTimes = UserDefault.shared.userDefaults.object(forKey: "times") {
                times = storeTimes as! [String]
            }
        }
        
        if distances.isEmpty {
            if let storeDistance = UserDefault.shared.userDefaults.object(forKey: "distances") {
                distances = storeDistance as! [String]
            }
        }
        times.append("\(titleLabel.text ?? "")")
        distances.append("\(String(format: "%2f", distance)) km")
        UserDefault.shared.userDefaults.set(times, forKey: "times")
        UserDefault.shared.userDefaults.set(distances, forKey: "distances")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            NotificationCenter.default.post(name: Notification.Name("didPressStore"), object: nil, userInfo: nil)
        }
    }
    
    @objc static func dismissAlert() {
        guard let targetView = MyAlert.myTargetView else {
            return
        }
        startButton.isEnabled = true
        UIView.animate(withDuration: 0.25) {
            MyAlert.alertView.frame = CGRect(x: 40, y: targetView.frame.height, width: targetView.frame.width - 80, height: 300)
        } completion: { done in
            if done {
                for item in MyAlert.alertView.subviews {
                    item.removeFromSuperview()
                }
                MyAlert.alertView.removeFromSuperview()
            }
        }
    }
    
    @objc static func startCount() {
        NotificationCenter.default.post(name: Notification.Name("didPressStart"), object: nil, userInfo: nil)
        startButton.isEnabled = false
        stopButton.isEnabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            let (h,m,s) = secondsToHoursMinutesSeconds(count)
            if h < 10 {
                hour = "0\(h)"
            } else {
                hour = "\(h)"
            }
            
            if m < 10 {
                minutes = "0\(m)"
            } else {
                minutes = "\(m)"
            }
            
            if s < 10 {
                seconds = "0\(s)"
            } else {
                seconds = "\(s)"
            }
            titleLabel.text = "\(hour):\(minutes):\(seconds)"
            count += 1
        }
    }
    
    static func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
