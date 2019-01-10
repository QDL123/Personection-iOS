//
//  SignUpViewController.swift
//  Personection
//
//  Created by Quintin Leary on 11/26/18.
//  Copyright © 2018 Quintin Leary. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //Mark: IBOutlet connections
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
        
        //Assign Delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
    }
    
    //Mark: Button Actions
    @IBAction func signUpPushed(_ sender: Any) {
        //Check to make sure that every textField has been filled
        if(firstNameTextField.hasText && lastNameTextField.hasText && emailTextField.hasText && passwordTextField.hasText && confirmPasswordTextField.hasText) {
            //Check to see if password matches confirm password
            guard let password = passwordTextField.text else {
                return
            }
            guard let confirmPassword = confirmPasswordTextField.text else {
                return
            }
            if(password == confirmPassword) {
                //Go ahead and create User.
                guard let email = emailTextField.text else {return}
                guard let firstName = firstNameTextField.text else {return}
                guard let lastName = lastNameTextField.text else {return}
                
                Auth.auth().createUser(withEmail: email, password: password, completion: {(authResult, error) in
                    
                    let db = Firestore.firestore()
                    var ref: DocumentReference? = nil
                    ref = db.collection("users").addDocument(data: [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                    
                    if let error = error {
                        print(error)
                    }
                    self.performSegue(withIdentifier: "signUp", sender: self)
                })
 
            } else {
                let alertController = UIAlertController(title: "Passwords Don't Match", message: "Make sure that that your password matches what's in the confirm password input field.", preferredStyle: .alert)
                alertController.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
                present(alertController, animated: true, completion: nil)            }
        } else {
            let alertController = UIAlertController(title: "Oops", message: "You haven't filled in the input fields. Please fill in the rest of the input fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //Mark: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setUpUI() {
        //Change the naviagiton button colors
        self.navigationController?.navigationBar.tintColor = UIColor.red
        
        //Round Edges
        firstNameTextField.layer.cornerRadius = 5
        lastNameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        confirmPasswordTextField.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 5
        
        //Change Keyboard Button Return Types
        emailTextField.returnKeyType = UIReturnKeyType.done
        firstNameTextField.returnKeyType = UIReturnKeyType.done
        lastNameTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.returnKeyType = UIReturnKeyType.done
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.done
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
