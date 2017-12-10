// commission fee
//

import UIKit
import GoogleMobileAds

weak var dealPriceResult: UILabel!

class CommissionFeeController: UIViewController, UITextFieldDelegate {
    private var selectStatus: CommissionSelecteStatus = CommissionSelecteStatus.Deal;
    
    private var dealPrice: Double = 0;
    private var depositPrice: Double = 0;
    private var commissionMothlyPrice: Double = 0;
    
    @IBOutlet weak var commissionMonthlyPriceTextField: UITextField!
    @IBOutlet weak var depositPriceTextField: UITextField!
    @IBOutlet weak var dealPriceTextField: UITextField!
    
    @IBOutlet weak var commissionMonthlyPriceTitle: UILabel!
    @IBOutlet weak var dealPriceTitle: UILabel!
    @IBOutlet weak var depositPriceTitle: UILabel!
    
    @IBOutlet weak var dealPriceResult: UILabel!
    @IBOutlet weak var upperLimitRateResult: UILabel!
    @IBOutlet weak var upperLimitPriceResult: UILabel!
    @IBOutlet weak var maxCommissionPriceResult: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let formatterToCurrency = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        dealPriceTextField.addTarget(self, action: #selector(dealPriceTextFieldDidChange), for: .editingChanged)
        depositPriceTextField.addTarget(self, action: #selector(depositPriceTextFieldDidChange), for: .editingChanged)
        commissionMonthlyPriceTextField.addTarget(self, action: #selector(commissionMonthlyPriceTextFieldDidChange), for: .editingChanged)
    }
    
    func dealPriceTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = dealPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    func depositPriceTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = depositPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    func commissionMonthlyPriceTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = commissionMonthlyPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        dealPriceTextField.delegate = self
        dealPriceTextField.keyboardType = UIKeyboardType.numberPad
        
        depositPriceTextField.delegate = self
        depositPriceTextField.keyboardType = UIKeyboardType.numberPad
        
        commissionMonthlyPriceTextField.delegate = self
        commissionMonthlyPriceTextField.keyboardType = UIKeyboardType.numberPad
    }
    
    // MARK: UITextFieldDelegate events and related methods
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String)
        -> Bool
    {
        if string.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch textField {
            case dealPriceTextField,
                 depositPriceTextField,
                 commissionMonthlyPriceTextField:
                    print(currentText)
                    return prospectiveText.characters.count <= 14
            default:
                return true
        }
        
    }

    // 계산 버튼
    @IBAction func calculateBtn(_ sender: UIButton) {
        print("click button", selectStatus);
        switch selectStatus {
        case CommissionSelecteStatus.Deal:
            calAboutDeal()
        case CommissionSelecteStatus.Lease:
            calAboutLease()
        case CommissionSelecteStatus.Month:
            calAboutMonth()
        default:
            return;
        }
        
    }
    
    // 매매 / 교환
    func calAboutDeal() -> Void {
        print("calAboutDeal")
        
        if let text = dealPriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            dealPrice = Double(replacedText)!;
        } else {
            dealPrice = 0;
        }
        
        if (dealPrice == 0) {
            self.showToast(message: "거래금액을 입력해주세요.");
        }
        
