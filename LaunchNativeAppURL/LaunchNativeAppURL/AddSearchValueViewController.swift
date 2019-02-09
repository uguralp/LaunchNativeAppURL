//
//  AddSearchValueViewController.swift
//  LaunchNativeAppURL
//
//  Created by Uğuralp ÖNBAŞLI on 30.12.2018.
//  Copyright © 2018 Uğuralp ÖNBAŞLI. All rights reserved.
//

import UIKit

class AddSearchValueViewController: UIViewController {

    @IBOutlet weak var searchTypeValue: UILabel!
    var value:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchTypeValue.text = value
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
