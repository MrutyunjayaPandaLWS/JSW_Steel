//
//  MSP_LoginVC.swift
//  MSP_Customer
//
//  Created by Arokia-M3 on 28/11/22.
//

import UIKit
//import Firebase
import Lottie
import DPOTPView

class MSP_LoginVC: BaseViewController, popUpDelegate, CheckBoxSelectDelegate,UITextFieldDelegate,DPOTPViewDelegate{
    func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
        self.enteredValue = "\(text)"
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
        self.enteredValue = "\(text)"
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
   
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var resendButtonView: UIView!
    @IBOutlet weak var otpTimerLbl: UILabel!
    @IBOutlet weak var enterLbl: UILabel!
    @IBOutlet weak var loaderAnimatedView: LottieAnimationView!
    @IBOutlet weak var otpView: DPOTPView!
    @IBOutlet weak var loginButtonTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var loaderView: UIView!
//    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet var mobileNumberTF: UITextField!
//    @IBOutlet var eyeButton: UIButton!
    @IBOutlet var checkMarkButton: UIButton!
   
    @IBOutlet weak var submitLbl: UILabel!
    var VM = LoginViewModel()
    var boolResult:Bool = false
    var pushID = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
    let loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyID") ?? ""
    var itsFrom = ""
    var timmer = Timer()
    var enteredValue = ""
    var receivedOTP = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.enterLbl.isHidden = true
        self.otpTimerLbl.isHidden = true
        self.resendButtonView.isHidden = true
        self.otpView.isHidden = true
        self.loginButtonTopSpaceConstraint.constant = 60
        self.submitLbl.text = "Request OTP"
        otpView.dpOTPViewDelegate = self
        otpView.fontTextField = UIFont.systemFont(ofSize: 25)
        otpView.textEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        otpView.editingTextEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        
        
