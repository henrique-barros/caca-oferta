//
//  GeralUtils.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//


import UIKit
import MapKit

var bla = "string1"
var loggedUser: PFUser = PFUser()


var usuarioKeyItensDesejados = "itemDesejado"
var usuarioKeyItemDesejadoTags = "itemDesejadoTags"
var usuarioKeyItemDesejadoDescricao = "itemDesejadoDescricao"
var usuarioKeyUsername = "username"

// MARK: Helper Functions

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
  let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
  alert.addAction(action)
  viewController.presentViewController(alert, animated: true, completion: nil)
}

func zoomToUserLocationInMapView(mapView: MKMapView) {
  if let coordinate = mapView.userLocation.location?.coordinate {
    let region = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
    mapView.setRegion(region, animated: true)
  }
}

func showSimpleAlertWithAction(title: String!, message:String, viewController: UIViewController, action: UIAlertAction) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
  alert.addAction(action)
  viewController.presentViewController(alert, animated: true, completion: nil)
}