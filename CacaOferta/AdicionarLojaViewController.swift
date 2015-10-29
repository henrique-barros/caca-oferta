//
//  AdicionarLojaViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import MapKit

let tagTextFieldNome = 11
let tagTextFieldLocal = 12
let tagButtonMeuLocal = 13
let tagButtonBuscar = 14
let tagButtonAdd = 15

class AdicionarLojaViewController: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate {
  @IBOutlet weak var textFieldNome: UITextField!
  @IBOutlet weak var textFieldEndereco: UITextField!
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var labelLocal: UILabel!
  @IBOutlet weak var labelNome: UILabel!
  
  @IBOutlet weak var botaoMeuLocal: UIButton!
  
  @IBOutlet weak var botaoBuscar: UIButton!
  
  let locationManager = CLLocationManager()
  var currentLocation = CLLocation()
  var locais = [MKPlacemark]()
  
  override func viewDidLoad() {
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    textFieldNome.delegate = self
    textFieldEndereco.delegate = self
    atualizarTextos()
  }
  func atualizarTextos() {
    botaoMeuLocal.setTitle(NSLocalizedString("botao_meu_local", comment: ""), forState: UIControlState.Normal)
    
    botaoBuscar.setTitle(NSLocalizedString("botao_buscar", comment: ""), forState: UIControlState.Normal)
    
    labelNome.text = NSLocalizedString("label_nome", comment: "")
    
    labelLocal.text = NSLocalizedString("label_local", comment: "")
    
    textFieldNome.placeholder = NSLocalizedString("placeholder_nome", comment: "")
    textFieldEndereco.placeholder = NSLocalizedString("placeholder_endereco", comment: "")
    
    navigationItem.title = NSLocalizedString("title_adicionar_loja", comment: "")
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
        break
    }
  }
  @IBAction func onButtonTouchUpInsideNavigationBar(sender: UIBarButtonItem) {
    switch (sender.tag) {
      case tagButtonAdd:
        adicionarLojaComDadosDaTela()
      default:
        break
    }
  }
  
  func adicionarLojaComDadosDaTela() {
    if ((!textFieldEndereco.text!.isEmpty || !mapView.annotations.isEmpty) && !textFieldNome.text!.isEmpty) {
      print(loggedUser.username)
      let annotation = mapView.annotations.first as MKAnnotation?
      let loja = Loja(coordinate: (annotation?.coordinate)!, nome: textFieldNome.text!, descricao: "",dono: loggedUser.username!).objetoParseComLoja()
      loja.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        if succeeded {
          let lojaCadastrada = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.textFieldNome.resignFirstResponder()
            self.textFieldEndereco.resignFirstResponder()
            self.navigationController?.popViewControllerAnimated(true)
          }
          showSimpleAlertWithAction(NSLocalizedString("ok", comment: ""), message: NSLocalizedString("msg_loja_adicionada", comment: ""), viewController: self, action: lojaCadastrada)
        } else {
          print("Error: \(error) \(error!.userInfo)")
          showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_cadastro_loja", comment: ""), viewController: self)
        }
      }
    }
    else {
      print("Falta informação")
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_informacoes_loja", comment: ""), viewController: self)
    }
  }
  
  func buscarMinhaLocalizacaoESalvarLocal() {
    if (locationManager.location != nil) {
      var placeMarks = [MKPlacemark]()
      placeMarks.append(MKPlacemark(coordinate: locationManager.location!.coordinate, addressDictionary: nil))
      locais = placeMarks
    } else {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_busca_minha_localizacao", comment: ""), viewController: self)
    }
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
        showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_busca_endereco", comment: ""), viewController: self)
      }
    }
  }
  
  func atualizarMapa() {
    self.mapView.removeAnnotations(self.mapView.annotations)
    self.mapView.showAnnotations(locais, animated: false)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    currentLocation = newLocation
  }
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case tagTextFieldNome:
      textFieldNome.resignFirstResponder()
    case tagTextFieldLocal:
      textFieldEndereco.resignFirstResponder()
    default:
      break
    }
    return true
  }
}
