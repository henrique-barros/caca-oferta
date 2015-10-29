//
//  BotaoLogout.swift
//  CacaOferta
//
//  Created by Henrique Barros on 10/24/15.
//  Copyright © 2015 Henrique Barros. All rights reserved.
//

import UIKit

class BotaoLogout: UIButton {

  init(frame: CGRect, target: AnyObject, selector: Selector, image: UIImage) {
    super.init(frame: frame)
    self.frame = frame
    self.setBackgroundImage(image, forState: UIControlState.Normal)
    super.addTarget(target, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func drawRect(rect: CGRect) {
    
  }
}
