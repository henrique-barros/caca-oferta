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
        print("Botao desconhecido")
    }
  }
  
  func adicionaProdutoComDadosDaTela() {
    //TODO MENSAGEM DE ERRO
    if textFieldDescricao.text!.isEmpty {
      print("Sem descricao")
    }
    else if textFieldMarca.text!.isEmpty {
      print("Sem marca")
    }
    else if textFieldValor.text!.isEmpty {
      print("Sem valor")
    }
    else {
      let tags: [String] = textViewTags.text.componentsSeparatedByString(",")
      let scanner = NSScanner(string: textFieldValor.text!)
      var preco: Double = Double()
      scanner.scanDouble(&preco)
      let produto = Produto(descricao: textFieldDescricao.text!, loja: self.loja, marca: textFieldMarca.text!, preco: preco, tags: tags).objetoParseComProduto()
      produto.saveInBackgroundWithBlock { (succeeded, error) -> Void in
        if succeeded {
          print("Object Uploaded")
        } else {
          print("Error: \(error) \(error!.userInfo)")
        }
      }
      
    }
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
