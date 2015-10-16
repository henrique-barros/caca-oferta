//
//  CadastrarUsuarioTableViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 8/1/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//



import UIKit

let loginViewControllerID = "login"

class CadastrarUsuarioTableViewController: UIViewController, UITextFieldDelegate {
  
  let tagTextFieldEmail = 11
  let tagTextFieldLoginCadastro = 12
  let tagTextFieldSenhaCadastro = 13

  @IBOutlet weak var textFieldEmail: UITextField!
  
  @IBOutlet weak var textFieldLogin: UITextField!
  
  @IBOutlet weak var textFieldSenha: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textFieldLogin.delegate = self
    textFieldSenha.delegate = self
    textFieldEmail.delegate = self
    textFieldLogin.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onButtonTouchUpInsideCadastrar(sender: UIButton) {
    cadastrar()
  }
  
  @IBAction func onButtonTouchUpInsideVoltar(sender: UIButton) {
    textFieldLogin.resignFirstResponder()
    textFieldSenha.resignFirstResponder()
    textFieldEmail.resignFirstResponder()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func cadastrar() {
    if (textFieldLogin.text != "" || textFieldSenha.text != "" || textFieldEmail.text != "") {
      let user = PFUser()
      user.username = textFieldLogin.text
      user.email = textFieldEmail.text
      user.password = textFieldSenha.text
      user.signUpInBackgroundWithBlock {
        succeeded, error in
        if (succeeded) {
          //The registration was successful, go to the wall
          let cadastroSucedido = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.textFieldEmail.resignFirstResponder()
            self.textFieldLogin.resignFirstResponder()
            self.textFieldSenha.resignFirstResponder()
            self.dismissViewControllerAnimated(true, completion: nil)
          }
          showSimpleAlertWithAction(NSLocalizedString("ok", comment: ""), message: NSLocalizedString("msg_ok_usuario_cadastrado", comment: ""), viewController: self, action: cadastroSucedido)
        } else if let error = error {
          //Something bad has occurred
          print("Error: \(error) \(error.userInfo)")
          showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_cadastro_usuario", comment: ""), viewController: self)
        }
      }
    } else {
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_informacoes_usuario", comment: ""), viewController: self)
    }
  }
  
  
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case tagTextFieldEmail:
      self.view.viewWithTag(tagTextFieldLoginCadastro)?.becomeFirstResponder()
    case tagTextFieldLoginCadastro:
      self.view.viewWithTag(tagTextFieldSenhaCadastro)?.becomeFirstResponder()
    case tagTextFieldSenhaCadastro:
      self.view.viewWithTag(tagTextFieldSenhaCadastro)?.resignFirstResponder()
      cadastrar()
    default:
      break
    }
    return true
  }
  
}
