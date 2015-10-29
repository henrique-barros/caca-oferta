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
    self.atualizarNavigationBar()
    
    tableView.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1)
    
    navigationItem.title = NSLocalizedString("title_detalhes_loja", comment: "")
  }
  
  override func viewWillAppear(animated: Bool) {
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
    
    if indexPath.row % 2 == 0 {
      cell!.contentView.backgroundColor = UIColor(red: 240/255, green: 250/255, blue: 255/255, alpha: 1)
    } else {
      cell!.contentView.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1)
    }
    
    let labelDescricao = cell!.viewWithTag(descricaoProdutoTag) as! UILabel?
    labelDescricao!.text = produtos[indexPath.row].objectForKey(produtoKeyDescricao) as! String?
    
    let buttonDelete = cell?.viewWithTag(tagDeleteButton) as! UIButton
    buttonDelete.accessibilityValue = "\(indexPath.row)"
    buttonDelete.addTarget(self, action: Selector("removerProduto:"), forControlEvents: UIControlEvents.TouchUpInside)
    
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
  
  override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x: 0.0,y: 0.0,width: self.view.frame.width,height: 40))
    print(view.frame)
    let buttonAdicionar = UIButton(frame: CGRect(x: self.view.frame.width/2 - buttonAdicionarWidth/2, y: 20 - buttonAdicionarHeight/2, width: buttonAdicionarWidth, height: buttonAdicionarHeight))
    buttonAdicionar.addTarget(self, action: Selector("adicionarProduto:"), forControlEvents: UIControlEvents.TouchUpInside)
    buttonAdicionar.setImage(UIImage(named: "plus-2-24.png"), forState: UIControlState.Normal)
    view.addSubview(buttonAdicionar)
    buttonAdicionar.tag = tagButtonAdd
    return view
  }
  
  func fInicializar() {
    self.buscarProdutos()
  }
  
  func buscarProdutos() {
    let query = PFQuery(className: produtoKeyClass)
    query.whereKey(produtoKeyLoja, equalTo: loja)
    query.findObjectsInBackgroundWithTarget(self, selector: Selector("carregaProdutos:"))
  }
  
  func carregaProdutos(produtos: NSObject) {
    if let objetosParseProdutos = produtos as? [PFObject] {
      self.produtos = [PFObject]()
      for produto in objetosParseProdutos {
        self.produtos.append(produto)
      }
      self.tableView.reloadData()
    }
  }
  
  func adicionarProduto(sender: UIBarButtonItem) {
    let adicionaProdutosVC :AdicionarProdutosViewController = self.storyboard?.instantiateViewControllerWithIdentifier(adicionarProdutosID) as! AdicionarProdutosViewController
    adicionaProdutosVC.loja = loja
    self.navigationController?.pushViewController(adicionaProdutosVC, animated: true)
  }
  
  func removerProduto(sender: UIButton) {
    let actionRemover = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default) { (action) in
      let produto = self.produtos[Int(sender.accessibilityValue!)!]
      self.produtos.removeAtIndex(Int(sender.accessibilityValue!)!)
      produto.deleteInBackground()
      self.tableView.reloadData()
    }
    
    showSimpleAlertWithConfirmAction(NSLocalizedString("atencao", comment: ""), message: NSLocalizedString("msg_alerta_deletar_produto", comment: ""), viewController: self, action: actionRemover)
  }

}
