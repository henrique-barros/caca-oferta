//
//  Login.swift
//  CacaOferta
//
//  Created by Henrique Barros on 8/1/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  
  let tagBotaoEntrar = 11
  let tagBotaoCadastrar = 10
  let tagTextFieldLogin = 12
  let tagTextFieldSenha = 13
  let tagLabelLogin = 14
  let tagLabelSenha = 15
  let menuID = "menu"
  let cadastrarID = "cadastrar"
  
  @IBOutlet weak var textFieldLogin: UITextField!
  @IBOutlet weak var textFieldSenha: UITextField!
  
  override func viewDidLoad() {
    atualizarTextos()
    textFieldLogin.delegate = self
    textFieldSenha.delegate = self
    textFieldLogin.becomeFirstResponder()
  }
  
  func atualizarTextos() {
    let botaoCadastrar = view.viewWithTag(tagBotaoCadastrar) as! UIButton
    botaoCadastrar.setTitle(NSLocalizedString("botao_cadastrar", comment: ""), forState: UIControlState.Normal)
    
    let botaoEntrar = view.viewWithTag(tagBotaoEntrar) as! UIButton
    botaoEntrar.setTitle(NSLocalizedString("botao_entrar", comment: ""), forState: UIControlState.Normal)
    
    let labelLogin = view.viewWithTag(tagLabelLogin) as! UILabel
    labelLogin.text = NSLocalizedString("label_login", comment: "")
    
    let labelSenha = view.viewWithTag(tagLabelSenha) as! UILabel
    labelSenha.text = NSLocalizedString("label_senha", comment: "")
  }
  
  @IBAction func onButtonTouchUpInside(sender: UIButton) {
    switch sender.tag {
      case tagBotaoEntrar:
        validarUsuarioEIniciar(textFieldLogin.text!, senha: textFieldSenha.text!)
      case tagBotaoCadastrar:
        loadCadastrar()
      default:
        break
    }
  }
  
  /*
  func login() {
    if let user = validarUsuario(textFieldLogin.text, senha: textFieldSenha.text) {
      iniciarAplicacao(user)
    }
  }*/
  
  func validarUsuarioEIniciar(user: String, senha: String) {
    PFUser.logInWithUsernameInBackground(user, password: senha, target: self, selector: Selector("iniciarAplicacao:"))
    //return PFUser.logInWithUsername(user, password: senha)
  }
  
  func iniciarAplicacao(user: NSObject) {
    if let _ = user as? PFUser {
      loggedUser = user as! PFUser
      PFInstallation.currentInstallation().setObject(loggedUser.username!, forKey: "user")
      PFInstallation.currentInstallation().saveEventually()
      print(loggedUser.username!)
      let viewController: UITabBarController = self.storyboard?.instantiateViewControllerWithIdentifier(menuID) as! UITabBarController
      let navController: UINavigationController = UINavigationController(rootViewController: viewController)
      
      navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
    else {
      print("dados errados")
      showSimpleAlertWithTitle(NSLocalizedString("erro", comment: ""), message: NSLocalizedString("msg_erro_login", comment: ""), viewController: self)
    }
  }
  
  func loadCadastrar() {
    let viewController: CadastrarUsuarioTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier(cadastrarID) as! CadastrarUsuarioTableViewController
    self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case tagTextFieldLogin:
      self.view.viewWithTag(tagTextFieldSenha)?.becomeFirstResponder()
    case tagTextFieldSenha:
      self.view.viewWithTag(tagTextFieldSenha)?.resignFirstResponder()
      validarUsuarioEIniciar(textFieldLogin.text!, senha: textFieldSenha.text!)
    default:
      break
    }
    return true
  }
  

}
