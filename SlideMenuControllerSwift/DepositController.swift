//
//  DepositController.swift
//  SlideMenuControllerSwift
//
//  Created by Kwak, GiHyun on 02/08/2018.
//

import Foundation

// deposit fee
//

import UIKit
import GoogleMobileAds

//weak var dealPriceResult1: UILabel!

class DepositController: UIViewController, UITextFieldDelegate {
    private var selectStatus: TypeOfAccountStatus = TypeOfAccountStatus.deposit;
    
    private var depositAmount: Double = 0;
    private var depositPeriod: Double = 0;
    private var yearlyInterestRate: Double = 0;
    private var interestTaxRate: Double = 0;
    
    private var yearlyInterestSegment: TypeOfInterest = TypeOfInterest.simpleInterest
    
    @IBOutlet weak var principalSumLabel: UILabel!
    @IBOutlet weak var interestBeforeTaxLabel: UILabel!
    @IBOutlet weak var interestTaxResultLabel: UILabel!
    @IBOutlet weak var interestTotalResultLabel: UILabel!
    
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var yearlyInterestTextField: UITextField!
    @IBOutlet weak var interestTaxField: UITextField!
    @IBOutlet weak var depositPeriodTextField: UITextField!
    
    @IBOutlet weak var commissionMonthlyPriceTitle: UILabel!
    @IBOutlet weak var dealPriceTitle: UILabel!
    @IBOutlet weak var depositPriceTitle: UILabel!
    
    @IBOutlet weak var interestTaxSegmentedControl: UISegmentedControl!
    @IBOutlet weak var yearlyInterestSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let formatterToCurrency = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        depositTextField.inputAccessoryView = keyboardToolbar
        yearlyInterestTextField.inputAccessoryView = keyboardToolbar
        interestTaxField.inputAccessoryView = keyboardToolbar
        depositPeriodTextField.inputAccessoryView = keyboardToolbar
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        depositTextField.addTarget(self, action: #selector(depositTextFieldDidChange), for: .editingChanged)
//        yearlyInterestTextField.addTarget(self, action: #selector(depositPriceTextFieldDidChange), for: .editingChanged)
//        interestTaxField.addTarget(self, action: #selector(commissionMonthlyPriceTextFieldDidChange), for: .editingChanged)
    }
    
