//
//  GeralUtils.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//


import UIKit
import MapKit
import SystemConfiguration

var bla = "string1"
var loggedUser: PFUser = PFUser()
var lojasRelevantes: NSMutableArray = NSMutableArray()
var produtosRelevantes: NSMutableArray = NSMutableArray()


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

func showSimpleAlertWithConfirmAction(title: String!, message:String, viewController: UIViewController, action: UIAlertAction) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
  let actionCancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .Cancel, handler: nil)
  alert.addAction(actionCancel)
  alert.addAction(action)
  viewController.presentViewController(alert, animated: true, completion: nil)
}

func doLogout(viewController: UIViewController) {
  let action  = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Default) { (act) in
    PFUser.logOut()
    loggedUser = PFUser()
    viewController.tabBarController?.dismissViewControllerAnimated(false, completion: nil)
  }
  showSimpleAlertWithConfirmAction(NSLocalizedString("atencao", comment: ""), message: NSLocalizedString("msg_alerta_logout", comment: ""), viewController: viewController, action: action)
}

func isConnectedToNetwork() -> Bool {
  var zeroAddress = sockaddr_in()
  zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
  zeroAddress.sin_family = sa_family_t(AF_INET)
  let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
    SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
  }
  var flags = SCNetworkReachabilityFlags()
  if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
    return false
  }
  let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
  let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
  return (isReachable && !needsConnection)
}
