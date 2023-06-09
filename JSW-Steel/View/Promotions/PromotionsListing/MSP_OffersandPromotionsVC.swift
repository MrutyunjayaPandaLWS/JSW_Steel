//
//  MSP_OffersandPromotionsVC.swift
//  MSP_Customer
//
//  Created by ADMIN on 24/11/2022.
//

import UIKit
import SDWebImage
//import Firebase
import Lottie
class MSP_OffersandPromotionsVC: BaseViewController, PromotionDelegate{
    func moveToNext(_ cell: MSP_OfferandPromotionTVC) {
        guard let tappedIndexPath = self.offersandPromotionTableView.indexPath(for: cell) else{return}
        if cell.viewBtn.tag == tappedIndexPath.row{
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MSP_OffersandPromotionsDetailsVC") as! MSP_OffersandPromotionsDetailsVC
            vc.productName = self.VM.offersandPromotionsArray[tappedIndexPath.row].promotionName ?? ""
            let receivedImg = (self.VM.offersandPromotionsArray[tappedIndexPath.row].proImage ?? "").dropFirst(3)
            let totalImgURLs = PROMO_IMG1 + receivedImg
          
            vc.productImg = totalImgURLs
            vc.shortDesc = self.VM.offersandPromotionsArray[tappedIndexPath.row].proShortDesc ?? ""
            vc.longDesc = self.VM.offersandPromotionsArray[tappedIndexPath.row].proLongDesc ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    

    @IBOutlet weak var noticationLbl: UILabel!
    @IBOutlet weak var offersandPromotionTableView: UITableView!
    @IBOutlet weak var noDataFound: UILabel!
    
    @IBOutlet weak var loaderAnimatedView: LottieAnimationView!
    @IBOutlet weak var loaderView: UIView!
    
    
    var VM = OffersListViewModel()
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? ""
    var pointBalance = UserDefaults.standard.integer(forKey: "RedeemablePointBalance")
    var fromSideMenu = ""
    var VM1 = HistoryNotificationsViewModel()
    let loyaltyId = UserDefaults.standard.string(forKey: "LoyaltyID") ?? ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.VM.VC = self
        self.loaderView.isHidden = true
        self.offersandPromotionTableView.register(UINib(nibName: "MSP_OfferandPromotionTVC", bundle: nil), forCellReuseIdentifier: "MSP_OfferandPromotionTVC")
        self.offersandPromotionTableView.delegate = self
        self.offersandPromotionTableView.dataSource = self
        self.offersandPromotionTableView.separatorStyle = .none
        
        self.loaderView.isHidden = false
        self.lottieAnimation(animationView: self.loaderAnimatedView)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.9, execute: {
            self.offersandPromotionsApi()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loaderView.isHidden = true
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "Offers & Promotion")
//
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func notificaitonBtn(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MSP_NotificationVC") as! MSP_NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func backBtn(_ sender: Any) {
        if self.fromSideMenu == "SideMenu"{
            NotificationCenter.default.post(name: .sideMenuClosing, object: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //Api:-
    func offersandPromotionsApi(){
        DispatchQueue.main.async {
            self.startLoading()
        }
        let parameters = [
            "ActionType": "99",
            "ActorId": "\(self.userID)"
        ] as [String: Any]
        print(parameters)
        self.VM.offersandPromotions(parameters: parameters) { response in
            self.VM.offersandPromotionsArray = response?.lstPromotionJsonList ?? []
            DispatchQueue.main.async {
                if self.VM.offersandPromotionsArray.count != 0 {
                    self.offersandPromotionTableView.isHidden = false
                    self.noDataFound.isHidden = true
                    self.noDataFound.textColor = .white
                    self.offersandPromotionTableView.reloadData()
                }else{
                    self.noDataFound.isHidden = false
                    self.offersandPromotionTableView.isHidden = true
                    self.noDataFound.textColor = .white
                   // self.lottieAnimation(animationView: self.loaderAnimatedView)
                }
                self.loaderView.isHidden = true
                self.stopLoading()
            }
        }
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
                self.noticationLbl.text = "\(self.VM1.notificationListArray.count)"
            }else{
                self.noticationLbl.isHidden = true
            }
            if self.VM1.notificationListArray.count != 0 {
                DispatchQueue.main.async {
//                    self.notificationListTableView.isHidden = false
//                    self.noDataFoundLbl.isHidden = true
//                    self.notificationListTableView.reloadData()
                }
            }else{
//                self.noDataFoundLbl.isHidden = false
//                self.notificationListTableView.isHidden = true
                
            }
        }
        
    }
    
}
extension MSP_OffersandPromotionsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.offersandPromotionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSP_OfferandPromotionTVC") as? MSP_OfferandPromotionTVC
        cell?.delegate = self
        cell?.titleLbl.text = VM.offersandPromotionsArray[indexPath.row].promotionName ?? ""
        let receivedImage = (self.VM.offersandPromotionsArray[indexPath.row].proImage ?? "").dropFirst(3)
        let totalImgURL = PROMO_IMG1 + receivedImage
        cell?.productImage.sd_setImage(with: URL(string: totalImgURL), placeholderImage: UIImage(named: "App-Design-96x96"))
        cell?.viewBtn.tag = indexPath.row
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
}
