//
//  NovoItemDesejadoViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 10/2/15.
//  Copyright © 2015 Henrique Barros. All rights reserved.
//

import UIKit

let tagNome = 11
let tagTags = 12
let tagLabelNome = 13
let tagLabelTags = 14
let tagBotaoAdicionar = 15

class NovoItemDesejadoViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textFieldNome: UITextField!
  @IBOutlet weak var textViewTags: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textFieldNome.becomeFirstResponder()
    textFieldNome.delegate = self
    textViewTags.delegate = self
    // Do any additional setup after loading the view.
  }
  
  func atualizarTextos() {
    let botaoAdicionar = view.viewWithTag(tagBotaoAdicionar) as! UIButton
    botaoAdicionar.setTitle(NSLocalizedString("botao_adicionar", comment: ""), forState: UIControlState.Normal)
    
    let labelNome = view.viewWithTag(tagLabelNome) as! UILabel
    labelNome.text = NSLocalizedString("label_item", comment: "")
    
    let labelTags = view.viewWithTag(tagLabelTags) as! UILabel
    labelTags.text = NSLocalizedString("label_tags", comment: "")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onButtonTouchUpInside(sender: UIButton) {
    switch(sender.tag) {
    case tagButtonAdd:
      adicionarProduto()
      break
    default:
      break
    }
  }
  
  func adicionarProduto() {
    if (isConnectedToNetwork()) {
      if (textFieldNome.text!.isEmpty || textViewTags.text!.isEmpty) {
        showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_informacoes_item_desejado", comment: ""), viewController: self)
      } else {
        var listaProdutos = loggedUser.objectForKey(usuarioKeyItensDesejados)
        
        if(listaProdutos == nil) {
          listaProdutos = NSMutableArray()
        }
            
        let itemDesejado = NSMutableDictionary()
        itemDesejado.setObject(textFieldNome.text!, forKey: usuarioKeyItemDesejadoDescricao)
        itemDesejado.setObject(textViewTags.text!, forKey: usuarioKeyItemDesejadoTags)
        
        listaProdutos?.addObject(itemDesejado)
        
        loggedUser.setObject(listaProdutos!, forKey: usuarioKeyItensDesejados)
        
        loggedUser.saveInBackgroundWithBlock { (succeeded, error) -> Void in
          if succeeded {
            let itemCadastrado = UIAlertAction(title: "OK", style: .Default) { (action) in
              self.textViewTags.resignFirstResponder()
              self.textFieldNome.resignFirstResponder()
              self.navigationController?.popViewControllerAnimated(true)
            }
            showSimpleAlertWithAction(NSLocalizedString("ok", comment: ""), message: NSLocalizedString("msg_item_adicionado", comment: ""), viewController: self, action: itemCadastrado)
          } else {
            showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: "msg_erro_cadastro_item", viewController: self)
          }
        }
      }
    } else {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_internet", comment: ""), viewController: self)
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case tagNome:
      textViewTags.becomeFirstResponder()
    case tagTags:
      textViewTags.resignFirstResponder()
      adicionarProduto()
    default:
      break
    }
    return true
  }
  
}
