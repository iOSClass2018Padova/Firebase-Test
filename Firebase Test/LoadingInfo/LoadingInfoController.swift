//
//  LoadingInfoController.swift
//  Cinema
//
//  Created by stefano vecchiati on 23/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class LoadingInfoController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        NetworkManager.checkLoggeduser { (success) in
            if success {
                self.performSegue(withIdentifier: R.segue.loadingInfoController.segueToMain, sender: self)
            } else {
                self.performSegue(withIdentifier: R.segue.loadingInfoController.segueToLogin, sender: self)
            }
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
