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
        
        // push notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeStatusFromPushNotification),
            name: Notification.Name("status"),
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if payload?["hash"] == nil || payload?["email"] == nil {
            return denyButtonWasPressed(nil)
        }
    }
    
    @objc private func changeStatusFromPushNotification(notification: Notification) {
        guard let data = notification.userInfo as? [String: Any] else { return }
        guard let status = data["status"] as? String else { return }
        guard let payload = data["payload"] as? [String: String] else { return }
        
        if status == "approved" {
            self.payload = payload
            self.approveButtonWasPressed(nil)
        } else {
            self.denyButtonWasPressed(self)
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
