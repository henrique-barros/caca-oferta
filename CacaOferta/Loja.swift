//
//  Loja.swift
//  CacaOferta
//
//  Created by Henrique Barros on 7/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit
import MapKit

let lojaKeyGeoPoint = "geoPoint"
let lojaKeyLatitude = "latitude"
let lojaKeyLongitude = "longitude"
let lojaKeyNome = "nome"
let lojaKeyDescricao = "descricao"
let lojaKeyId = "id"
let lojaKeyProdutos = "produtos"
let lojaKeyDono = "dono"
let lojaKeyClassLoja = "Loja"

class Loja: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var nome: String
  var descricao: String
  var id: String
  var produtos: [NSMutableDictionary]
  var dono: String
  
  init(coordinate: CLLocationCoordinate2D, nome: String, descricao: String, dono: String) {
    self.coordinate = coordinate
    self.nome = nome
    self.descricao = descricao
    self.id = NSUUID().UUIDString
    self.produtos = []
    self.dono = dono
  }
  
  init(dicionario: NSDictionary) {
    let latitude = dicionario.objectForKey(lojaKeyLatitude) as! CLLocationDegrees
    let longitude = dicionario.objectForKey(lojaKeyLongitude)as! CLLocationDegrees
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    nome = dicionario.objectForKey(lojaKeyNome) as! String
    id = dicionario.objectForKey(lojaKeyId) as! String
    descricao = dicionario.objectForKey(lojaKeyDescricao) as! String
    produtos = dicionario.objectForKey(lojaKeyProdutos) as! [NSMutableDictionary]
    dono = dicionario.objectForKey(lojaKeyDono) as! String
  }
  
  init(parseObject: PFObject) {
    let geoPoint = parseObject.objectForKey(lojaKeyGeoPoint) as! PFGeoPoint
    coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
    nome = parseObject.objectForKey(lojaKeyNome) as! String
    descricao = parseObject.objectForKey(lojaKeyDescricao) as! String
    id = parseObject.objectForKey(lojaKeyId) as! String
    produtos = parseObject.objectForKey(lojaKeyProdutos) as! [NSMutableDictionary]
    dono = parseObject.objectForKey(lojaKeyDono) as! String
  }
  
  required init(coder decoder: NSCoder) {
    let latitude = decoder.decodeDoubleForKey(lojaKeyLatitude)
    let longitude = decoder.decodeDoubleForKey(lojaKeyLongitude)
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    id = decoder.decodeObjectForKey(lojaKeyNome) as! String
    nome = decoder.decodeObjectForKey(lojaKeyNome) as! String
    descricao = decoder.decodeObjectForKey(lojaKeyDescricao) as! String
    produtos = decoder.decodeObjectForKey(lojaKeyProdutos) as! [NSMutableDictionary]
    dono = decoder.decodeObjectForKey(lojaKeyDono) as! String
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeDouble(coordinate.latitude, forKey: lojaKeyLatitude)
    coder.encodeDouble(coordinate.longitude, forKey: lojaKeyLongitude)
    coder.encodeObject(nome, forKey: lojaKeyNome)
    coder.encodeObject(descricao, forKey: lojaKeyDescricao)
    coder.encodeObject(id, forKey: lojaKeyId)
    coder.encodeObject(produtos, forKey: lojaKeyProdutos)
    coder.encodeObject(dono, forKey: lojaKeyDono)
  }
  
  func objetoParseComLoja() -> PFObject {
    let objetoParse = PFObject(className: lojaKeyClassLoja)
    
    objetoParse.setObject(PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: lojaKeyGeoPoint)
    objetoParse.setObject(nome, forKey: lojaKeyNome)
    objetoParse.setObject(descricao, forKey: lojaKeyDescricao)
    objetoParse.setObject(id, forKey: lojaKeyId)
    objetoParse.setObject(produtos, forKey: lojaKeyProdutos)
    objetoParse.setObject(dono, forKey: lojaKeyDono)
    
    return objetoParse
  }
  
  func toDictionary() -> NSMutableDictionary {
    let dicionario = NSMutableDictionary()
    dicionario.setObject(PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), forKey: lojaKeyGeoPoint)
    dicionario.setObject(id, forKey: lojaKeyId)
    dicionario.setObject(nome, forKey: lojaKeyNome)
    dicionario.setObject(produtos, forKey: lojaKeyProdutos)
    dicionario.setObject(dono, forKey: lojaKeyDono)
    dicionario.setObject(descricao, forKey: lojaKeyDescricao)
    return dicionario
  }
}
