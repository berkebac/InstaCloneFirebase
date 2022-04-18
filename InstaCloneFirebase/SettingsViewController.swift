//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Berke Baç on 13.04.2022.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {
            print("error")
        }
        
        
    }

}
