//
//  AdicionarLojaViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import MapKit

let tagButtonMeuLocal = 13
let tagButtonBuscar = 14
let tagButtonAdd = 15

class AdicionarLojaViewController: UITableViewController, CLLocationManagerDelegate {
  @IBOutlet weak var textFieldNome: UITextField!
  @IBOutlet weak var textFieldEndereco: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  var currentLocation = CLLocation()
  var locais = [MKPlacemark]()
  
  override func viewDidLoad() {
    print("viewDidLoad")
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  

  @IBAction func onButtonTouchUpInside(sender: UIButton) {
    switch(sender.tag) {
      case tagButtonBuscar:
        buscarLocalizacaoESalvarLocal(textFieldEndereco.text!)
        atualizarMapa()
      case tagButtonMeuLocal:
        buscarMinhaLocalizacaoESalvarLocal()
        atualizarMapa()
      default:
        print("nada")
    }
  }
  @IBAction func onButtonTouchUpInsideNavigationBar(sender: UIButton) {
    switch (sender.tag) {
      case tagButtonAdd:
        adicionarLojaComDadosDaTela()
      default:
        print("nada")
    }
  }
  
  func adicionarLojaComDadosDaTela() {
    if (!textFieldEndereco.text!.isEmpty && !textFieldNome.text!.isEmpty) {
      print(loggedUser.username)
      let annotation = mapView.annotations.first as MKAnnotation?
      let loja = Loja(coordinate: (annotation?.coordinate)!, nome: textFieldNome.text!, descricao: "",dono: loggedUser.username!).objetoParseComLoja()
      loja.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        if succeeded {
          print("Object Uploaded")
        } else {
          print("Error: \(error) \(error!.userInfo)")
        }
      }
    }
    else {
      //TODO MENSAGEM DE ERRO
      print("Falta informação")
    }
  }
  
  func buscarMinhaLocalizacaoESalvarLocal() {
    var placeMarks = [MKPlacemark]()
    placeMarks.append(MKPlacemark(coordinate: locationManager.location!.coordinate, addressDictionary: nil))
    locais = placeMarks
  }
  
  func buscarLocalizacaoESalvarLocal(endereco: String) {
    print("buscar localizacao")
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = endereco
    let search = MKLocalSearch(request: request)
    var placeMarks = [MKPlacemark]()
    search.startWithCompletionHandler{(response, error) in
      if error == nil {
        if let items = response!.mapItems as? [MKMapItem] {
          for item in items {
            placeMarks.append(item.placemark)
          }
        }
        self.locais = placeMarks
      }
      else {
        self.locais = []
        print(error!.description)
      }
    }
  }
  
  func atualizarMapa() {
    self.mapView.removeAnnotations(self.mapView.annotations)
    self.mapView.showAnnotations(locais, animated: false)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    print("atualizou local")
    currentLocation = newLocation
  }
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
}
