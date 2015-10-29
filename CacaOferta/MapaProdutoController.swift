//
//  mapaProdutoController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/25/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapaProdutoController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var lojas = [PFObject]()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    carregaDetalhes()
  }
  
  func mostrarLojasProximas() {
    for loja in lojas {
      let latitude = loja.objectForKey(lojaKeyGeoPoint)?.latitude
      let longitude = loja.objectForKey(lojaKeyGeoPoint)?.longitude
      let nome = loja.objectForKey(lojaKeyNome) as! String
      let descricao = loja.objectForKey(lojaKeyDescricao) as! String
      let pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), title: nome, subtitle: descricao)
      mapView.addAnnotation(pin)
    }
  }
  
  func carregaDetalhes() {
    let detalhes = self.storyboard?.instantiateViewControllerWithIdentifier(detalhesLocalID)
    self.navigationController?.showViewController(detalhes!, sender: self)
  }
  
  func regiaoDaLoja(loja: Loja) -> CLCircularRegion {
    let regiao = CLCircularRegion(center: loja.coordinate, radius: 1000, identifier: loja.id)
    regiao.notifyOnEntry = true
    return regiao
  }
  
  func iniciarMonitoramentoLoja(loja: Loja) {
    if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_suporte_geolocalizacao", comment: ""), viewController: self)
      return
    }
    if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
      showSimpleAlertWithTitle(NSLocalizedString("atencao", comment: ""), message: NSLocalizedString("msg_erro_permissao", comment: ""), viewController: self)
    }
    let regiao = regiaoDaLoja(loja)
    locationManager.startMonitoringForRegion(regiao)
  }
  
  func pararMonitoramentoLoja(loja: Loja) {
    for region in locationManager.monitoredRegions {
      if let circularRegion = region as? CLCircularRegion {
        if circularRegion.identifier == loja.id {
          locationManager.stopMonitoringForRegion(circularRegion)
        }
      }
    }
  }
  
  //Location Manager Delegate
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
  
  func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
    print("Monitoring failed for region with identifier: \(region!.identifier)")
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("Location Manager failed with the following error: \(error)")
  }
}
