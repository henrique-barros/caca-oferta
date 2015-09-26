//
//  BotaoAdicionar.swift
//  CacaOferta
//
//  Created by Henrique Barros on 8/26/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

import UIKit

class BotaoAdicionar: UIButton {
  
  init(frame: CGRect, target: AnyObject, selector: Selector) {
    super.init(frame: frame)
    self.frame = frame
    super.addTarget(target, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect) {
    let path = UIBezierPath(ovalInRect: rect)
    UIColor.orangeColor().setFill()
    path.fill()
    let plusHeight: CGFloat = 3.0
    let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
    
    //create the path
    let plusPath = UIBezierPath()
    
    //set the path's line width to the height of the stroke
    plusPath.lineWidth = plusHeight
    
    //move the initial point of the path
    //to the start of the horizontal stroke
    plusPath.moveToPoint(CGPoint(
      x:bounds.width/2 - plusWidth/2 + 0.5,
      y:bounds.height/2 + 0.5))
    
    //add a point to the path at the end of the stroke
    plusPath.addLineToPoint(CGPoint(
      x:bounds.width/2 + plusWidth/2 + 0.5,
      y:bounds.height/2 + 0.5))
    
    plusPath.moveToPoint(CGPoint(
      x:bounds.width/2 + 0.5,
      y:bounds.height/2 - plusWidth/2 + 0.5))
    
    //add the end point to the vertical stroke
    plusPath.addLineToPoint(CGPoint(
      x:bounds.width/2 + 0.5,
      y:bounds.height/2 + plusWidth/2 + 0.5))
    
    //set the stroke color
    UIColor.whiteColor().setStroke()
    
    //draw the stroke
    plusPath.stroke()
  }
}
