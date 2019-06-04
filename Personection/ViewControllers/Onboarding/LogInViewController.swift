//
//  ViewController.swift
//  Personection
//
//  Created by Quintin Leary on 11/25/18.
//  Copyright © 2018 Quintin Leary. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate  {

    //Mark: IBOutlet Connections
    @IBOutlet weak var personectionLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    //Mark: State Changes
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpUI()
        
        //assign delegates
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide the nav bar on the LogInViewController
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //Mark: Button Actions
    @IBAction func logInPushed(_ sender: Any) {
        //Check to see if both input fields are filled
        if(emailTextField.hasText && passwordTextField.hasText) {
            guard let email = emailTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    print("ERROR: Failed top sign in user.")
                    print(error)
                } else {
                    //Force CurrentUser to update.
                    if(CurrentUser.constructed) {
                        CurrentUser.currentUser.updateUser()
                    }
                    print("User: " + CurrentUser.currentUser.getFirstName())
                    self.performSegue(withIdentifier: "logIn", sender: self)
                }
            })
            
        } else {
            let alertController = UIAlertController(title: "Input Fields Aren't Filled", message: "You left one or both input fields empty. Please put both your email and password.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func signUpPushed(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //Other functions
    func setUpUI() {
        //Round all the edges
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        logInButton.layer.cornerRadius = 5
        
        //Change the fonts
        personectionLabel.font = UIFont(name: "Noteworthy-Light", size: 60)
        
        //Change the keyboard return button types
        emailTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.returnKeyType = UIReturnKeyType.done
    }
    
}

