//
//  FirstViewController.swift
//  ravelry
//
//  Created by Kellan Cummings on 12/11/14.
//  Copyright (c) 2014 Kellan Cummings. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

    override func viewDidAppear(animated: Bool) {
        /*
        var requestHeaders: [String:String] = [
            "oauth_consumer_key": "xvz1evFS4wEEPTGEFPHBog",
            "oauth_nonce": "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": "1318622958",
            "oauth_version": "1.0",
            "status": "Hello Ladies + Gentlemen, a signed OAuth request!",
            "include_entities": "true",
            "oauth_token": "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb"
        ]
        
        var signingKey = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

        requestHeaders["oauth_signature"] = OAuthService.buildSignature(requestHeaders,
            method: "POST",
            url: "https://api.twitter.com/1/statuses/update.json",
            signingKey: signingKey
        )
        */
                
        if let user = cdm!.first("User") {
            authenticateUser(user as User)
        } else {
            let alert = DialogueController(
                title: "Authenticate Account",
                message: "Allow Us to Access Your Ravelry Account."
            )
            
            alert.styleTitle(headlineFont[0]!)
            alert.styleMessage(basalFont!)
            
            alert.addAction("Go",
                handler: { (action:UIAlertAction!) -> Void in
                    var name = alert.getTextFieldAtIndex(0)
                    var pw = alert.getTextFieldAtIndex(1)

                    if let user = User.create([
                        "name": name,
                        "password": pw
                    ]) {
                        self.authenticateUser(user)
                    }
                    
                }
            )
    
            alert.addTextField(placeholder: "Username")
            alert.addPasswordField(placeholder: "Password")
            alert.present(context: self)
            
        }
    }
    
    func authenticateUser(user: User) {
        var service = RavelryOAuthService(
            consumerKey: API["consumer_key"]!,
            consumerSecret: API["consumer_secret"]!
        )
        
        service.authenticate()
    }

    override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

