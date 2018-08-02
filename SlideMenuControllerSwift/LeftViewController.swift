//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case rentRevenue = 0
    case commission
    case squareMeter
    case interest
    case subscriptionPlus
    case deposit
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    var menus = ["임대수익률", "중개 수수료(복비계산)", "평형 계산", "대출 이자", "청약 가점", "예금 계산기"]
//    var mainViewController: UIViewController!
    var RentRevenueController: UIViewController!
    var CommissionFeeController: UIViewController!
    var SquareMeterController: UIViewController!
    var InterestController: UIViewController!
    var nonMenuViewController: UIViewController!
    var SubscriptionPlusController: UIViewController!
    var DepositController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CommissionFeeController = storyboard.instantiateViewController(withIdentifier: "CommissionFeeController") as! CommissionFeeController
        self.CommissionFeeController = UINavigationController(rootViewController: CommissionFeeController)
        let SquareMeterController = storyboard.instantiateViewController(withIdentifier: "SquareMeterController") as! SquareMeterController
        self.SquareMeterController = UINavigationController(rootViewController: SquareMeterController)
//
        let interestController = storyboard.instantiateViewController(withIdentifier: "InterestController") as! InterestController
        self.InterestController = UINavigationController(rootViewController: interestController)
        
        let SubscriptionPlusController = storyboard.instantiateViewController(withIdentifier: "SubscriptionPlusController") as! SubscriptionPlusController
        self.SubscriptionPlusController = UINavigationController(rootViewController: SubscriptionPlusController)
        
        let DepositController = storyboard.instantiateViewController(withIdentifier: "DepositController") as! DepositController
        self.DepositController = UINavigationController(rootViewController: DepositController)
//
//        let nonMenuController = storyboard.instantiateViewController(withIdentifier: "NonMenuController") as! NonMenuController
//        nonMenuController.delegate = self
//        self.nonMenuViewController = UINavigationController(rootViewController: nonMenuController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .rentRevenue:
            self.slideMenuController()?.changeMainViewController(self.RentRevenueController, close: true)
        case .commission:
            self.slideMenuController()?.changeMainViewController(self.CommissionFeeController, close: true)
        case .squareMeter:
            self.slideMenuController()?.changeMainViewController(self.SquareMeterController, close: true)
        case .interest:
            self.slideMenuController()?.changeMainViewController(self.InterestController, close: true)
        case .subscriptionPlus:
            self.slideMenuController()?.changeMainViewController(self.SubscriptionPlusController, close: true)
        case .deposit:
            self.slideMenuController()?.changeMainViewController(self.DepositController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .rentRevenue, .commission, .squareMeter, .interest, .subscriptionPlus, .deposit:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .rentRevenue, .commission, .squareMeter, .interest, .subscriptionPlus, .deposit:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
