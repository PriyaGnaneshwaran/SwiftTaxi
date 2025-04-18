//
//  DriverViewModel.swift
//  SwiftTaxi
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//


//
//  DriverViewModel.swift
//  SwiftRide
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//

import CoreLocation

class DriverViewModel {
    let drivers: [Driver] = [
        Driver(name: "Driver A", latitude: 13.068500, longitude: 80.234938),
        Driver(name: "Driver B", latitude: 13.062306, longitude: 80.231172),
        Driver(name: "Driver C", latitude: 13.071086, longitude: 80.230709)
    ]
    
    var nearestDriver: Driver?
    var isBookingAvailable: Bool = false

    func findNearestDriver(userLocation: CLLocation) {
        var nearestDistance = CLLocationDistance(Double.greatestFiniteMagnitude)
        
        for driver in drivers {
            let driverLocation = CLLocation(latitude: driver.latitude, longitude: driver.longitude)
            let distance = userLocation.distance(from: driverLocation)
            
            if distance < nearestDistance {
                nearestDistance = distance
                self.nearestDriver = driver
            }
        }
        self.isBookingAvailable = (nearestDistance <= 1000)
    }
}
