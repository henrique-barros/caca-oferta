//
//  ListaLojasTableViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 8/22/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit

let tagNomeLoja = 11
let cellLojaID = "cellLoja"

class ListaLojasTableViewController: UITableViewController {
  
  var lojas = [PFObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    inicializar()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lojas.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellLojaID)
    let labelNome = cell!.viewWithTag(tagNomeLoja) as! UILabel
    labelNome.text = lojas[indexPath.row].objectForKey(lojaKeyNome) as? String
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let detalhesLojaTVC: DetalhesLojaTableViewController = storyboard?.instantiateViewControllerWithIdentifier(detalhesLojaTVC_ID) as! DetalhesLojaTableViewController
    detalhesLojaTVC.loja = lojas[indexPath.row]
    navigationController?.pushViewController(detalhesLojaTVC, animated: true)
  }
  
  func inicializar() {
    atualizarNavigationBar()
    lojas = [PFObject]()
    let query = PFQuery(className: lojaKeyClassLoja)
    query.whereKey(lojaKeyDono, equalTo: loggedUser.username!)
    query.findObjectsInBackgroundWithTarget(self, selector: Selector("carregaLojas:"))
  }
  
  func atualizarNavigationBar() {
    self.tabBarController?.navigationItem.title = "teste"
    let botaoAdicionar = UIBarButtonItem(customView:
      BotaoAdicionar(frame:CGRectMake(0, 0, 30, 30), target: self,
        selector: Selector("onButtonTouchUpInsideNavigationBar:")))
    //var botaoAdicionar = UIBarButtonItem(image: UIImage(contentsOfFile: "plus-2-24.png"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("adicionarProduto"))
    self.tabBarController?.navigationItem.setRightBarButtonItem(botaoAdicionar, animated: false)
  }
  
  func carregaLojas(lojas: NSObject) {
    print(lojas.description)
    if let objetosParseLojaBuscadas = lojas as? [PFObject] {
      self.lojas = [PFObject]()
      for loja in objetosParseLojaBuscadas {
        self.lojas.append(loja)
      }
      self.tableView.reloadData()
    }
  }
  
}
