//
//  ListaComprasTVC.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/18/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit

let itemCell = "listaComprasCell"
let tagItem = 11
let tagDeleteButton = 12
let mapaProdutoController = "mapaProdutoController"
let buttonAdicionarWidth: CGFloat = 24.0
let buttonAdicionarHeight: CGFloat = 24.0
let novoItemVC = "novoItemVC"


class ListaComprasTVC: UITableViewController {
  
  
  
  private var vlsItens: NSMutableArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fIniciar()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func fIniciar() {
    vlsItens = loggedUser.objectForKey(usuarioKeyItensDesejados) as! NSMutableArray
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return vlsItens.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell: UITableViewCell = (tableView.dequeueReusableCellWithIdentifier(itemCell))!
    
    let voLabel = cell.viewWithTag(tagItem) as? UILabel
    voLabel?.text = vlsItens.objectAtIndex(indexPath.row).objectForKey(usuarioKeyItemDesejadoDescricao) as? String
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let mapaProduto: MapaProdutoController = self.storyboard!
      .instantiateViewControllerWithIdentifier(mapaProdutoController) as!
    MapaProdutoController
    navigationController!.pushViewController(mapaProduto, animated: true)
  }
  
  override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 40
  }
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0.0,y: 0.0,width: self.view.frame.width,height: 40))
    print(view.frame)
    let buttonAdicionar = UIButton(frame: CGRect(x: self.view.frame.width/2 - buttonAdicionarWidth/2, y: 20 - buttonAdicionarHeight/2, width: buttonAdicionarWidth, height: buttonAdicionarHeight))
    buttonAdicionar.addTarget(self, action: Selector("adicionarItem"), forControlEvents: UIControlEvents.TouchUpInside)
    buttonAdicionar.setImage(UIImage(named: "plus-2-24.png"), forState: UIControlState.Normal)
    view.addSubview(buttonAdicionar)
    buttonAdicionar.tag = tagButtonAdd
    return view
  }
  
  func adicionarItem() {
    let novoItemViewController = self.storyboard?.instantiateViewControllerWithIdentifier(novoItemVC)
    self.navigationController?.showViewController(novoItemViewController!, sender: self)
  }
  
}
