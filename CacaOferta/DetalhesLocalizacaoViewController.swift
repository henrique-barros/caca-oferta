//
//  DetalhesLocalizacaoViewController.swift
//  CacaOferta
//
//  Created by Henrique Barros on 10/23/15.
//  Copyright © 2015 Henrique Barros. All rights reserved.
//

import UIKit

let detalhesLocalID = "detalhesLocalVC"

class DetalhesLocalizacaoViewController: UIViewController {
  
  var loja = NSMutableDictionary()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(loja.description)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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