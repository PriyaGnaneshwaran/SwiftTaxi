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
    let appConstants = AppConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocation()
        self.updateUI()
    }
    
    func updateUI() {
        self.btnBookNow.isEnabled = true
        self.btnBookNow.setTitle(appConstants.bookNow, for: .normal)
        self.btnBookNow.backgroundColor = .systemBlue
        self.btnBookNow.addTarget(self, action: #selector(actionBookNow) , for: .touchUpInside)
    }
    
    @objc func actionBookNow() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "BookingFormViewController") as? BookingFormViewController {
            nav.selectedDriver = self.viewModel.nearestDriver
            nav.modalTransitionStyle = .crossDissolve
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true)
        }
    }
    
    func setupLocation() {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.zoomGestures = true
    }
    
    func updateMap(_ location : CLLocation) {
        
        let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        self.mapView.animate(to: camera)
        self.mapView.delegate = self
        self.mapView.clear()
        
        let userMarker = GMSMarker()
        userMarker.position = location.coordinate
        userMarker.icon = GMSMarker.markerImage(with: .red)
        userMarker.title = appConstants.You
        userMarker.map = self.mapView
        
        for driver in viewModel.drivers {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: driver.latitude, longitude: driver.longitude)
            marker.title = driver.name
//            marker.icon = UIImage(systemName: "car")
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
        if let currentLocation = locations.last {
            self.updateMap(currentLocation)
            self.locationManager.stopUpdatingLocation()
        }
    }
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
//        <#code#>
//    }
}