    func depositTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = depositTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }

    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        depositTextField.delegate = self
        depositTextField.keyboardType = UIKeyboardType.numberPad
        
        depositPeriodTextField.delegate = self
        depositPeriodTextField.keyboardType = UIKeyboardType.numberPad
        
        yearlyInterestTextField.delegate = self
        yearlyInterestTextField.keyboardType = UIKeyboardType.decimalPad
        
        interestTaxField.delegate = self
        interestTaxField.keyboardType = UIKeyboardType.decimalPad
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
        case depositTextField:
            print(currentText)
            return prospectiveText.characters.count <= 14
        case depositPeriodTextField:
            return prospectiveText.characters.count <= 3
        case yearlyInterestTextField,
             interestTaxField:
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
    
    // 계산 버튼
    @IBAction func calculateBtn(_ sender: UIButton) {
        print("click button", selectStatus);
        switch selectStatus {
        case TypeOfAccountStatus.deposit:
            calDeposit()
            print("clieckt deposit " )
        case TypeOfAccountStatus.installmentSavings:
            calInstallmentSavings()
            print("cleickt installment")
        default:
            return;
        }
        
    }
    
    // 예금
    func calDeposit() -> Void {
        print("cal deposit")
        checkInput()
        
        if (TypeOfInterest.simpleInterest == yearlyInterestSegment) {
            var interestAmount = depositAmount * ( yearlyInterestRate / 100 ) * ( depositPeriod / 12 )
            var interestTax = interestAmount *  ( interestTaxRate / 100 )
            var totalResult = depositAmount + interestAmount - interestTax
            
            principalSumLabel.text = formatterToCurrency.string(from: depositAmount.rounded() as NSNumber)
            interestBeforeTaxLabel.text = formatterToCurrency.string(from: interestAmount.rounded() as NSNumber)
            interestTaxResultLabel.text = "- " + formatterToCurrency.string(from: interestTax.rounded() as NSNumber)!
            interestTotalResultLabel.text = formatterToCurrency.string(from: totalResult.rounded() as NSNumber)
        } else {
            let tempRate = (1 + (yearlyInterestRate / 100) / 12 );
            let interestAmount = depositAmount * pow( tempRate, depositPeriod);
            let interestTax = (interestAmount - depositAmount) * ( interestTaxRate / 100 );
            let interestBeforeTaxResult = interestAmount - depositAmount
            let interestTotalResult = interestAmount - interestTax
            
            principalSumLabel.text = formatterToCurrency.string(from: depositAmount.rounded() as NSNumber)
            interestBeforeTaxLabel.text = formatterToCurrency.string(from: interestBeforeTaxResult.rounded() as NSNumber)
            interestTaxResultLabel.text = "- " + formatterToCurrency.string(from: interestTax.rounded() as NSNumber)!
            interestTotalResultLabel.text = formatterToCurrency.string(from: interestTotalResult.rounded() as NSNumber)
        }
        
        
    }
    
    func calInstallmentSavings() -> Void {
        checkInput()
    
        var monthlyArg = depositPeriod * ( depositPeriod + 1 ) / 2;
        
        if (TypeOfInterest.simpleInterest == yearlyInterestSegment) {
            let interestAmount = depositAmount * ( yearlyInterestRate / 100 ) * monthlyArg / 12;
            let interestTax = interestAmount * ( interestTaxRate / 100 );
            let principalSumResult = depositAmount * depositPeriod;
            let totalResult = principalSumResult + interestAmount - interestTax
            
            principalSumLabel.text = formatterToCurrency.string(from: principalSumResult.rounded() as NSNumber)
            interestBeforeTaxLabel.text = formatterToCurrency.string(from: interestAmount.rounded() as NSNumber)
            interestTaxResultLabel.text = "- " + formatterToCurrency.string(from: interestTax.rounded() as NSNumber)!
            interestTotalResultLabel.text = formatterToCurrency.string(from: totalResult.rounded() as NSNumber)
        } else {
            let monthlyInterestRate = ((yearlyInterestRate / 100) / 12 );
            let totalResult = depositAmount *
                (1 + monthlyInterestRate) *
                (pow((1 + monthlyInterestRate), depositPeriod) - 1) /
            monthlyInterestRate;
            
            let interestAmount = totalResult - ( depositAmount * depositPeriod );
            let interestTax = (interestAmount) * ( interestTaxRate / 100 );
            let principalSumResult = depositAmount * depositPeriod;
            
            
            principalSumLabel.text = formatterToCurrency.string(from: principalSumResult.rounded() as NSNumber)
            interestBeforeTaxLabel.text = formatterToCurrency.string(from: interestAmount.rounded() as NSNumber)
            interestTaxResultLabel.text = "- " + formatterToCurrency.string(from: interestTax.rounded() as NSNumber)!
            interestTotalResultLabel.text = formatterToCurrency.string(from: (totalResult.rounded() - interestTax.rounded()) as NSNumber)
        }
    }

    func checkInput() -> Void {
        if let text = depositTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            depositAmount = Double(replacedText)!;
        } else {
            depositAmount = 0;
        }
        
        if let text = depositPeriodTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            depositPeriod = Double(replacedText)!;
        } else {
            depositPeriod = 0;
        }
        
        if let text = interestTaxField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            interestTaxRate = Double(replacedText)!;
        } else {
            interestTaxRate = 0.0;
        }
        
        if let text = yearlyInterestTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            yearlyInterestRate = Double(replacedText)!;
        } else {
            yearlyInterestRate = 0.0;
        }
        
        if (depositAmount == 0 || yearlyInterestRate == 0 || depositPeriod == 0) {
            self.showToast(message: "모든 항목을 입력해주세요.")
            return;
        }
    }
