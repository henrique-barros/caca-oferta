//
//  mapPin.swift
//  CompreFacil
//
//  Created by Henrique Barros on 6/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import MapKit

class MapPin:NSObject, MKAnnotation {
  @objc var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  var id: String?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, id: String) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.id = id
  }
  
}
