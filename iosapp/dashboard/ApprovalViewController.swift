//
//  ApprovalViewController.swift
//  dashboard
//
//  Created by Neo Ighodaro on 06/04/2019.
//  Copyright © 2019 TapSharp. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire

class ApprovalViewController: UIViewController {
    
    var payload: [String: String]?
    
    private var channel: PusherChannel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if payload?["hash"] == nil || payload?["email"] == nil {
            return denyButtonWasPressed(nil)
        }
    }
    
    @IBAction func approveButtonWasPressed(_ sender: Any?) {
        let url = AppConstants.API_URL + "/login/client-authorized"

        Alamofire.request(url, method: .post, parameters: payload)
            .validate()
            .responseJSON { response in
                self.dismiss(animated: true)
            }
    }
    
    @IBAction func denyButtonWasPressed(_ sender: Any?) {
        dismiss(animated: true)
    }
}
