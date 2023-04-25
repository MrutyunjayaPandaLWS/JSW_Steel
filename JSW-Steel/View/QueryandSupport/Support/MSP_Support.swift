//
//  MSP_Support.swift
//  MSP_Customer
//
//  Created by ADMIN on 24/11/2022.
//

import UIKit
import Lottie
//import Firebase

class MSP_Support: BaseViewController {

    @IBOutlet weak var notificationCountLbl: UILabel!
    
    @IBOutlet weak var animationLottieView: LottieAnimationView!
    @IBOutlet weak var loaderAnimatedView: LottieAnimationView!
       @IBOutlet weak var loaderView: UIView!
    

    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? ""
    let loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyID") ?? ""
    var VM1 = HistoryNotificationsViewModel()
    var fromSideMenu = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lottieAnimation(animationView: self.animationLottieView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.isHidden = true
       // self.notificationListApi()
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "HelpLine")
//
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func notificationBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MSP_NotificationVC") as! MSP_NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func giveamissedCallBtn(_ sender: Any) {
        if let phoneCallURL = URL(string: "tel://\(+9103366437002)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if self.fromSideMenu == "SideMenu"{
            NotificationCenter.default.post(name: .sideMenuClosing, object: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func lodgeQueryBtn(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MSP_LodgeQueryVC") as! MSP_LodgeQueryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func notificationListApi(){
        let parameters = [
            "ActionType": 0,
            "ActorId": "\(userID)",
            "LoyaltyId": self.loyaltyId
        ] as [String: Any]
        print(parameters)
        self.VM1.notificationListApi(parameters: parameters) { response in
            self.VM1.notificationListArray = response?.lstPushHistoryJson ?? []
            print(self.VM1.notificationListArray.count)
            if self.VM1.notificationListArray.count > 0{
                self.notificationCountLbl.text = "\(self.VM1.notificationListArray.count)"
            }else{
                self.notificationCountLbl.isHidden = true
            }
        }
    }
}
