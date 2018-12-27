//
//  AcquisitionTaxController.swift
//  SlideMenuControllerSwift
//
//  Created by 곽기현 on 26/12/2018.
//

import Foundation

import UIKit
import GoogleMobileAds

 @objcMembers class AcquisitionTaxController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var acquisitionTaxPriceResult: UILabel!
    
    @IBOutlet weak var acquisitionTaxPercentResult: UILabel!
    @IBOutlet weak var squareOrMeterLabel: UILabel!
    @IBOutlet weak var tradePriceTextField: UITextField!
    @IBOutlet weak var squareOrMeterTextField: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var squareOrMeterPickerField: UITextField!
    @IBOutlet weak var divisionPickerField: UITextField!
//    @IBOutlet weak var meterToSquareResult: UILabel!
//    @IBOutlet weak var meterToSquareTextField: UITextField!
//    @IBOutlet weak var squareToMeterResult: UILabel!
    
    private static var METER_TO_PYEONG = 0.3025;
    private static var PYEONG_TO_METER = 3.305785;
    
    let divisionPickerView = UIPickerView();
    let squareOrMeterPickerView = UIPickerView();
    
    var divisionPickerArray = ["주택", "주택 외 매매(토지, 건물 등)", "원시취득, 상속(농지 외)", "무상취득(증여)"];
    var squareOrMeterPickerArray = ["m²", "평"];
    
    let formatterToCurrency = NumberFormatter()
    
    var divisionIndex = 0;
    var squareOrMeterIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        self.title = "취득세 계산"
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        squareOrMeterPickerField.inputAccessoryView = keyboardToolbar
        divisionPickerField.inputAccessoryView = keyboardToolbar
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        let request = Admob.adLoad();
        //            GADRequest()
        //        request.testDevices = [ kGADSimulatorID,                       // All simulators
        //            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        divisionPickerView.delegate = self;
        divisionPickerView.tag = 1;
        divisionPickerField.inputView = divisionPickerView;
        
        squareOrMeterPickerView.delegate = self;
        squareOrMeterPickerView.tag = 2;
        squareOrMeterPickerField.inputView = squareOrMeterPickerView;
        
        tradePriceTextField.addTarget(self, action: #selector(tradePriceTextFieldDidChange), for: .editingChanged)
        
        bannerView.load(request)
    }
    
    func tradePriceTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = tradePriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @IBAction func calculatorBtn(_ sender: Any) {
        print("btn clicked");
        
        print("squareOrMeterTextField", squareOrMeterTextField.text);
        print("tradePriceTextField", tradePriceTextField.text);
        
        var square: Double;
    
        if let text = squareOrMeterTextField.text, !text.isEmpty {
           square = Double(text)!;
        } else {
            square = 0;
        }
        
        if squareOrMeterIndex == 1 {
            square = square * AcquisitionTaxController.PYEONG_TO_METER;
        }
        
        var price : Double;
        if let text = tradePriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            price = Double(replacedText)!;
        } else {
            price = 0;
        }
        