        self.mobileNumberTF.delegate = self
        loginView.layer.cornerRadius = 16
        loginView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.loginView.clipsToBounds = true
        self.checkMarkButton.setImage(UIImage(named: "Rectangle 18"), for: .normal)
        self.boolResult = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.isHidden = true
//        playAnimation()
        tokendata()
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "Login")
//        
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
        
    }
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        
        //Resend OTP
        self.VM.timer.invalidate()
        let parameter = [
            "OTPType": "Enrollment",
            "UserId": -1,
            "MobileNo": self.mobileNumberTF.text ?? "",
            "UserName": "",
            "MerchantUserName": "JSWCDemo"
        ] as [String: Any]
        self.VM.getOTPApi(parameter: parameter)
        
        
        //self.passwordTF.text = ""
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MSP_ForgotPasswordVC") as! MSP_ForgotPasswordVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
//    @IBAction func passwordSecureButton(_ sender: Any) {
//        if passwordTF.isSecureTextEntry {
//            passwordTF.isSecureTextEntry = false
//            self.eyeButton.setImage(UIImage(named: "view"), for: .normal)
//
//        } else {
//            passwordTF.isSecureTextEntry = true
//            self.eyeButton.setImage(UIImage(named: "hidden"), for: .normal)
//        }
//
//    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsAndConditionBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HR_TermsandCondtionVC") as! HR_TermsandCondtionVC
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    @IBAction func membershipIDDidEnd(_ sender: Any) {

    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        if submitLbl.text != "Submit"{
            requestOTPBtnTapped()
        }else{
            LoginSubmitBtnTapped()
        }
    }

    
    func decline(_ vc: HR_TermsandCondtionVC) {
        self.checkMarkButton.setImage(UIImage(named: "Rectangle 18"), for: .normal)
        self.boolResult = false
    }
    func accept(_ vc: HR_TermsandCondtionVC) {
        print(vc.boolResult)
        if vc.boolResult == true{
            self.boolResult = true
            self.checkMarkButton.setImage(UIImage(named: "black-check-box-with-white-check"), for: .normal)
            return
        }else{
            self.checkMarkButton.setImage(UIImage(named: "Rectangle 18"), for: .normal)
            self.boolResult = false
            return
        }
    }
    func popupAlertDidTap(_ vc: PopupAlertOne_VC) {}

    
    func tokendata(){
            if MyCommonFunctionalUtilities.isInternetCallTheApi() == false{
            }else{
                let parameters : Data = "username=\(username)&password=\(password)&grant_type=password".data(using: .utf8)!

            let url = URL(string: tokenURL)!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            do {
                request.httpBody = parameters
            } catch let error {
                print(error.localizedDescription)
            }
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
           
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

                guard error == nil else {
                    return
                }
                guard let data = data else {
                    return
                }
                do{
                    let parseddata = try JSONDecoder().decode(TokenModels.self, from: data)
                        print(parseddata.access_token ?? "")
                        UserDefaults.standard.setValue(parseddata.access_token ?? "", forKey: "TOKEN")
                     }catch let parsingError {
                    print("Error", parsingError)
                }
            })
            task.resume()
        }
        }
    
    //API:-
    
    func callAPI() {
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.9, execute: {
//            self.startLoading()
////            self.loaderView.isHidden = false
////            self.lottieAnimation(animationView: self.loaderAnimatedView)
//            })
        

        let parameters = [
            "Password": "123456",
            "UserName": "\(mobileNumberTF.text ?? "")",
            "UserActionType": "GetPasswordDetails",
            "Browser": "iOS",
            "LoggedDeviceName": "iOS",
            "PushID": "\(pushID)",
            "UserType": "Customer"
        ]
        print(parameters)
        self.VM.loginAPICall(parameters: parameters) { response in
            print(response?.userList?[0].result!,"result")
            //    49    Dealer
            //    50    Sales Promoter
            //    51    Retailer
            //    52    Contractor
            //    53    Undefined
            
            if response?.userList?[0].isDelete == 1{
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account is verification pending! Kindly contact your administrator."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
            }else if response?.userList?[0].isUserActive ?? 0 == 1 && response?.userList?[0].verifiedStatus == 0{
                
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account is not activated! Kindly activate your account."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
            }else if response?.userList?[0].isUserActive ?? 0 == 0 && response?.userList?[0].verifiedStatus == 0{
                
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account is not activated! Kindly activate your account."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
            }else if response?.userList?[0].isUserActive ?? 0 == 0 && response?.userList?[0].verifiedStatus == 1{
                
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account has been deactivated! Kindly contact your administrator.ss"
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
                
            }else if response?.userList?[0].isUserActive ?? 0 == 0 && response?.userList?[0].verifiedStatus == 4{
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account is in Pending, Kindly contact your administrator."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
            }else if response?.userList?[0].isUserActive ?? 0 == 0 && response?.userList?[0].verifiedStatus == 3 || response?.userList?[0].isUserActive ?? 0 == 1 && response?.userList?[0].verifiedStatus == 3{
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account is in Pending, Kindly contact your administrator."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
            }else if response?.userList?[0].isUserActive ?? 0 == 0 || response?.userList?[0].isUserActive ?? 0 == 1 && response?.userList?[0].verifiedStatus ?? 0 == 3{
                
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account has been deactivated! Kindly contact your administrator."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
                
            }else if response?.userList?[0].verifiedStatus ?? 0 == 2{
                
                DispatchQueue.main.async{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                    vc!.delegate = self
                    vc!.titleInfo = ""
                    vc!.descriptionInfo = "Your account verification is failed!, Kindly contact your administrator."
                    vc!.modalPresentationStyle = .overCurrentContext
                    vc!.modalTransitionStyle = .crossDissolve
                    self.present(vc!, animated: true, completion: nil)
                    self.loaderView.isHidden = true
                    self.stopLoading()
                }
                
            }
//            else if response?.userList?[0].customerTypeID ?? 0 == 0 || response?.userList?[0].customerTypeID ?? 0 <= 49 || response?.userList?[0].customerTypeID ?? 0 == 53 {
//                print(response?.userList?[0].customerTypeID ?? 0,"iijij")
//                DispatchQueue.main.async{
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
//                    vc!.delegate = self
//                    vc!.titleInfo = ""
//                    vc!.descriptionInfo = "Invalid Customer type."
//                    vc!.modalPresentationStyle = .overCurrentContext
//                    vc!.modalTransitionStyle = .crossDissolve
//                    self.present(vc!, animated: true, completion: nil)
//                    self.loaderView.isHidden = true
//                    self.stopLoading()
//                }
//            }
            else {
                
                if response?.userList?[0].isUserActive ?? 0 == 1 && response?.userList?[0].verifiedStatus == 1  || response?.userList?[0].isUserActive ?? 0 == 1 && response?.userList?[0].verifiedStatus == 4{
                    UserDefaults.standard.setValue(response?.userList?[0].userId ?? -1, forKey: "UserID")
                    self.loaderView.isHidden = true
                    self.stopLoading()
                    let parameter = [
                        "OTPType": "Enrollment",
                        "UserId": -1,
                        "MobileNo": self.mobileNumberTF.text ?? "",
                        "UserName": "",
                        "MerchantUserName": "EuroBondMerchantDemo"
                    ] as [String: Any]
                    self.VM.getOTPApi(parameter: parameter)
                    
                }else{
                    DispatchQueue.main.async{
                        self.mobileNumberTF.text = ""
                        //self.passwordTF.text = ""
                        self.checkMarkButton.setImage(UIImage(named: "Rectangle 18"), for: .normal)
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                        vc!.delegate = self
                        vc!.titleInfo = ""
                        vc!.descriptionInfo = "Something went wrong please try again later!"
                        vc!.modalPresentationStyle = .overCurrentContext
                        vc!.modalTransitionStyle = .crossDissolve
                        self.present(vc!, animated: true, completion: nil)
                        self.loaderView.isHidden = true
                        self.stopLoading()
                    }
                  
                }
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (self.mobileNumberTF.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//        let compSepByCharInSet = string.components(separatedBy: aSet)
//        let numberFiltered = compSepByCharInSet.joined(separator: "")
//        
//        if string == numberFiltered {
//            let currentText = self.mobileNumberTF.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//            return updatedText.count <= 10
//        } else {
//            return false
//        }
//    }
    
}

extension MSP_LoginVC{
    func requestOTPBtnTapped(){
        if mobileNumberTF.text?.count == 0 {
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Please enter the membership id / mobile number"
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        }else if self.boolResult == false {
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Please accept terms and conditons"
                
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        }else{
            let parameterJSON = [
                    "ActionType":"57",
                    "Location":[
                        "UserName":"\(self.mobileNumberTF.text ?? "")"
                    ]
            ] as [String:Any]
            print(parameterJSON)
            self.VM.verifyMobileNumberAPI(paramters: parameterJSON)
            
        }

    }
    
    func LoginSubmitBtnTapped(){
        if mobileNumberTF.text?.count == 0 {
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Please enter the membership id / mobile number"
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        }else if self.boolResult == false {
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Please accept terms and conditons"
                
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        }else if self.enteredValue == ""{
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Enter OTP"
                
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        }else if self.enteredValue != self.receivedOTP{
            DispatchQueue.main.async{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PopupAlertOne_VC") as? PopupAlertOne_VC
                vc!.delegate = self
                vc!.titleInfo = ""
                vc!.descriptionInfo = "Enter correct OTP"
                
                vc!.modalPresentationStyle = .overCurrentContext
                vc!.modalTransitionStyle = .crossDissolve
                self.present(vc!, animated: true, completion: nil)
            }
        } else {
            //tokendata()
//            callAPI()
            UserDefaults.standard.setValue(true, forKey: "IsloggedIn?")
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    let sceneDelegate = self.view.window!.windowScene!.delegate as! SceneDelegate
                    sceneDelegate.setHomeAsRootViewController()
                } else {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.setHomeAsRootViewController()
                }
               
            }
        }

    }
}
