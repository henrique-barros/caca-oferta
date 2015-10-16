//
//  AdicionarProdutosViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 9/14/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

let adicionarProdutosID = "adicionarProdutos"
let tagTextFieldDescricao = 11
let tagTextFieldMarca = 12
let tagTextFieldPreco = 13
let tagTextViewTags = 14
let tagButtonAdicionar = 15

import UIKit

class AdicionarProdutosViewController: UIViewController {
  
  var loja: PFObject = PFObject(className: lojaKeyClassLoja)
  
  @IBOutlet weak var textFieldDescricao: UITextField!
  @IBOutlet weak var textFieldMarca: UITextField!
  @IBOutlet weak var textFieldValor: UITextField!
  @IBOutlet weak var textViewTags: UITextView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onButtonTouchUpInside(sender: UIButton) {
    switch (sender.tag) {
      case tagButtonAdicionar:
        adicionaProdutoComDadosDaTela()
      default:
        break
    }
  }
  
  func adicionaProdutoComDadosDaTela() {
    //TODO MENSAGEM DE ERRO
    if textFieldDescricao.text!.isEmpty || textFieldMarca.text!.isEmpty || textFieldValor.text!.isEmpty {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_informacoes_produto", comment: ""), viewController: self)
    } else {
      let tags: [String] = textViewTags.text.componentsSeparatedByString(",")
      let scanner = NSScanner(string: textFieldValor.text!)
      var preco: Double = Double()
      scanner.scanDouble(&preco)
      let produto = Produto(descricao: textFieldDescricao.text!, loja: self.loja, marca: textFieldMarca.text!, preco: preco, tags: tags).objetoParseComProduto()
      produto.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        if succeeded {
          self.relacionarLojaComProduto(produto)
          let produtoCadastrado = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.textFieldDescricao.resignFirstResponder()
            self.textFieldMarca.resignFirstResponder()
            self.textFieldValor.resignFirstResponder()
            self.textViewTags.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
          }
          showSimpleAlertWithAction(NSLocalizedString("ok", comment: ""), message: NSLocalizedString("msg_produto_adicionado", comment: ""), viewController: self, action: produtoCadastrado)
        } else {
          print("Error: \(error) \(error!.userInfo)")
          showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_cadastro_produto", comment: ""), viewController: self)
        }
      }
      
    }
  }
  
  func relacionarLojaComProduto(produto: PFObject) {
    let relacaoProdutos = loja.relationForKey(lojaKeyProdutos)
    relacaoProdutos.addObject(produto)
    loja.saveInBackground()
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