//        var price = Double(tradePriceTextField.text?.replacingOccurrences(of: ",", with: ""))
        
        if divisionIndex == 0 {
            calAcquisitionHouse(square: square, price: price);
        } else if divisionIndex == 1 {
            calAcquisitionExceptionHouse(price: price);
        } else if divisionIndex == 2 {
            calAcquisitionInherit(price: price);
        } else if divisionIndex == 3 {
            calAcquisitionFree(price: price);
        } else {
            calAcquisitionHouse(square: square, price: price);
        }
    }
    
    func calAcquisitionFree(price: Double) {
        let result = price * 0.04;
        acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
        acquisitionTaxPercentResult.text = "4";
    }
    
    func calAcquisitionInherit(price: Double) {
        let result = price * 0.0316;
        
        acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
        acquisitionTaxPercentResult.text = "3.16";
    }
    
    func calAcquisitionExceptionHouse(price: Double) {
        let result = price * 0.046;
        
        acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
        acquisitionTaxPercentResult.text = "4.6";
    }
    
    func calAcquisitionHouse(square: Double, price: Double) -> Void {
        print("suqare", square);
        print("price", price);
        
        if (price <= 600000000 && square <= 85) {
            let result = price * 0.011;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "1.1";
        } else if (price <= 600000000 && square > 85) {
            let result = price * 0.013;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "1.3";
        } else if ((price > 600000000 && price <= 900000000) && square <= 85) {
//            Log.i(TAG, "85이하 " + square);
            let result = price * 0.022;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "2.2";
        } else if ((price > 600000000 && price <= 900000000) && square > 85) {
//            Log.i(TAG, "85초과 " + square);
            let result = price * 0.024;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "2.4";
        } else if (price > 900000000 && square <= 85) {
            let result = price * 0.033;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "3.3";
        } else {
            let result = price * 0.035;
            acquisitionTaxPriceResult.text = formatterToCurrency.string(from: result as NSNumber);
            acquisitionTaxPercentResult.text = "3.5";
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return divisionPickerArray.count;
        } else if pickerView.tag == 2 {
            return squareOrMeterPickerArray.count;
        }
        return divisionPickerArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return divisionPickerArray[row];
        }
        else if pickerView.tag == 2 {
            return squareOrMeterPickerArray[row];
        }
//        else if pickerView.tag == 3 {
        //            return periodOfSubscriptionAccountPickerArray[row];
        //        }
        return divisionPickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            divisionIndex = row;
            divisionPickerField.text = divisionPickerArray[row];
            if row == 0 {
                squareOrMeterPickerField.text = "";
                squareOrMeterPickerField.placeholder = "m²"
                squareOrMeterPickerField.alpha = 1;
                squareOrMeterPickerField.isUserInteractionEnabled = true
                
                squareOrMeterTextField.text = "";
                squareOrMeterTextField.placeholder = ""
                squareOrMeterTextField.alpha = 1;
                squareOrMeterTextField.isUserInteractionEnabled = true
            } else {
                squareOrMeterLabel.text = "m²"
                squareOrMeterPickerField.text = "";
                squareOrMeterPickerField.placeholder = "해당 없음"
                squareOrMeterPickerField.alpha = 0.5;
                squareOrMeterPickerField.isUserInteractionEnabled = false
                
                squareOrMeterTextField.text = "";
                squareOrMeterTextField.placeholder = "해당 없음"
                squareOrMeterTextField.alpha = 0.5;
                squareOrMeterTextField.isUserInteractionEnabled = false
            }
            //            setNoHousePeriod(row: row);
        } else if pickerView.tag == 2 {
            squareOrMeterIndex = row;
            squareOrMeterPickerField.text = squareOrMeterPickerArray[row];
            if row == 0 {
                squareOrMeterLabel.text = "m²"
            } else {
                squareOrMeterLabel.text = "평"
            }
//            setNumberOfFamily(row: row);
        }
            //        } else if pickerView.tag == 3 {
            //            periodOfSubscriptionAccountPickerTextField.text = periodOfSubscriptionAccountPickerArray[row];
            //            setPeriodOfSubscriptionAccount(row: row);
            //        }
        else {
            divisionPickerField.text = divisionPickerArray[row];
            //            setNoHouseㅘㅚㅓPeriod(row: row);
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
//        meterToSquareTextField.delegate = self
//        meterToSquareTextField.keyboardType = UIKeyboardType.decimalPad
        
        squareOrMeterTextField.delegate = self
        squareOrMeterTextField.keyboardType = UIKeyboardType.decimalPad
        
        tradePriceTextField.delegate = self
        
        
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
        case squareOrMeterTextField:
            print(currentText)
            // I'm explicitly unwrapping newString here, as I want to use reverse() on it, and that
            // apparently doesn't work with implicitly unwrapped Strings.
            let countdots = (textField.text?.components(separatedBy:".").count)! - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return prospectiveText.characters.count <= 14
        case tradePriceTextField:
            return prospectiveText.characters.count <= 20
        default:
            return true
        }
        
    }
}
