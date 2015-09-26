//
//  DetalhesLojaTableViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 8/26/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

let detalhesLojaTVC_ID = "detalhesLojaTVC"
let produtoCell = "produtoCell"
let descricaoProdutoTag = 11

import UIKit

class DetalhesLojaTableViewController: UITableViewController {
  
  var loja: PFObject = PFObject(className: lojaKeyClassLoja)
  var produtos = [PFObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(loja.description)
    self.fInicializar()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return produtos.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(produtoCell) as UITableViewCell?
    let labelDescricao = cell!.viewWithTag(descricaoProdutoTag) as! UILabel?
    labelDescricao!.text = produtos[indexPath.row].objectForKey(produtoKeyDescricao) as! String?
    return cell!
  }
  
  func atualizarNavigationBar() {
    self.navigationItem.title = "Produtos2"
    let botaoAdicionar = UIBarButtonItem(customView:
      BotaoAdicionar(frame:CGRectMake(0, 0, 30, 30), target: self,
        selector: Selector("onButtonTouchUpInsideNavigationBar:")))
    
    //var botaoAdicionar = UIBarButtonItem(image: UIImage(contentsOfFile: "plus-2-24.png"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("adicionarProduto"))
    self.navigationItem.setRightBarButtonItem(botaoAdicionar, animated: false)
  }
  
  func fInicializar() {
    self.atualizarNavigationBar()
    self.buscarProdutos()
  }
  
  func buscarProdutos() {
    let query = PFQuery(className: produtoKeyClass)
    query.whereKey(produtoKeyLoja, equalTo: loja)
    query.findObjectsInBackgroundWithTarget(self, selector: Selector("carregaProdutos:"))
  }
  
  func carregaProdutos(produtos: NSObject) {
    print(produtos.description)
    if let objetosParseProdutos = produtos as? [PFObject] {
      self.produtos = [PFObject]()
      for produto in objetosParseProdutos {
        self.produtos.append(produto)
      }
      self.tableView.reloadData()
    }
  }
  
  func onButtonTouchUpInsideNavigationBar(sender: UIBarButtonItem) {
    let adicionaProdutosVC :AdicionarProdutosViewController = self.storyboard?.instantiateViewControllerWithIdentifier(adicionarProdutosID) as! AdicionarProdutosViewController
    adicionaProdutosVC.loja = loja
    self.navigationController?.pushViewController(adicionaProdutosVC, animated: true)
  }

}
