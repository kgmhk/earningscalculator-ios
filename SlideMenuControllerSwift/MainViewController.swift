//  Created by gihyun on 07/.

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    private static var YearlyRentRevenueContext = 0;
    private static var YearlyInterestPriceContext = 1;
    private static var YearlyPureRevenuePriceContext = 2;
    private static var RealInvestmentPriceContext = 3;
    
    var depositPrice: Int = 0;
    var monthlyPrice: Int = 0;
    var buyTotalPrice: Int = 0;
    var loanPrice: Int = 0;
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
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        
        formatterToNumber.numberStyle = .decimal
        formatterToNumber.currencySymbol = ""
        
        yearlyRentRevenuePriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &MainViewController.YearlyRentRevenueContext)
        yearlyInterestPriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &MainViewController.YearlyInterestPriceContext);
        yearlyPureRevenuePriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &MainViewController.YearlyPureRevenuePriceContext)
        realInvestmentPriceResult.addObserver(self, forKeyPath: "text", options: [.old, .new], context: &MainViewController.RealInvestmentPriceContext)
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
                return prospectiveText.characters.count <= 10
            case loanRateTextField:
                return prospectiveText.characters.count <= 10
            default:
                return true
        }
        
    }
    
    // 월세
    @IBAction func monthlyTextFieldChanged(_ sender: UITextField) {
        
        print("monthlyPrice");
    
        if let text = sender.text, !text.isEmpty {
            monthlyPrice = Int(text)!;
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
        
        print("depositPrice");
        
        if let text = sender.text, !text.isEmpty {
            depositPrice = Int(text)!;
        } else {
            depositPrice = 0;
        }
        
        let calPropertyPriceResult = depositPrice + (monthlyPrice * 200)
        let convertedcalPropertyPriceResult = calPropertyPriceResult as NSNumber
        let formatedText = formatterToCurrency.string(from: convertedcalPropertyPriceResult)!
        
        propertyPriceResult.text = String(formatedText)
        
        print("monthlyPrice : ",monthlyPrice);
        print("depositPrice : ",depositPrice);
        
    }
    
    // 분양가
    @IBAction func buyTotalPriceTextFieldChanged(_ sender: UITextField) {
        print("buyTotalPrice");
        
        if let text = sender.text, !text.isEmpty {
            buyTotalPrice = Int(text)!;
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
            loanPrice = Int(text)!;
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
            loanRate = 0;
        }
        
        let yearlyRevenueCalResult = (Float(loanPrice) * loanRate) / 100;
        let convertedYearlyRevenueCalResult = yearlyRevenueCalResult as NSNumber;
        let formatedYearlyRevenueResult = formatterToCurrency.string(from: convertedYearlyRevenueCalResult);
        
        yearlyInterestPriceResult.text = formatedYearlyRevenueResult; // 연이자
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &MainViewController.YearlyRentRevenueContext {
            let ChangedYearlyRentRevenue = formatterToNumber.number(from: change?[.newKey] as! String);
            let yearlyInterestPrice = Float(yearlyInterestPriceResult.text!) ?? 0.0;
            let yearlyRentRevenuePrice = Float(ChangedYearlyRentRevenue!) ;
            
            let yearlyPureRevenueCalResult = yearlyRentRevenuePrice - yearlyInterestPrice
            let convertedYearlyPureRevenue = yearlyPureRevenueCalResult as NSNumber;
            let formatedYearlyPureRevenueResult = formatterToCurrency.string(from: convertedYearlyPureRevenue)
            
            yearlyPureRevenuePriceResult.text = formatedYearlyPureRevenueResult // 연순수익
        } else if context == &MainViewController.YearlyInterestPriceContext {
            let yearlyRentRevenueText = yearlyRentRevenuePriceResult.text ?? "0.0";
            let yearlyInterestText = yearlyInterestPriceResult.text ?? "0.0";
            
            let changedYearlyRentRevenue = formatterToNumber.number(from: yearlyRentRevenueText);
            let changedYearlyInterest = formatterToNumber.number(from: yearlyInterestText);
            
            let yearlyPureRentRevenueCalResult = Float(changedYearlyRentRevenue!) - Float(changedYearlyInterest!);
            let monthlyInterest = Float(changedYearlyInterest!) / 12;
            
            yearlyPureRevenuePriceResult.text = formatterToCurrency.string(from: yearlyPureRentRevenueCalResult as NSNumber);
            monthlyInterestPriceResult.text = formatterToCurrency.string(from: monthlyInterest as NSNumber);
        } else if context == &MainViewController.YearlyPureRevenuePriceContext {
            let yearlyPureRevenueText = yearlyPureRevenuePriceResult.text ?? "0.0";
            let realInvestPriceText = realInvestmentPriceResult.text ?? "0.0";
            
            let changedYearlyPureRevenueText = formatterToNumber.number(from: yearlyPureRevenueText)
            let changedRealInvestPriceText = formatterToNumber.number(from: realInvestPriceText)
            
            let monthlyPureRevenuePriceCalResult = Float(changedYearlyPureRevenueText!) / 12;
            let rentRateCalResult = (Float(changedYearlyPureRevenueText!) / Float(changedRealInvestPriceText!)) * 100
            
            monthlyPureRevenuePriceResult.text = formatterToCurrency.string(from: monthlyPureRevenuePriceCalResult as NSNumber)
            rentRevenueRatePriceResult.text = String(rentRateCalResult)
        } else if context == &MainViewController.RealInvestmentPriceContext {
            let yearlyPureRevenueText = formatterToNumber.number(from: yearlyPureRevenuePriceResult.text ?? "0.0");
            let realInvestPriceText = formatterToNumber.number(from: realInvestmentPriceResult.text ?? "0.0");
            
            let rentRevenueRateCalResult = (Float(yearlyPureRevenueText!) / Float(realInvestPriceText!)) * 100
            
            rentRevenueRatePriceResult.text = formatterToCurrency.string(from: rentRevenueRateCalResult as NSNumber);
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

extension MainViewController : SlideMenuControllerDelegate {
    
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
