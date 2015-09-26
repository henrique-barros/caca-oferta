//
//  Produto.swift
//  CacaOferta
//
//  Created by Henrique Barros on 9/14/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit

let produtoKeyDescricao = "descricao"
let produtoKeyTags = "tags"
let produtoKeyPreco = "preco"
let produtoKeyLoja = "loja"
let produtoKeyMarca = "marca"
let produtoKeyClass = "Produto"

class Produto: NSObject {
  var descricao: String
  var tags: [String]
  var preco: Double
  var loja: PFObject
  var marca: String
    
  init(descricao: String, loja: PFObject, marca: String, preco: Double, tags: [String]) {
    self.descricao = descricao
    self.loja = loja
    self.marca = marca
    self.preco = preco
    self.tags = tags
  }
  
  init(dicionario: NSObject) {
    if (dicionario.isKindOfClass(PFObject)) {
      let dicionario = dicionario as! PFObject
      descricao = dicionario.objectForKey(produtoKeyDescricao) as! String
      loja = dicionario.objectForKey(produtoKeyLoja) as! PFObject
      marca = dicionario.objectForKey(produtoKeyMarca) as! String
      preco = dicionario.objectForKey(produtoKeyPreco) as! Double
      tags = dicionario.objectForKey(produtoKeyTags) as! [String]
    } else {
      let dicionario = dicionario as! NSDictionary
      descricao = dicionario.objectForKey(produtoKeyDescricao) as! String
      loja = dicionario.objectForKey(produtoKeyLoja) as! PFObject
      marca = dicionario.objectForKey(produtoKeyMarca) as! String
      preco = dicionario.objectForKey(produtoKeyPreco) as! Double
      tags = dicionario.objectForKey(produtoKeyTags) as! [String]
    }
  }
  
  func objetoParseComProduto() -> PFObject {
    let objetoParse = PFObject(className: produtoKeyClass)
    
    objetoParse.setObject(descricao, forKey: produtoKeyDescricao)
    objetoParse.setObject(preco, forKey: produtoKeyPreco)
    objetoParse.setObject(marca, forKey: produtoKeyMarca)
    objetoParse.setObject(tags, forKey: produtoKeyTags)
    let relacaoLoja =  objetoParse.relationForKey(produtoKeyLoja)
    relacaoLoja.addObject(loja)
    
    return objetoParse
  }
  
   
}
