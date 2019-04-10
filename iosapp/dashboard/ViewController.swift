//
//  ViewController.swift
//  dashboard
//
//  Created by Neo Ighodaro on 06/04/2019.
//  Copyright © 2019 TapSharp. All rights reserved.
//

import UIKit
import Alamofire
import PusherSwift

class ViewController: UIViewController {
    
    var pusher: Pusher!
    
    var payload: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pusher = Pusher(
            key: AppConstants.PUSHER_KEY,
            options: PusherClientOptions(host: .cluster(AppConstants.PUSHER_CLUSTER))
        )
        pusher.connect()
        
        let channel = pusher.subscribe("auth-request")

        let _ = channel.bind(eventName: "key-dispatched", callback: { [unowned self] (data: Any?) -> Void in
            guard let payload = data as? [String: String], payload["hash"] != nil, payload["email"] != nil else {
                return
            }
            
            self.showApprovalWindow(with: payload)
        })
        
        // push notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeStatusFromPushNotification),
            name: Notification.Name("status"),
            object: nil
        )
    }
    
    private func showApprovalWindow(with payload: [String: String]) {
        self.payload = payload
        
        performSegue(withIdentifier: "approval_window", sender: self)
    }
    
    @objc private func changeStatusFromPushNotification(notification: Notification) {
        guard let data = notification.userInfo as? [String: Any] else { return }
        guard let status = data["status"] as? String else { return }
        guard let payload = data["payload"] as? [String: String] else { return }
        
        if status == "approved" {
            let url = AppConstants.API_URL + "/login/client-authorized"
            
            Alamofire.request(url, method: .post, parameters: payload)
                .validate()
                .responseJSON { response in self.dismiss(animated: true) }
        }
    }

     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ApprovalViewController {
            vc.payload = self.payload
        }
     }
}

