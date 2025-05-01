//
//  DriverViewModel.swift
//  SwiftRide
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//

import CoreLocation
import UIKit

class DriverViewModel {
    var drivers: [Driver] = [
        Driver(name: "Driver A", latitude: 13.068500, longitude: 80.234938),
        Driver(name: "Driver B", latitude: 13.062306, longitude: 80.231172),
        Driver(name: "Driver C", latitude: 13.071086, longitude: 80.230709),
        Driver(name: "Driver D", latitude: 9.9228334, longitude: 78.0970979),
        Driver(name: "Driver E", latitude: 9.89322, longitude: 80.184961)
    ]
    
    var isBookingAvailable: Bool = false
    var nearestDriver: Driver?

    func findNearestDriver(userLocation: CLLocation) {
        var closest: Driver?
        var shortestDistance = CLLocationDistance(1000)
        
        for driver in drivers {
            let driverLocation = CLLocation(latitude: driver.latitude, longitude: driver.longitude)
            let distance = userLocation.distance(from: driverLocation)
            if distance <= shortestDistance {
                closest = driver
                shortestDistance = distance
            }
        }
        if let nearest = closest {
            self.nearestDriver = nearest
            self.isBookingAvailable = true
        } else {
            self.nearestDriver = nil
            self.isBookingAvailable = false
        }
    }
}

