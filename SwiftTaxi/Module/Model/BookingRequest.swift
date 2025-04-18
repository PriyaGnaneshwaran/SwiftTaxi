//
//  Booking.swift
//  SwiftTaxi
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//
import Foundation

enum PaymentType {
    case creditCard
    case cash
}

struct BookingRequest {
    let name: String
    let mobile: String
    let destination: String
    let tripDate: Date
    let driver: Driver
    let paymentType: PaymentType
    let bookingDate: Date
}
