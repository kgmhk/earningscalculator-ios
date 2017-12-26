//  Created by gihyun on 07/.
// 임대수익률

import UIKit
import GoogleMobileAds

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = 0
        
        var amountWithPrefix = self
        
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        print("double", double);
        number = NSNumber(value: (double / 1))
        
        print("number ", number);
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        print("formatter.string(from: number)!", formatter.string(from: number)!);
        
        return formatter.string(from: number)!
    }
}

class RentRevenueController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    private static var YearlyRentRevenueContext = 0;
    private static var YearlyInterestPriceContext = 1;
    private static var YearlyPureRevenuePriceContext = 2;
    private static var RealInvestmentPriceContext = 3;
    
    var depositPrice: Double = 0;
    var monthlyPrice: Double = 0;
    var buyTotalPrice: Double = 0;
    var loanPrice: Double = 0;
    var loanRate: Float = 0.0;
    let formatterToCurrency = NumberFormatter()
    let formatterToNumber = NumberFormatter()
    
    
    @IBOutlet var propertyPriceResult: UILabel!
    @IBOutlet var realInvestmentPriceResult: UILabel!
    @IBOutlet var yearlyInterestPriceResult: UILabel!
    @IBOutlet var yearlyRentRevenuePriceResult: UILabel!
    @IBOutlet var yearlyPureRevenuePriceResult: UILabel!
    @IBOutlet var monthlyInterestPriceResult: UILabel!
    @IBOutlet var monthlyPureRevenuePriceResult: UILabel!
    @IBOutlet var rentRevenueRatePriceResult: UILabel!
    
    @IBOutlet weak var monthlyTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var buyTotalPriceTextField: UITextField!
    @IBOutlet weak var loanPriceTextField: UITextField!
    @IBOutlet weak var loanRateTextField: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        self.title = "임대수익률"
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        monthlyTextField.inputAccessoryView = keyboardToolbar
        depositTextField.inputAccessoryView = keyboardToolbar
        buyTotalPriceTextField.inputAccessoryView = keyboardToolbar
        loanPriceTextField.inputAccessoryView = keyboardToolbar
        loanRateTextField.inputAccessoryView = keyboardToolbar
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        formatterToNumber.numberStyle = .decimal
        formatterToNumber.currencySymbol = ""
        formatterToNumber.minimumFractionDigits = 0
        
        yearlyRentRevenuePriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &RentRevenueController.YearlyRentRevenueContext)
        yearlyInterestPriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &RentRevenueController.YearlyInterestPriceContext);
        yearlyPureRevenuePriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &RentRevenueController.YearlyPureRevenuePriceContext)
        realInvestmentPriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &RentRevenueController.RealInvestmentPriceContext)
        
        monthlyTextField.addTarget(self, action: #selector(myMonthlyFieldDidChange), for: .editingChanged)
        depositTextField.addTarget(self, action: #selector(myDepositFieldDidChange), for: .editingChanged)
        buyTotalPriceTextField.addTarget(self, action: #selector(myBuyTotalFieldDidChange), for: .editingChanged)
        loanPriceTextField.addTarget(self, action: #selector(myLoanPriceFieldDidChange), for: .editingChanged)
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        //test
        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID,                       // All simulators
//            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        bannerView.load(request)
    }
    
    func myMonthlyFieldDidChange(_ textField: UITextField) {
        
        if let amountString = monthlyTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func myDepositFieldDidChange(_ textField: UITextField) {
        
        if let amountString = depositTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func myBuyTotalFieldDidChange(_ textField: UITextField) {
        
        if let amountString = buyTotalPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func myLoanPriceFieldDidChange(_ textField: UITextField) {
        
        if let amountString = loanPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        monthlyTextField.delegate = self
        monthlyTextField.keyboardType = UIKeyboardType.numberPad
        
        depositTextField.delegate = self
        depositTextField.keyboardType = UIKeyboardType.numberPad
        
        buyTotalPriceTextField.delegate = self
        buyTotalPriceTextField.keyboardType = UIKeyboardType.numberPad
        
        loanPriceTextField.delegate = self
        loanPriceTextField.keyboardType = UIKeyboardType.numberPad
        
        loanRateTextField.delegate = self
        loanRateTextField.keyboardType = UIKeyboardType.decimalPad
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
            case monthlyTextField,
                 depositTextField,
                 buyTotalPriceTextField,
                 loanPriceTextField:
                print(currentText)
                return prospectiveText.characters.count <= 14
            case loanRateTextField:
                let countdots = (textField.text?.components(separatedBy:".").count)! - 1
                
                if countdots > 0 && string == "."
                {
                    return false
                }
                return prospectiveText.characters.count <= 10
            default:
                return true
        }
        
    }
    
    // 월세
    @IBAction func monthlyTextFieldChanged(_ sender: UITextField) {
        
        print("monthlyPrice");
    
        if let text = sender.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            monthlyPrice = Double(replacedText)!;
        } else {
            monthlyPrice = 0;
        }
        
        let calPropertyPriceResult = depositPrice + (monthlyPrice * 200)
        let convertedcalPropertyPriceResult = calPropertyPriceResult as NSNumber
        let formatedCalPropertyPrice = formatterToCurrency.string(from: convertedcalPropertyPriceResult)!
        
        propertyPriceResult.text = String(formatedCalPropertyPrice)
        
        let yearlyRentRevenueCalResult = monthlyPrice * 12;
        let convertedYearlyRentRevenueCalResult = yearlyRentRevenueCalResult as NSNumber;
        let formatedYearlyRentRevenueResult = formatterToCurrency.string(from: convertedYearlyRentRevenueCalResult);
        
        yearlyRentRevenuePriceResult.text = formatedYearlyRentRevenueResult;
    }
    
    // 임대 보증금
    @IBAction func depositTextFieldChanged(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            depositPrice = Double(replacedText)!;
        } else {
            depositPrice = 0;
        }
        
        let calPropertyPriceResult = depositPrice + (monthlyPrice * 200)
        let convertedcalPropertyPriceResult = calPropertyPriceResult as NSNumber
        let formatedText = formatterToCurrency.string(from: convertedcalPropertyPriceResult)!
        
        let calYearlyInterestPriceResult = buyTotalPrice - depositPrice - loanPrice
        let convertedcalYearlyInterestPriceResult = calYearlyInterestPriceResult as NSNumber
        let formatedCalYearlyInterestPriceText = formatterToCurrency.string(from: convertedcalYearlyInterestPriceResult)!
        
        propertyPriceResult.text = String(formatedText)
        
        realInvestmentPriceResult.text = String(formatedCalYearlyInterestPriceText)
    }
    
    // 분양가
    @IBAction func buyTotalPriceTextFieldChanged(_ sender: UITextField) {
        
        if let text = sender.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            buyTotalPrice = Double(replacedText)!;
        } else {
            buyTotalPrice = 0;
        }
        
        let realInvestment = buyTotalPrice - depositPrice - loanPrice;
        let convertedRealInvestment = realInvestment as NSNumber;
        let formatedText = formatterToCurrency.string(from: convertedRealInvestment);
        
        realInvestmentPriceResult.text = formatedText;
    }

    // 대출금
    @IBAction func loanPriceTextFieldChanged(_ sender: UITextField) {
        print("loanPrice");
        
        if let text = sender.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            loanPrice = Double(replacedText)!;
        } else {
            loanPrice = 0;
        }
        
        let yearlyRevenueCalResult = (Float(loanPrice) * loanRate) / 100;
        let convertedYearlyRevenueCalResult = yearlyRevenueCalResult as NSNumber;
        let formatedYearlyRevenueResult = formatterToCurrency.string(from: convertedYearlyRevenueCalResult);
        
        yearlyInterestPriceResult.text = formatedYearlyRevenueResult; // 연이자
        
        let realInvestment = buyTotalPrice - depositPrice - loanPrice;
        let convertedRealInvestment = realInvestment as NSNumber;
        let formatedRealInventmentResult = formatterToCurrency.string(from: convertedRealInvestment);
        
        realInvestmentPriceResult.text = formatedRealInventmentResult; // 실투자비
    
    }
    
    // 대출금리
    @IBAction func loanRateTextFieldChanged(_ sender: UITextField) {
        print("loanRate");
        
        if let text = sender.text, !text.isEmpty {
            loanRate = Float(text)!;
        } else {
            loanRate = 0.0;
        }
        
        let yearlyRevenueCalResult = (Float(loanPrice) * loanRate) / 100;
        let convertedYearlyRevenueCalResult = yearlyRevenueCalResult as NSNumber;
        let formatedYearlyRevenueResult = formatterToCurrency.string(from: convertedYearlyRevenueCalResult);
        
        yearlyInterestPriceResult.text = formatedYearlyRevenueResult; // 연이자
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &RentRevenueController.YearlyRentRevenueContext {
            let ChangedYearlyRentRevenue = formatterToNumber.number(from: change?[.newKey] as! String);
            let yearlyInterestPrice = yearlyInterestPriceResult.text ?? "0.0";
            let changedYearlyInterestPriceText = formatterToNumber.number(from: yearlyInterestPrice)
            
            let yearlyPureRevenueCalResult = Double(ChangedYearlyRentRevenue!) - Double(changedYearlyInterestPriceText!)
            let convertedYearlyPureRevenue = yearlyPureRevenueCalResult as NSNumber;
            let formatedYearlyPureRevenueResult = formatterToCurrency.string(from: convertedYearlyPureRevenue)
            
            yearlyPureRevenuePriceResult.text = formatedYearlyPureRevenueResult // 연순수익
        } else if context == &RentRevenueController.YearlyInterestPriceContext {
            let yearlyRentRevenueText = yearlyRentRevenuePriceResult.text ?? "0.0";
            let yearlyInterestText = yearlyInterestPriceResult.text ?? "0.0";
            
            let changedYearlyRentRevenue = formatterToNumber.number(from: yearlyRentRevenueText);
            let changedYearlyInterest = formatterToNumber.number(from: yearlyInterestText);
            
            let yearlyPureRentRevenueCalResult = Double(changedYearlyRentRevenue!) - Double(changedYearlyInterest!);
            let monthlyInterest = Double(changedYearlyInterest!) / 12;
            
            monthlyInterestPriceResult.text = formatterToCurrency.string(from: monthlyInterest as NSNumber);
            yearlyPureRevenuePriceResult.text = formatterToCurrency.string(from: yearlyPureRentRevenueCalResult as NSNumber);
            
        } else if context == &RentRevenueController.YearlyPureRevenuePriceContext {
            let yearlyPureRevenueText = yearlyPureRevenuePriceResult.text ?? "0.0";
            let realInvestPriceText = realInvestmentPriceResult.text ?? "0.0";
            
            let changedYearlyPureRevenueText = formatterToNumber.number(from: yearlyPureRevenueText)
            let changedRealInvestPriceText = formatterToNumber.number(from: realInvestPriceText)
            let monthlyPureRevenuePriceCalResult = Float(changedYearlyPureRevenueText!) / 12;
            let rentRateCalResult = (Float(changedYearlyPureRevenueText!) / Float(changedRealInvestPriceText!)) * 100
            monthlyPureRevenuePriceResult.text = formatterToCurrency.string(from: monthlyPureRevenuePriceCalResult as NSNumber)
            rentRevenueRatePriceResult.text = String(rentRateCalResult)
        } else if context == &RentRevenueController.RealInvestmentPriceContext {
            let yearlyPureRevenueText = formatterToNumber.number(from: yearlyPureRevenuePriceResult.text ?? "0.0");
            let realInvestPriceText = formatterToNumber.number(from: realInvestmentPriceResult.text ?? "0.0");
            
            let rentRevenueRateCalResult = (Float(yearlyPureRevenueText!) / Float(realInvestPriceText!)) * 100
            
            rentRevenueRatePriceResult.text = String(rentRevenueRateCalResult);
        }
        
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension RentRevenueController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

//class YourLabel: UILabel {
//    override var text: String? {
//        didSet {
//            if text != nil {
//                print("Text changed.", text);
//                
//            } else {
//                print("Text not changed.")
//            }
//        }
//    }
//}
