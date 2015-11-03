//
//  AppDelegate.swift
//  CompreFacil
//
//  Created by Henrique Barros on 6/20/15.
//  Copyright (c) 2015 Henrique Barros. All rights reserved.
//

let keyLatitude = "latitude"
let keyLongitude = "longitude"
let keyLojasRelevantes = "lojasRelevantes"
let keyProdutosRelevantes = "produtosRelevantes"

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
  
  var window: UIWindow?
  
  var lojasProximas: [Loja] = []
  
  let locationManager = CLLocationManager() // Add this statement
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Parse.setApplicationId("ZUcFKMC2mxM5T3F1yfIrCpFsCNGZgYqOZbpyeb2p", clientKey: "1B8UweGBMEFFuv9mmhk2wMeXZqBDtj1FPW1J7BDS")
    
    
    //Enable push notifications
    /*let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
    
    let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()*/
    
    
    let currentInstallation = PFInstallation.currentInstallation()
    if !(currentInstallation.objectForKey("channels")?.containsObject("Lojas") != nil) {
      currentInstallation.addUniqueObject("Lojas", forKey: "channels")
      currentInstallation.saveInBackground()
      print("salvou lojas")
    }
    
    // Register for Push Notitications
    if application.applicationState != UIApplicationState.Background {
      // Track an app open here if we launch with a push, unless
      // "content_available" was used to trigger a background push (introduced in iOS 7).
      // In that case, we skip tracking here to avoid double counting the app-open.
      
      let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
      let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
      var pushPayload = false
      if let options = launchOptions {
        pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
      }
      if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
      }
    }
    if application.respondsToSelector("registerUserNotificationSettings:") {
      let userNotificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
      let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
    } else {
      application.registerForRemoteNotifications()
    }
    
    
    inicializar()
    /*
    let player = PFObject(className: "Player")
    player.setObject("John", forKey: "Name")
    player.setObject(1230, forKey: "Score")
    player.saveInBackgroundWithBlock { (succeeded, error) -> Void in
      if succeeded {
        println("Object Uploaded")
      } else {
        println("Error: \(error) \(error!.userInfo!)")
      }
    }
    
    let user = PFUser()
    user.username = "user1"
    user.password = "user1"
    user.signUpInBackgroundWithBlock {
      succeeded, error in
      if (succeeded) {
        //The registration was successful, go to the wall
        println("registrou")
      } else if let error = error {
        //Something bad has occurred
        println("Error: \(error) \(error.userInfo!)")
      }
    }
    */
    
    
    
    return true
  }
  
  
  // pUSH NOTIFICATION
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let installation = PFInstallation.currentInstallation()
    installation.setDeviceTokenFromData(deviceToken)
    installation.saveInBackground()
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    if error.code == 3010 {
      print("Push notifications are not supported in the iOS Simulator.")
    } else {
      print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PFPush.handlePush(userInfo)
    var json: AnyObject = ""
    do {
      let data = try NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted)
      
      json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
      
      if (json.objectForKey(keyLojasRelevantes)?.firstObject != nil) {
        lojasRelevantes = json.objectForKey(keyLojasRelevantes) as! NSMutableArray
        produtosRelevantes = json.objectForKey(keyProdutosRelevantes) as! NSMutableArray
      }
    } catch {
        
    }
        
    if application.applicationState == UIApplicationState.Inactive {
      PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    }
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func handleRegionEvent(region: CLRegion!) {
    //TODO
    // Show an alert if application is active
    if UIApplication.sharedApplication().applicationState == .Active {
      /*if let message = notefromRegionIdentifier(region.identifier) {
      if let viewController = window?.rootViewController {
      showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
      }
      }*/
    } else {
      // Otherwise present a local notification
      /*var notification = UILocalNotification()
      notification.alertBody = notefromRegionIdentifier(region.identifier)
      notification.soundName = "Default";
      UIApplication.sharedApplication().presentLocalNotificationNow(notification)*/
    }
  }
  
  // TODO Fazer um similar a esse
  /*func notefromRegionIdentifier(identifier: String) -> String? {
  if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
  for savedItem in savedItems {
  if let geotification = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? Geotification {
  if geotification.identifier == identifier {
  return geotification.note
  }
  }
  }
  }
  return nil
  }*/
  
  // Funcoes da classe
  func inicializar() {
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func procurarLojas() {
    
    //Seria isso shit code? TODO TIRAR
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      if let userLocation = self.locationManager.location {
        println("teste")
        var query = PFQuery(className: lojaKeyClassLoja)
        query.whereKey(lojaKeyGeoPoint, nearGeoPoint: PFGeoPoint(location: userLocation), withinKilometers: 1)
        let objetosParseLojasProximas = query.findObjects() as! [PFObject]
        self.lojasProximas.removeAll(keepCapacity: true)
        if objetosParseLojasProximas.count > 0 {
          for i in 0...(objetosParseLojasProximas.count-1) {
            println(i)
            self.lojasProximas.append(Loja(parseObject: objetosParseLojasProximas[i]))
          }
        }
        let push = PFPush()
        push.setChannel("Lojas")
        push.setMessage("\(self.lojasProximas.count) loja(s) foram encontradas.")
        push.sendPushInBackground()
      }
    }*/
    if (loggedUser.username != nil) {
      if (isConnectedToNetwork()) {
        let parameters = NSMutableDictionary()
        if let userLocation = self.locationManager.location {
          parameters.setObject(userLocation.coordinate.latitude, forKey: keyLatitude)
          parameters.setObject(userLocation.coordinate.longitude, forKey: keyLongitude)
          parameters.setObject(loggedUser.username!, forKey: usuarioKeyUsername)
          parameters.setObject(loggedUser.objectForKey(usuarioKeyItensDesejados)!, forKey: usuarioKeyItensDesejados)
          //PFCloud.callFunctionInBackground("enviaLocalizacao", withParameters: parameters as [NSObject : AnyObject])
          PFCloud.callFunctionInBackground("enviaLocalizacao", withParameters: parameters as [NSObject : AnyObject], target: self, selector: nil)
        }
      }
    }
  }
  
  // CLLocationManagerDelegate
  
  func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleRegionEvent(region)
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == CLAuthorizationStatus.AuthorizedAlways {
      let a: NSTimeInterval = 10
      _ = NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: Selector("procurarLojas"), userInfo: nil, repeats: true)
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    
  }
  
}

