//
//  SignUpController.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    enum TagTextField : Int{
        case email = 0
        case password
        case rePassword
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var titleLable: UILabel! {
        didSet {
            titleLable.text = R.string.localizable.kSignupTitle()
        }
    }
    
    @IBOutlet var textFields: [UITextField]! {
        didSet {
            for textField in textFields {
                switch textField.tag {
                case TagTextField.email.rawValue: textField.placeholder = R.string.localizable.kLoginEmail()
                case TagTextField.password.rawValue: textField.placeholder = R.string.localizable.kLoginPassword()
                case TagTextField.rePassword.rawValue: textField.placeholder = R.string.localizable.kSignupRepeatPassword()
                default:
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var signUpOutlet: UIButton!  {
        didSet {
            signUpOutlet.setTitle(R.string.localizable.kSignupButton(), for: .normal)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        var email : String = ""
        var password : String = ""
        var rePassword : String = ""
        
        for textField in textFields {
            switch textField.tag {
            case TagTextField.email.rawValue:
                email = textField.text ?? ""
            case TagTextField.password.rawValue:
                password = textField.text ?? ""
            case TagTextField.rePassword.rawValue:
                rePassword = textField.text ?? ""
            default:
                break
            }
        }
        
        guard !email.isEmpty && !password.isEmpty && !rePassword.isEmpty else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedEmptyLabelsTitle(), message: R.string.localizable.kAlertLoginFailedEmptyLabelsMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard email.isValidEmail() else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedInvalidEmailTitle(), message: R.string.localizable.kAlertLoginFailedInvalidEmailMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard password == rePassword else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedDifferentPasswordsTitle(), message: R.string.localizable.kAlertLoginFailedDifferentPasswordsMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }
        
        guard password.count > 5 else {
            self.present(GeneralUtils.share.alertError(title: R.string.localizable.kAlertLoginFailedInvalidPasswordTitle(), message: R.string.localizable.kAlertLoginFailedInvalidPasswordMessage(), closeAction: {}), animated: true, completion: nil)
            return
        }

        NetworkManager.signup(email: email, password: password) { (success) in
            if success {
                NetworkManager.uploadUserInfo(email: email, completion: { (success) in
                    if success {
                        self.performSegue(withIdentifier: R.segue.loginController.segueToMain.identifier, sender: self)
                    }
                })
                
            }
        }
    }
    
    
    @IBOutlet weak var goToLogin: UIButton!  {
        didSet {
            goToLogin.setTitle(R.string.localizable.kSignupGoToLogin(), for: .normal)
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
