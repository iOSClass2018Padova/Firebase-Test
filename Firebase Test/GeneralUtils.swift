//
//  GeneralUtils.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class GeneralUtils: NSObject {
    
    static let share = GeneralUtils()
    
    func alertError(title: String?, message: String?, closeAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: R.string.localizable.kAlertOkButton(), style: .default, handler: { action in
            closeAction()
        })
        alert.addAction(ok)
        return alert
    }
    
    func reloadGenericViewController(storyboard : UIStoryboard, inViewController viewController : UIViewController) {
        guard let setViewController = storyboard.instantiateInitialViewController() else { return }
        viewController.present(setViewController, animated: true, completion: nil)
    }
    

}
