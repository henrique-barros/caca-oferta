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
    
    tableView.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1)
  }
  
  override func viewWillAppear(animated: Bool) {
    print("viewWillAppear")
    print(self.description)
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
    
    if indexPath.row % 2 == 0 {
      cell!.contentView.backgroundColor = UIColor(red: 240/255, green: 250/255, blue: 255/255, alpha: 1)
    } else {
      cell!.contentView.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1)
    }
    
    let labelNome = cell!.viewWithTag(tagNomeLoja) as! UILabel
    labelNome.text = lojas[indexPath.row].objectForKey(lojaKeyNome) as? String
    
    let buttonDelete = cell!.viewWithTag(tagDeleteButton) as! UIButton
    buttonDelete.accessibilityValue = "\(indexPath.row)"
    buttonDelete.addTarget(self, action: Selector("removerLoja:"), forControlEvents: UIControlEvents.TouchUpInside)
    
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let detalhesLojaTVC: DetalhesLojaTableViewController = storyboard?.instantiateViewControllerWithIdentifier(detalhesLojaTVC_ID) as! DetalhesLojaTableViewController
    detalhesLojaTVC.loja = lojas[indexPath.row]
    navigationController?.pushViewController(detalhesLojaTVC, animated: true)
  }
  
  func inicializar() {
    let query = PFQuery(className: lojaKeyClassLoja)
    query.whereKey(lojaKeyDono, equalTo: loggedUser.username!)
    query.findObjectsInBackgroundWithTarget(self, selector: Selector("carregaLojas:"))
  }
  
  func logout() {
    doLogout(self)
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0.0,y: 0.0,width: self.view.frame.width,height: 40))
    print(view.frame)
    let buttonAdicionar = UIButton(frame: CGRect(x: self.view.frame.width/2 - buttonAdicionarWidth/2, y: 20 - buttonAdicionarHeight/2, width: buttonAdicionarWidth, height: buttonAdicionarHeight))
    buttonAdicionar.addTarget(self, action: Selector("adicionarLoja:"), forControlEvents: UIControlEvents.TouchUpInside)
    buttonAdicionar.setImage(UIImage(named: "plus-2-24.png"), forState: UIControlState.Normal)
    view.addSubview(buttonAdicionar)
    buttonAdicionar.tag = tagButtonAdd
    return view
  }
  
  func adicionarLoja(sender: UIButton) {
    let novaLojaVC = self.storyboard?.instantiateViewControllerWithIdentifier(cadastrarLojaID)
    self.navigationController?.showViewController(novaLojaVC!, sender: self)
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
  
  func removerLoja(sender: UIButton) {
    let confirmAction = UIAlertAction(title: "OK", style: .Default) { (action) in
      let loja = self.lojas[Int(sender.accessibilityValue!)!]
      self.lojas.removeAtIndex(Int(sender.accessibilityValue!)!)
      loja.deleteInBackground()
      self.tableView.reloadData()
    }
    showSimpleAlertWithConfirmAction(NSLocalizedString("atencao", comment: ""), message: NSLocalizedString("msg_alerta_deletar_loja", comment: ""), viewController: self, action: confirmAction)
    
  }
}
