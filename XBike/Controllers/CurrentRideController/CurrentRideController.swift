//
//  CurrentRideController.swift
//  XBike
//
//  Created by Jóse Bustamante on 11/08/22.
//

import UIKit
import CoreLocation
import GoogleMaps
import MapKit
import Contacts

class CurrentRideController: UIViewController {
    
    var locationManager: CLLocationManager!
    var latitude: Double = -33.86
    var longitude: Double = 151.20
    let spinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var trackingPath = GMSMutablePath()
    var trackingPolyline = GMSPolyline()
    var coordinateFirst = CLLocation()
    var coordinateLast = CLLocation()
    private var trackLocations: [CLLocation] = []
    var isUpdateUnstopped: Bool = true
    var firstLocations: [String] = [String]()
    var lastLocations: [String] = [String]()
    let backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        navigationController?.navigationBar.backgroundColor = .systemOrange
        viewConfigurations()
        locationConfiguration()
        spinnerConfiguration()
        mapConfiguration()
        title = "Current Ride"
        NotificationCenter.default.addObserver(self, selector: #selector(presentSecondAlert), name: NSNotification.Name("didPressStop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentThirdAlert), name: NSNotification.Name("didPressStore"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPressStart), name: NSNotification.Name("didPressStart"), object: nil)
        navigationItem.rightBarButtonItem = .init(image: UIImage(named: "add")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(startRiding))
    }
    
    func viewConfigurations() {
        backgroundView.backgroundColor = .systemOrange
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        viewConstraints()
    }
    
    func viewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func startRiding() {
        MyAlert.showAlert(with: "Start?", message: "It's time to ride", on: self)
    }
    
    @objc func presentSecondAlert() {
        locationManager.stopUpdatingLocation()
        var distanceInMeters = coordinateFirst.distance(from: coordinateLast)
        distanceInMeters = distanceInMeters / 1000
        MyAlert.showAlertStore(with: "Start?", message: "Store", kilometers: Double(distanceInMeters), on: self)
    }
    
    @objc func presentThirdAlert() {
        storeLocations()
        MyAlert.showDoneAlert(with: "Start?", message: "Store", on: self)
    }
    
    func storeLocations() {
        let location = CLLocation(latitude: coordinateFirst.coordinate.latitude, longitude: coordinateFirst.coordinate.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            if self.firstLocations.isEmpty {
                if let storeFirstLocation = UserDefault.shared.userDefaults.object(forKey: "storeFirstLocation") {
                    self.firstLocations = storeFirstLocation as! [String]
                }
            }
            self.firstLocations.append(placemark.postalAddressFormatted ?? "")
            UserDefault.shared.userDefaults.set(self.firstLocations, forKey: "storeFirstLocation")
        }
        
        
        let locationLast = CLLocation(latitude: coordinateFirst.coordinate.latitude, longitude: coordinateFirst.coordinate.longitude)
        locationLast.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            if self.lastLocations.isEmpty {
                if let storeLastLocation = UserDefault.shared.userDefaults.object(forKey: "storeLastLocation") {
                    self.lastLocations = storeLastLocation as! [String]
                }
            }
            self.lastLocations.append(placemark.postalAddressFormatted ?? "")
            UserDefault.shared.userDefaults.set(self.lastLocations, forKey: "storeLastLocation")
        }
        
    }
    
    @objc func didPressStart() {
        isUpdateUnstopped = false
        locationManager.startUpdatingLocation()
    }
    
    func mapConfiguration() {
        self.camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        self.mapView = GMSMapView.map(withFrame: self.backgroundView.frame, camera: camera)
        self.mapView.isMyLocationEnabled = true
        self.backgroundView.addSubview(mapView)
        self.backgroundView.sendSubviewToBack(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.bottomAnchor)
        ])
        mapView.delegate = self
    }
    
    func spinnerConfiguration() {
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func locationConfiguration() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
    }
}

extension CurrentRideController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if latitude >= (locations.first?.coordinate.latitude)! - 10 || latitude >= (locations.first?.coordinate.latitude)! + 10 {
            latitude = (locations.first?.coordinate.latitude)!
            longitude = (locations.first?.coordinate.longitude)!
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        for location in locations {
            self.trackLocations.append(location)
            let index = self.trackLocations.count
            if index > 2 {
                self.trackingPath.add(self.trackLocations[index - 1].coordinate)
                self.trackingPath.add(self.trackLocations[index - 2].coordinate)
                
                self.trackingPolyline.path = self.trackingPath
                self.trackingPolyline.path = self.trackingPath
                self.trackingPolyline.strokeColor = .blue
                self.trackingPolyline.strokeWidth = 5.0
                self.trackingPolyline.map = self.mapView
            }
        }
        coordinateFirst = trackLocations.first!
        coordinateLast = trackLocations.last!
        spinner.stopAnimating()
        print("called")
        if isUpdateUnstopped {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Authorized When in Use")
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        case .authorizedAlways:
            print("Authorized Always")
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        @unknown default:
            print("Unknown status")
        }
    }
}

extension CurrentRideController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //            self.mapView.animate(toLocation: .init(latitude: self.latitude, longitude: self.longitude))
        }
    }
}
