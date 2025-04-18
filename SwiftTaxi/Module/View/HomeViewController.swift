//
//  HomeViewController.swift
//  SwiftRide
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//

import UIKit
import CoreLocation
import GoogleMaps

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnBookNow: UIButton!
    
    let locationManager = CLLocationManager()
    let viewModel = DriverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocation()
        self.updateUI()
    }
    
    func updateUI() {
        self.btnBookNow.isEnabled = true
        self.btnBookNow.setTitle("Book Now", for: .normal)
        self.btnBookNow.backgroundColor = .systemBlue
        self.btnBookNow.addTarget(self, action: #selector(actionBookNow) , for: .touchUpInside)
    }
    
    @objc func actionBookNow() {
        
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func updateMap(_ location : CLLocation) {
        
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        self.mapView.animate(to: camera)
        self.mapView.delegate = self
        self.mapView.clear()
        
        let userMarker = GMSMarker()
        userMarker.position = location.coordinate
        userMarker.icon = GMSMarker.markerImage(with: .red)
        userMarker.title = "You"
        userMarker.map = self.mapView
        
        for driver in viewModel.drivers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: driver.latitude, longitude: driver.longitude)
            marker.title = driver.name
            marker.icon = GMSMarker.markerImage(with: .blue)
            marker.map = self.mapView
        }
        self.viewModel.findNearestDriver(userLocation: location)
        self.btnBookNow.isEnabled = self.viewModel.isBookingAvailable
        self.btnBookNow.backgroundColor = self.viewModel.isBookingAvailable ? .systemGreen : .gray
    }
}

extension HomeViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            self.updateMap(currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
