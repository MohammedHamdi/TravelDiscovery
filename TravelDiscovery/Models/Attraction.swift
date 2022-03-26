//
//  Attraction.swift
//  TravelDiscovery
//
//  Created by Mohammed Hamdi on 05/09/2021.
//

import Foundation

struct Attraction: Identifiable {
    let id = UUID().uuidString
    
    let name, imageName: String
    let latitude, longitude: Double
}
