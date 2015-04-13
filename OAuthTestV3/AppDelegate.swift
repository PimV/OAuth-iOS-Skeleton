//
//  AppDelegate.swift
//  OAuthTestV3
//
//  Created by User on 11/04/15.
//  Copyright (c) 2015 Avans. All rights reserved.
//

import UIKit
import OAuthSwift





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let oauthswift = OAuth1Swift(
        consumerKey:    "133d15c89cd1187784f48fff59fd7c2f0f4674fe",
        consumerSecret: "2dc073a5eac796c04e724c04d231544fba31682d",
        requestTokenUrl: "https://publicapi.avans.nl/oauth/request_token",
        authorizeUrl:    "https://publicapi.avans.nl/oauth/login.php",
        accessTokenUrl:  "https://publicapi.avans.nl/oauth/access_token"
    )
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        cacheExpired(defaults, duration: 1)
        
        var oauth_token: String = ""
        var oauth_token_secret: String = ""
        
        if let tokenNotNill = defaults.objectForKey("oauth_token") as? String {
            oauth_token = defaults.objectForKey("oauth_token") as! String
        }
        if let secretNotNill = defaults.objectForKey("oauth_token_secret") as? String {
            oauth_token_secret = defaults.objectForKey("oauth_token_secret") as! String
        }
        if !oauth_token.isEmpty && !oauth_token_secret.isEmpty {
            oauthswift.client.setUserDetails(oauth_token, secret: oauth_token_secret)
            return true
        } else {
            oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/avans")!, success: {
                credential, response in            println("success")
                var myCred: OAuthSwiftCredential = credential
                
                defaults.setObject(myCred.oauth_token, forKey: "oauth_token")
                defaults.setObject(myCred.oauth_token_secret, forKey: "oauth_token_secret")
                defaults.synchronize()
                
                self.oauthswift.client.setUserDetails(myCred.oauth_token, secret: myCred.oauth_token_secret)
                }, failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
                    println("ERROR")
                }
            )
            
        }
        
        
        // OAuth1.0
        
         return true
        
        
        
        
      
    }

    func cacheExpired(cache: NSUserDefaults, duration: Int) -> Bool {
        if let tokenNotNill = cache.objectForKey("expirationObject") as? NSDate {
            println("Copmaring cache object")
            var expirationObject = cache.objectForKey("expirationObject") as! NSDate
            
            let cal = NSCalendar.currentCalendar()
            
            
            //let components = cal.components( .CalendarUnitSecond, fromDate: expirationObject, toDate: NSDate(), options: nil)
            let components = cal.components( .CalendarUnitMinute, fromDate: expirationObject, toDate: NSDate(), options: nil)
            if (components.minute >= duration) {
                println("\(components.minute) is bigger than or equal to \(duration), clearing cache and creating new expiration object")
                self.clearCache(cache)
                cache.setObject(NSDate(), forKey: "expirationObject")
                cache.synchronize()
                return true
            }
            println(components.minute)
            return false;
            
            
            
            
        } else {
            println("Creating new exp cache object")
            cache.setObject(NSDate(), forKey: "expirationObject")
            return false
        }
    }
    
    func clearCache(cache: NSUserDefaults) {
        cache.removeObjectForKey("oauth_token")
        cache.removeObjectForKey("oauth_token_secret")
        cache.removeObjectForKey("expirationObject")
        cache.synchronize()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        println(url)
        if (url.host == "oauth-callback") {
            if (url.path!.hasPrefix("/avans")) {
                println("IROCK")
                OAuth1Swift.handleOpenURL(url)
            }
        } else {
            // Google provider is the only one wuth your.bundle.id url schema.
            OAuth2Swift.handleOpenURL(url)
        }
        return true
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
    
    
}

