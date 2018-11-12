//
//  ViewController.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.getUser(completion: { (success) in
            
        })
        
    }

    @IBAction func logoutAction(_ sender: Any) {
        
        NetworkManager.logout { (success) in
            if success {
                GeneralUtils.share.reloadGenericViewController(storyboard: R.storyboard.login(), inViewController: self)
            }
        }
        
    }
    
}

