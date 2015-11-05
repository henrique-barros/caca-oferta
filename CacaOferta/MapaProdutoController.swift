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
  var lojas = NSMutableArray()
  var item = NSMutableDictionary()
  let locationManager = CLLocationManager()
  var produtoRelevanteDoItem = [NSMutableDictionary]()
  var produtoPorLoja = NSMutableDictionary()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = (item.objectForKey(usuarioKeyItemDesejadoDescricao) as? String)!.capitalizedString
    mapView.delegate = self
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    zoomParaRegiaoDoUsuario()
    mostrarLojasProximas()
    _ = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("mostrarLojasProximas"), userInfo: nil, repeats: true)
  }
  
  func zoomParaRegiaoDoUsuario() {
    var region = MKCoordinateRegion()
    if (locationManager.location != nil) {
      region.center = (locationManager.location?.coordinate)!
      region.span.latitudeDelta = 0.01;
      region.span.longitudeDelta = 0.01;
      mapView.setRegion(region, animated: true)
    }
  }
  
  func getProdutosRelevantesDoItem() -> [NSMutableDictionary] {
    var tagItem = [String]()
    if item.objectForKey(usuarioKeyItemDesejadoTags)!.isKindOfClass(NSArray) {
      tagItem = item.objectForKey(usuarioKeyItemDesejadoTags) as! [String]
    } else {
      tagItem.append(item.objectForKey(usuarioKeyItemDesejadoTags) as! String)
    }
    tagItem.append(item.objectForKey(usuarioKeyItemDesejadoDescricao)! as! String)
    tagItem = tagItem.map { (string) -> String in string.uppercaseString}
    
    var produtoRelevanteDoItem = [NSMutableDictionary]()
    for produto in produtosRelevantes {
      var produtoTags = produto.objectForKey(produtoKeyTags) as! [String]
      produtoTags.append(produto.objectForKey(produtoKeyDescricao) as! String)
      produtoTags = produtoTags.map { (string) -> String in string.uppercaseString}
            
      let set1 = Set(tagItem)
      let set2 = Set(produtoTags)
      
      if (set1.intersect(set2).count > 0) {
        produtoRelevanteDoItem.append(produto as! NSMutableDictionary)
      }
    }
    return produtoRelevanteDoItem
  }
  
  func mostrarLojasProximas() {
    
    produtoRelevanteDoItem = getProdutosRelevantesDoItem()
    produtoPorLoja = NSMutableDictionary()
    self.mapView.removeAnnotations(self.mapView.annotations)
    for produto in produtoRelevanteDoItem {
      let query = PFQuery(className: produtoKeyClass)
      query.whereKey("objectId", equalTo: produto.objectForKey("objectId") as! String)
      query.findObjectsInBackgroundWithBlock({
        (objects: [AnyObject]?, error: NSError?) in
        let produto = objects?.first as! PFObject
        let relation = produto.objectForKey(produtoKeyLoja) as! PFRelation
        let query2 = relation.query()
        query2?.findObjectsInBackgroundWithBlock({
          (objects: [AnyObject]?, error: NSError?) in
          let loja = objects?.first as! PFObject
          let latitude = (loja.objectForKey(lojaKeyGeoPoint) as! PFGeoPoint).latitude
          let longitude = (loja.objectForKey(lojaKeyGeoPoint) as! PFGeoPoint).longitude
          let nome = loja.objectForKey(lojaKeyNome) as! String
          let descricao = loja.objectForKey(lojaKeyDescricao) as! String
          let id = loja.objectForKey(lojaKeyId) as! String
          let pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: nome.capitalizedString, subtitle: descricao.capitalizedString, id: id)
          if (self.produtoPorLoja.objectForKey(id) == nil) {
            let arrayProdutosLoja = NSMutableArray()
            arrayProdutosLoja.addObject(produto)
            self.produtoPorLoja.setObject(arrayProdutosLoja, forKey: id)
          } else {
            (self.produtoPorLoja.objectForKey(id) as! NSMutableArray).addObject(produto)
          }
          self.mapView.addAnnotation(pin)
        })
      })
    }
    
  }
  
  func carregaDetalhes(idLoja: String) {
    let detalhes = self.storyboard?.instantiateViewControllerWithIdentifier(detalhesLocalID) as! DetalhesLocalizacaoViewController
    for loja in lojasRelevantes {
      if loja.objectForKey(lojaKeyId) as! String == idLoja {
        detalhes.loja = loja as! NSMutableDictionary
        detalhes.produtos = produtoPorLoja.objectForKey(idLoja) as! NSMutableArray
      }
    }
    //detalhes.produtos = produtoRelevanteDoItem
    self.navigationController?.showViewController(detalhes, sender: self)
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
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    let button = UIButton(type: UIButtonType.DetailDisclosure)
    if annotation .isKindOfClass(MapPin) {
      let pin = annotation as! MapPin
      button.accessibilityValue = pin.id
      button.addTarget(self, action: Selector("onButtonTouchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
      annotationView.canShowCallout = true
      annotationView.rightCalloutAccessoryView = button
      print("ola")
      return annotationView
    } else {
      return nil
    }
  }
  
  func onButtonTouchUpInside(sender: UIButton) {
    carregaDetalhes(sender.accessibilityValue!)
  }
}
