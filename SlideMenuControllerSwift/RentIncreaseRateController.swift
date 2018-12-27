//
//  RentIncreaseRateController.swift
//  SlideMenuControllerSwift
//
//  Created by 곽기현 on 27/12/2018.
//

import Foundation

import UIKit
import GoogleMobileAds

class RentIncreaseRateController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var yearlyFeeResult: UILabel!
    @IBOutlet weak var monthlyIncreaseResult: UILabel!
    @IBOutlet weak var depositIncreaseResult: UILabel!
    @IBOutlet weak var rentIncreaseRateResult: UILabel!
    @IBOutlet weak var rentIncreaseRateTextField: UITextField!
    @IBOutlet weak var afterDepositTextField: UITextField!
    @IBOutlet weak var beforeMonthlyFeeTextField: UITextField!
    @IBOutlet weak var beforeDepositTextField: UITextField!
    
    let formatterToCurrency = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        self.title = "월세 인상률 계산기"
        
        // admob
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        let request = Admob.adLoad();
        bannerView.load(request)
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        beforeDepositTextField.inputAccessoryView = keyboardToolbar;
        beforeMonthlyFeeTextField.inputAccessoryView = keyboardToolbar;
        afterDepositTextField.inputAccessoryView = keyboardToolbar;
        rentIncreaseRateTextField.inputAccessoryView = keyboardToolbar;
        
        // formatter string to currency
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        beforeDepositTextField.addTarget(self, action: #selector(changeStringToCurrency), for: .editingChanged)
        beforeMonthlyFeeTextField.addTarget(self, action: #selector(changeStringToCurrency), for: .editingChanged)
        afterDepositTextField.addTarget(self, action: #selector(changeStringToCurrency), for: .editingChanged)
        
    }
    
    func changeStringToCurrency(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @IBAction func calculatorBtn(_ sender: Any) {
        
        var beforeDeposit: Double = 0;
        var beforeMonthlyFee: Double = 0;
        var afterDeposit: Double = 0;
        var rentIncreaseRate: Double = 0;
        
        print("beforeDepositTextField.text", beforeDepositTextField.text);
        print("beforeMonthlyFeeTextField.text", beforeMonthlyFeeTextField.text)
        print("afterDepositTextField.text", afterDepositTextField.text);
        print("rentIncreaseRateTextField.text", rentIncreaseRateTextField.text)
        
        
        if let text = beforeDepositTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            beforeDeposit = Double(replacedText)!;
        } else {
            beforeDeposit = 0;
        }
        if let text = beforeMonthlyFeeTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            beforeMonthlyFee = Double(replacedText)!;
        } else {
            beforeMonthlyFee = 0;
        }
        if let text = afterDepositTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            afterDeposit = Double(replacedText)!;
        } else {
            afterDeposit = 0;
        }
        if let text = rentIncreaseRateTextField.text, !text.isEmpty {
            rentIncreaseRate = Double(text)!;
        } else {
            rentIncreaseRate = 5.25;
        }
        
        rentIncreaseRateResult.text = String(rentIncreaseRate);
        depositIncreaseResult.text = formatterToCurrency.string(from: round(afterDeposit) as NSNumber);
        
        let step1 = beforeDeposit * (1 + (rentIncreaseRate/100))
        print("beforeDeposit * (1 + rentIncreaseRate", step1);
        let step2 = step1 - afterDeposit;
        print("step2" , step2);
        let step3 = step2 * (rentIncreaseRate/100);
        print("step3", step3);
        let step4 = step3 / 12;
        print("step4", step4);
        let step5 = step4 + (beforeMonthlyFee * (1 + (rentIncreaseRate/100)));
        print("step5", step5);
        
        let result = ((((beforeDeposit * (1 + (rentIncreaseRate/100))) - afterDeposit) * (rentIncreaseRate/100)) / 12 ) + (beforeMonthlyFee * (1 + (rentIncreaseRate/100)));
        let yearlyResult = result * 12;
        monthlyIncreaseResult.text = formatterToCurrency.string(from: round(result) as NSNumber);
        yearlyFeeResult.text = formatterToCurrency.string(from: round(yearlyResult) as NSNumber);
    }
    
    func initializeTextFields() {
        beforeDepositTextField.delegate = self
        beforeMonthlyFeeTextField.delegate = self
        afterDepositTextField.delegate = self
        rentIncreaseRateTextField.delegate = self
        rentIncreaseRateTextField.keyboardType = UIKeyboardType.decimalPad
    }
    
    // activate navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
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
        case rentIncreaseRateTextField:
            print(currentText)
            // I'm explicitly unwrapping newString here, as I want to use reverse() on it, and that
            // apparently doesn't work with implicitly unwrapped Strings.
            let countdots = (textField.text?.components(separatedBy:".").count)! - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return prospectiveText.characters.count <= 14
        case beforeDepositTextField, beforeMonthlyFeeTextField, afterDepositTextField:
            return prospectiveText.characters.count <= 20
        default:
            return true
        }
        
    }
}
