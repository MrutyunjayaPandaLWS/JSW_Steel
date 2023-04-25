//
//  LoginViewController.swift
//  CenturyPly_JSON
//
//  Created by Arokia-M3 on 03/03/22.
//

import UIKit

class LoginViewModel: popUpDelegate{
    func popupAlertDidTap(_ vc: PopupAlertOne_VC) {}
    
    
    weak var VC: MSP_LoginVC?
    var requestAPIs = RestAPI_Requests()
    var count = 0
    var timer = Timer()
    var pushID = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    
    func loginAPICall(parameters: JSON, completion: @escaping (LoginModels?) -> ()) {
        DispatchQueue.main.async {
            self.VC?.startLoading()
            self.VC?.loaderView.isHidden = false
            self.VC?.lottieAnimation(animationView: (self.VC?.loaderAnimatedView)!)
        }
        self.requestAPIs.login_API(parameters: parameters) { (result, error) in
            if error == nil {
                if result != nil {
                    DispatchQueue.main.async {
                        completion(result)
                        self.VC?.loaderView.isHidden = true
                        self.VC?.stopLoading()
                    }
                } else {
                    print("No Response")
                    DispatchQueue.main.async {
                        self.VC?.loaderView.isHidden = true
                        self.VC?.stopLoading()
                    }
                }
            }else{
                print("ERROR_Login \(error)")
                DispatchQueue.main.async {
                    self.VC?.loaderView.isHidden = true
                    self.VC?.stopLoading()
                }
                
            }
            
        }
    }
    
    func verifyMobileNumberAPI(paramters: JSON){
        DispatchQueue.main.async {
            self.VC?.startLoading()
            self.VC?.loaderView.isHidden = false
            self.VC?.lottieAnimation(animationView: (self.VC?.loaderAnimatedView)!)
        }
        let url = URL(string: checkUserExistencyURL)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: paramters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(UserDefaults.standard.string(forKey: "TOKEN") ?? "")", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do{
                let str = String(decoding: data, as: UTF8.self) as String?
                 print(str, "- Mobile Number Exists")
                if str ?? "" != "1"{
                    DispatchQueue.main.async{
                        self.VC?.stopLoading()
                        self.VC?.loaderView.isHidden = true
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                        vc!.delegate = self
                        vc!.titleInfo = ""
                        vc!.descriptionInfo = "Invalid membership id / mobile number"
                        vc!.modalPresentationStyle = .overCurrentContext
                        vc!.modalTransitionStyle = .crossDissolve
                        self.VC?.present(vc!, animated: true, completion: nil)
                        self.VC?.mobileNumberTF.text = ""
                    }
                }else{
                    DispatchQueue.main.async{
                        self.VC?.loaderView.isHidden = true
                        self.VC?.stopLoading()
                        
                        self.VC?.mobileNumberTF.isEnabled = false
                        self.VC?.submitLbl.text = "Submit"
                        self.VC?.otpTimerLbl.isHidden = false
                        self.VC?.otpView.isHidden = false
                        self.VC?.mobileNumberTF.isEnabled = false
                        self.VC?.loginButtonTopSpaceConstraint.constant = 160
                        let parameter = [
                            "OTPType": "Enrollment",
                            "UserId": -1,
                            "MobileNo": self.VC?.mobileNumberTF.text ?? "",
                            "UserName": "",
                            "MerchantUserName": "EuroBondMerchantDemo"
                        ] as [String: Any]
                        self.getOTPApi(parameter: parameter)
                       
                    }
                }
                 }catch{
                     DispatchQueue.main.async{
                         self.VC?.loaderView.isHidden = true
                         self.VC?.stopLoading()
                         print("parsing Error")
                     }
            }
        })
        task.resume()
    }
    func getOTPApi(parameter: JSON){
        DispatchQueue.main.async {
            self.count = 60
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            self.VC?.startLoading()
        }
        
        self.requestAPIs.otp_Post_API(parameters: parameter) { (result, error) in
            
            if result == nil{
                DispatchQueue.main.async {
                    self.VC?.stopLoading()
                }
            }else{
                if error == nil{
                    DispatchQueue.main.async {
                        self.VC?.stopLoading()
//                        self.VC?.receivedOTP = result?.returnMessage ?? ""
                        self.VC?.receivedOTP = "123456"
                        print(result?.returnMessage ?? "", "-OTP")
                        
                      //  self.VC?.receivedOTP = "123456"
                       
                    }
                }else{
                    DispatchQueue.main.async {
                        print(error)
                        self.VC?.stopLoading()
                    }
                }
            }
        }
    }
    
    @objc func update() {
        if(count > 1) {
            count = count - 1
            self.VC?.otpTimerLbl.text = "Seconds Remaining : 0:\(count - 1)"
            self.VC?.resendButtonView.isHidden = true
            self.VC?.mobileNumberTF.isEnabled = false
        }else{
            self.VC?.resendButtonView.isHidden = false
            self.VC?.mobileNumberTF.isEnabled = true
            self.timer.invalidate()
        }
    }
}
