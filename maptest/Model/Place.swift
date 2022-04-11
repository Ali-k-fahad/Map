//
//  Place.swift
//  maptest
//
//  Created by Ali Fahad on 10.4.2022.
//

import SwiftUI
import MapKit
struct Place: Identifiable {

    var id = UUID().uuidString
    var place: CLPlacemark
}
