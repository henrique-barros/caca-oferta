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
let tagLabelDescricao = 16
let tagLabelMarca = 17
let tagLabelValor = 18
let tagLabelTagsProduto = 19

import UIKit

class AdicionarProdutosViewController: UIViewController, UITextFieldDelegate {
  
  var loja: PFObject = PFObject(className: lojaKeyClassLoja)
  
  @IBOutlet weak var textFieldDescricao: UITextField!
  @IBOutlet weak var textFieldValor: UITextField!
  @IBOutlet weak var textFieldMarca: UITextField!
  @IBOutlet weak var textViewTags: UITextField!

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textFieldDescricao.becomeFirstResponder()
    textFieldMarca.delegate = self
    textFieldValor.delegate = self
    textViewTags.delegate = self
    textFieldDescricao.delegate = self
    atualizarTextos()
  }
  
  func atualizarTextos() {
    let botaoAdicionar = view.viewWithTag(tagButtonAdicionar) as! UIButton
    botaoAdicionar.setTitle(NSLocalizedString("botao_adicionar", comment: ""), forState: UIControlState.Normal)
    
    let labelDescricao = view.viewWithTag(tagLabelDescricao) as! UILabel
    labelDescricao.text = NSLocalizedString("label_descricao", comment: "")
    
    let labelMarca = view.viewWithTag(tagLabelMarca) as! UILabel
    labelMarca.text = NSLocalizedString("label_marca", comment: "")
    
    let labelValor = view.viewWithTag(tagLabelValor) as! UILabel
    labelValor.text = NSLocalizedString("label_valor", comment: "")
    
    let labelTags = view.viewWithTag(tagLabelTagsProduto) as! UILabel
    labelTags.text = NSLocalizedString("label_tags", comment: "")
    
    navigationItem.title = NSLocalizedString("title_adicionar_produtos", comment: "")
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
    if (isConnectedToNetwork()) {
      if textFieldDescricao.text!.isEmpty || textFieldMarca.text!.isEmpty || textFieldValor.text!.isEmpty {
        showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_informacoes_produto", comment: ""), viewController: self)
      } else {
        let tags: [String] = textViewTags.text!.componentsSeparatedByString(",")
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
    } else {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_internet", comment: ""), viewController: self)
    }
  }
  
  func relacionarLojaComProduto(produto: PFObject) {
    let relacaoProdutos = loja.relationForKey(lojaKeyProdutos)
    relacaoProdutos.addObject(produto)
    loja.saveInBackground()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case tagTextFieldDescricao:
      textFieldMarca.becomeFirstResponder()
    case tagTextFieldMarca:
      textFieldValor.becomeFirstResponder()
    case tagTextFieldPreco:
      textViewTags.becomeFirstResponder()
    case tagTextViewTags:
      textViewTags.resignFirstResponder()
      self.adicionaProdutoComDadosDaTela()
    default:
      break
    }
    return true
  }
}