//    // 적금
//    func calInstallmentSavings() -> Void {
//        print("calAboutLease")
//
//        if let text = depositPriceTextField.text, !text.isEmpty {
//            let replacedText = text.replacingOccurrences(of: ",", with: "")
//            depositPrice = Double(replacedText)!;
//        } else {
//            depositPrice = 0;
//        }
//
//        if (depositPrice == 0) {
//            self.showToast(message: "보증금을 입력해주세요.");
//        }
//
//        if (depositPrice < 50000000) {
//            var depositResult = depositPrice * 0.005;
//
//            if(depositResult > 200000) {
//                depositResult = 2000000;
//            }
//
//            dealPriceResult.text = depositPriceTextField.text
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
//            upperLimitPriceResult.text = "200,000"
//            upperLimitRateResult.text = "0.5"
//        } else if (depositPrice >= 50000000 && depositPrice < 100000000) {
//            var depositResult = depositPrice * 0.004;
//
//            if(depositResult > 300000) {
//                depositResult = 300000;
//            }
//
//            dealPriceResult.text = depositPriceTextField.text
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
//            upperLimitPriceResult.text = "300,000"
//            upperLimitRateResult.text = "0.4"
//        } else if (depositPrice >= 100000000 && depositPrice < 300000000) {
//            let depositResult = depositPrice * 0.003;
//
//            dealPriceResult.text = depositPriceTextField.text
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.3"
//        } else if (depositPrice >= 300000000 && depositPrice < 600000000) {
//            let depositResult = depositPrice * 0.004;
//
//            dealPriceResult.text = depositPriceTextField.text
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.4"
//        } else {
//            let depositResult = depositPrice * 0.008;
//
//            dealPriceResult.text = depositPriceTextField.text
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: depositResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.8"
//        }
//    }
//
//    func calAboutMonth() -> Void {
//
//        // deposit
//        if let text = depositPriceTextField.text, !text.isEmpty {
//            let replacedText = text.replacingOccurrences(of: ",", with: "")
//            depositPrice = Double(replacedText)!;
//        } else {
//            depositPrice = 0;
//        }
//
//        // monthly fee
//        if let text = commissionMonthlyPriceTextField.text, !text.isEmpty {
//            let replacedText = text.replacingOccurrences(of: ",", with: "")
//            commissionMothlyPrice = Double(replacedText)!;
//        } else {
//            commissionMothlyPrice = 0;
//        }
//
//        if (depositPrice == 0 || commissionMothlyPrice == 0) {
//            self.showToast(message: "보증금과 월세액을 입력해주세요.");
//        }
//
//
//        var resultDealPrice = depositPrice + (commissionMothlyPrice * 100);
//
//        if (resultDealPrice < 50000000) {
//            resultDealPrice = depositPrice + (commissionMothlyPrice * 70);
//        }
//
//        if (resultDealPrice < 50000000) {
//            var dealResult = resultDealPrice * 0.005;
//
//            if(dealResult > 200000) {
//                dealResult = 2000000;
//            }
//
//            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
//            upperLimitPriceResult.text = "200,000"
//            upperLimitRateResult.text = "0.5"
//        } else if (resultDealPrice >= 50000000 && resultDealPrice < 100000000) {
//            var dealResult = resultDealPrice * 0.004;
//
//            if(dealResult > 300000) {
//                dealResult = 300000;
//            }
//
//            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
//            upperLimitPriceResult.text = "300,000"
//            upperLimitRateResult.text = "0.4"
//        } else if (resultDealPrice >= 100000000 && resultDealPrice < 300000000) {
//            let dealResult = resultDealPrice * 0.003;
//
//            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.3"
//        } else if (resultDealPrice >= 300000000 && resultDealPrice < 600000000) {
//            let dealResult = resultDealPrice * 0.004;
//
//            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.4"
//        } else {
//            let dealResult = resultDealPrice * 0.008;
//
//            dealPriceResult.text = formatterToCurrency.string(from: resultDealPrice as NSNumber)
//            maxCommissionPriceResult.text = formatterToCurrency.string(from: dealResult as NSNumber)
//            upperLimitPriceResult.text = "-"
//            upperLimitRateResult.text = "0.8"
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "예적금 계산기"
        self.setNavigationBarItem()
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        let request = Admob.adLoad();
        //            GADRequest()
        //        request.testDevices = [ kGADSimulatorID,                       // All simulators
        //            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        bannerView.load(request)
    }
    
    // 이자과세
    @IBAction func interestTaxChanged(_ sender: UISegmentedControl) {
        switch interestTaxSegmentedControl.selectedSegmentIndex {
        case 0:
            print("일반과세 15.4")
            interestTaxField.text = "15.4"
            interestTaxField.isEnabled = false
        case 1:
            print("비과세 0")
            interestTaxField.text = "0"
            interestTaxField.isEnabled = false
        case 2:
            print("우대과세 9.5")
            interestTaxField.text = "9.5"
            interestTaxField.isEnabled = true
        default:
            break
        }
    }
    
    // 연이자율
    @IBAction func yearlyInterestChanged(_ sender: UISegmentedControl) {
        switch yearlyInterestSegmentedControl.selectedSegmentIndex {
        case 0:
            print("단리")
            yearlyInterestSegment = TypeOfInterest.simpleInterest
        case 1:
            print("복리")
            yearlyInterestSegment = TypeOfInterest.compoundInteres
        default:
            break
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            selectStatus = TypeOfAccountStatus.deposit
//
//            dealPriceTextField.isEnabled = true;
//            depositPriceTextField.isEnabled = false;
//            commissionMonthlyPriceTextField.isEnabled = false;
//
//            makeEmptyText(text: depositPriceTextField)
//            makeEmptyText(text: commissionMonthlyPriceTextField)
            print("index0")
        case 1:
            selectStatus = TypeOfAccountStatus.installmentSavings
//            dealPriceTextField.isEnabled = false;
//            depositPriceTextField.isEnabled = true;
//            commissionMonthlyPriceTextField.isEnabled = false;
//
//            makeEmptyText(text: dealPriceTextField)
//            makeEmptyText(text: commissionMonthlyPriceTextField)
            print("index 1 ");
        default:
            break;
        }
    }
    
    func makeEmptyText(text: UITextField) -> Void {
        text.text = ""
    }
}

