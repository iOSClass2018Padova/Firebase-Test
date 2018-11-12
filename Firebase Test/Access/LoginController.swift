//
//  LoginController.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    enum TagTextField : Int{
        case email = 0
        case password
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    

    @IBOutlet weak var titleOutlet: UILabel! {
        didSet {
            titleOutlet.text = R.string.localizable.kLoginTitle()
        }
    }
    
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for textField in textFields {
                switch textField.tag {
                case TagTextField.email.rawValue: textField.placeholder = R.string.localizable.kLoginEmail()
                case TagTextField.password.rawValue: textField.placeholder = R.string.localizable.kLoginPassword()
                default:
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var loginOutlet: UIButton! {
        didSet {
            loginOutlet.setTitle(R.string.localizable.kLoginButton(), for: .normal)
        }
    }
    
    @IBOutlet weak var signUpOutlet: UIButton! {
        didSet {
            signUpOutlet.setTitle(R.string.localizable.kLoginGoToSignup(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationCapturesStatusBarAppearance = true
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        var email : String = ""
        var password : String = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagTextField.email.rawValue:
                email = textField.text ?? ""
            case TagTextField.password.rawValue:
                password = textField.text ?? ""
            default:
                break
            }
        }
        
        guard !email.isEmpty && !password.isEmpty  else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedEmptyLabelsTitle(), message: R.string.localizable.kAlertLoginFailedEmptyLabelsMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard email.isValidEmail() else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedInvalidEmailTitle(), message: R.string.localizable.kAlertLoginFailedInvalidEmailMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), message: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        NetworkManager.login(email: email, password: password) { (success) in
            if success {
                self.performSegue(withIdentifier: R.segue.loginController.segueToMain, sender: self)
            }
        }
    }
    
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
