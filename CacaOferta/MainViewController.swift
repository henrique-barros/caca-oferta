//
//  MainViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/18/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import CoreLocation

let tagOfertas = 11
let tagCadastrar = 12
let listaComprasViewControllerID = "listaCompras"
let cadastrarLojaID = "cadastrarLoja"


class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  /*@IBAction func onButtonTouchUpInside(sender: AnyObject) {
    switch sender.tag {
      case tagOfertas:
        loadListaComprasTVC()
      case tagCadastrar:
        loadCadastrarLojaTVC()
    default:
      println("Unknown button")
    }
  }
  
  func loadListaComprasTVC() {
    var listaComprasTVC: ListaComprasTVC = self.storyboard!.instantiateViewControllerWithIdentifier(listaComprasViewControllerID) as! ListaComprasTVC
    navigationController?.pushViewController(listaComprasTVC, animated: true)
  }
  
  func loadCadastrarLojaTVC() {
    var cadastrarLojaTVC: AdicionarLojaViewController = self.storyboard!.instantiateViewControllerWithIdentifier(cadastrarLojaID) as! AdicionarLojaViewController
    navigationController?.pushViewController(cadastrarLojaTVC, animated: true)
  }*/
  
}