        if (dealPrice < 50000000) {
            var dealResult = dealPrice * 0.006;
            
            if(dealResult > 250000) {
             dealResult = 2500000;
            }
            
            dealPriceResult.text = dealPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "250,000"
            upperLimitRateResult.text = "0.6"
        } else if (dealPrice >= 50000000 && dealPrice < 200000000) {
            var dealResult = dealPrice * 0.005;
            
            if(dealResult > 800000) {
             dealResult = 800000;
            }
            dealPriceResult.text = dealPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "800,000"
            upperLimitRateResult.text = "0.5"
        } else if (dealPrice >= 200000000 && dealPrice < 600000000) {
            let dealResult = dealPrice * 0.004;
            
            dealPriceResult.text = dealPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.4"
        } else if (dealPrice >= 600000000 && dealPrice < 900000000) {
            let dealResult = dealPrice * 0.005;
            
            dealPriceResult.text = dealPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.5"
        } else {
            let dealResult = dealPrice * 0.009;
            
            dealPriceResult.text = dealPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.9"
        }
        
    }
    
    // 전세 임대차
    func calAboutLease() -> Void {
        print("calAboutLease")
        
        if let text = depositPriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            depositPrice = Double(replacedText)!;
        } else {
            depositPrice = 0;
        }
        
        if (depositPrice == 0) {
            self.showToast(message: "보증금을 입력해주세요.");
        }
        
        if (depositPrice < 50000000) {
            var depositResult = depositPrice * 0.005;
            
            if(depositResult > 200000) {
                depositResult = 2000000;
            }
            
            dealPriceResult.text = depositPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
            upperLimitPriceResult.text = "200,000"
            upperLimitRateResult.text = "0.5"
        } else if (depositPrice >= 50000000 && depositPrice < 100000000) {
            var depositResult = depositPrice * 0.004;
            
            if(depositResult > 300000) {
                depositResult = 300000;
            }
            
            dealPriceResult.text = depositPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
            upperLimitPriceResult.text = "300,000"
            upperLimitRateResult.text = "0.4"
        } else if (depositPrice >= 100000000 && depositPrice < 300000000) {
            let depositResult = depositPrice * 0.003;
            
            dealPriceResult.text = depositPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.3"
        } else if (depositPrice >= 300000000 && depositPrice < 600000000) {
            let depositResult = depositPrice * 0.004;
            
            dealPriceResult.text = depositPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.4"
        } else {
            let depositResult = depositPrice * 0.008;
            
            dealPriceResult.text = depositPriceTextField.text
            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.8"
        }
    }
    
    func calAboutMonth() -> Void {
        
        // deposit
        if let text = depositPriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            depositPrice = Double(replacedText)!;
        } else {
            depositPrice = 0;
        }
        
        // monthly fee
        if let text = commissionMonthlyPriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            commissionMothlyPrice = Double(replacedText)!;
        } else {
            commissionMothlyPrice = 0;
        }
        
        if (depositPrice == 0 || commissionMothlyPrice == 0) {
            self.showToast(message: "보증금과 월세액을 입력해주세요.");
        }
        
        
        var resultDealPrice = depositPrice + (commissionMothlyPrice * 100);
        
        if (resultDealPrice < 50000000) {
            resultDealPrice = depositPrice + (commissionMothlyPrice * 70);
        }
        
        if (resultDealPrice < 50000000) {
            var dealResult = resultDealPrice * 0.005;
            
            if(dealResult > 200000) {
                dealResult = 2000000;
            }
            
            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "200,000"
            upperLimitRateResult.text = "0.5"
        } else if (resultDealPrice >= 50000000 && resultDealPrice < 100000000) {
            var dealResult = resultDealPrice * 0.004;
            
            if(dealResult > 300000) {
                dealResult = 300000;
            }
            
            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "300,000"
            upperLimitRateResult.text = "0.4"
        } else if (resultDealPrice >= 100000000 && resultDealPrice < 300000000) {
            let dealResult = resultDealPrice * 0.003;
            
            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.3"
        } else if (resultDealPrice >= 300000000 && resultDealPrice < 600000000) {
            let dealResult = resultDealPrice * 0.004;
            
            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.4"
        } else {
            let dealResult = resultDealPrice * 0.008;
            
            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
            upperLimitPriceResult.text = "-"
            upperLimitRateResult.text = "0.8"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "중개 수수료"
        self.setNavigationBarItem()
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,                       // All simulators
            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        bannerView.load(request)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
            case 0:
                selectStatus = CommissionSelecteStatus.Deal
                
                dealPriceTextField.isEnabled = true;
                depositPriceTextField.isEnabled = false;
                commissionMonthlyPriceTextField.isEnabled = false;
                
                makeEmptyText(text: depositPriceTextField)
                makeEmptyText(text: commissionMonthlyPriceTextField)
                print("index0")
            case 1:
                selectStatus = CommissionSelecteStatus.Lease
                dealPriceTextField.isEnabled = false;
                depositPriceTextField.isEnabled = true;
                commissionMonthlyPriceTextField.isEnabled = false;
                
                makeEmptyText(text: dealPriceTextField)
                makeEmptyText(text: commissionMonthlyPriceTextField)
                print("index 1 ");
            case 2:
                selectStatus = CommissionSelecteStatus.Month
                dealPriceTextField.isEnabled = false;
                depositPriceTextField.isEnabled = true;
                commissionMonthlyPriceTextField.isEnabled = true;
            
                makeEmptyText(text: dealPriceTextField)
            default:
                break;
        }
    }
    
    func makeEmptyText(text: UITextField) -> Void {
        text.text = ""
    }
}
