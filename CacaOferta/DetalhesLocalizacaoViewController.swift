//
//  DetalhesLocalizacaoViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 10/23/15.
//  Copyright © 2015 Henrique Barros. All rights reserved.
//

import UIKit

let tagTextFieldNomeProduto = 11
let tagTextFieldMarcaProduto = 12
let tagTextFieldPrecoProduto = 13
let detalhesLocalizacaoCellID = "detalheLocalizacaoCell"

let detalhesLocalID = "detalhesLocalVC"

class DetalhesLocalizacaoViewController: UITableViewController {
  
  
  
  var loja = NSMutableDictionary()
  var produtos = [NSMutableDictionary]()
  var item = NSMutableDictionary()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 72/255, alpha: 1)
    carregaInformacoesLoja()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func carregaInformacoesLoja() {
    let nomeLoja = loja.objectForKey(lojaKeyNome) as! String
    print(nomeLoja.capitalizedString)
    navigationItem.title = nomeLoja.capitalizedString
    
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(detalhesLocalizacaoCellID)
    
    if indexPath.row % 2 == 0 {
      cell!.contentView.backgroundColor = UIColor(red: 255/255, green: 219/255, blue: 72/255, alpha: 1)
    } else {
      cell!.contentView.backgroundColor = UIColor(red: 192/255, green: 170/255, blue: 82/255, alpha: 1)
    }
    
    let textFieldNome = cell?.viewWithTag(tagTextFieldNomeProduto) as! UITextField
    textFieldNome.text = (produtos[indexPath.row].objectForKey(produtoKeyDescricao) as? String)?.capitalizedString
    
    let textFieldMarca = cell?.viewWithTag(tagTextFieldMarcaProduto) as! UITextField
    textFieldMarca.text = (produtos[indexPath.row].objectForKey(produtoKeyMarca) as? String)?.capitalizedString
    
    let textFieldPreco = cell?.viewWithTag(tagTextFieldPrecoProduto) as! UITextField
    textFieldPreco.text = NSLocalizedString("label_dinheiro", comment: "") + String((produtos[indexPath.row] .objectForKey(produtoKeyPreco) as! Double)).capitalizedString
    
    return cell!    
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return produtos.count
  }
  
}
