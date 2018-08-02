//
//  SubscriptionPlusController.swift
//  SlideMenuControllerSwift
//
//  Created by 곽기현 on 10/12/2017.
//

import UIKit
import GoogleMobileAds

//weak var dealPriceResult: UILabel!

class SubscriptionPlusController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var noHousePickerTextField: UITextField!
    
    @IBOutlet weak var periodOfSubscriptionAccountPickerTextField: UITextField!
    @IBOutlet weak var numberOfFamilyPickerTextField: UITextField!
    
    @IBOutlet weak var hasHouse: UISegmentedControl!
    
    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var totalResult: UITextField!
    
    @IBOutlet weak var periodOfSubscriptionAccountTextField: UITextField!
    @IBOutlet weak var periodOfSubscriptionAccountResultTextField: UITextField!
    @IBOutlet weak var numberOfFamilyResultTextField: UITextField!
    @IBOutlet weak var numberOfFamilyPeriodTextField: UITextField!
    @IBOutlet weak var noHouseResultTextField: UITextField!
    @IBOutlet weak var noHousePeriodTextField: UITextField!
    let formatterToCurrency = NumberFormatter()
    var noHousePeriodPickerArray = ["0년", "1년 미만", "1년 이상 ~ 2년 미만", "2년 이상 ~ 3년 미만", "3년 이상 ~ 4년 미만", "4년 이상 ~ 5년 미만", "5년 이상 ~ 6년 미만", "6년 이상 ~ 7년 미만", "7년 이상 ~ 8년 미만", "8년 이상 ~ 9년 미만", "9년 이상 ~ 10년 미만", "10년 이상 ~ 11년 미만", "11년 이상 ~ 12년 미만", "12년 이상 ~ 13년 미만", "13년 이상 ~ 14년 미만", "14년 이상 ~ 15년 미만", "15년 이상"];
    var numberOfFamilyPickerArray = ["0명", "1명", "2명", "3명", "4명", "5명", "6명 이상"];
    var periodOfSubscriptionAccountPickerArray = ["6개월 미만", "6개월 이상 ~ 1년 미만", "1년 이상 ~ 2년 미만", "2년 이상 ~ 3년 미만", "3년 이상 ~ 4년 미만", "4년 이상 ~ 5년 미만", "5년 이상 ~ 6년 미만", "6년 이상 ~ 7년 미만", "7년 이상 ~ 8년 미만", "8년 이상 ~ 9년 미만", "9년 이상 ~ 10년 미만", "10년 이상 ~ 11년 미만", "11년 이상 ~ 12년 미만", "12년 이상 ~ 13년 미만", "13년 이상 ~ 14년 미만", "14년 이상 ~ 15년 미만", "15년 이상"];
    var noHousePeriod = 0;
    var numberOfFamily = 0;
    var periodOfSubscriptionAccount = 0;
    
    var noHousePeriodScoreArray = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32];
    var numberOfFamilyScoreArray = [5, 10, 15, 20, 25, 30, 35];
    var periodOfSubscriptionAccountScoreArray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];
    let noHousePickerView = UIPickerView();
    let numberOfFamilyPickerView = UIPickerView();
    let periodOfSubscriptionAccountPickerView = UIPickerView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initializeTextFields()
        
//        let noHousePickerView = UIPickerView();
        noHousePickerView.delegate = self;
        noHousePickerView.tag = 1;
        noHousePickerTextField.inputView = noHousePickerView;
        
        numberOfFamilyPickerView.delegate = self;
        numberOfFamilyPickerView.tag = 2;
        numberOfFamilyPickerTextField.inputView = numberOfFamilyPickerView;
        
        periodOfSubscriptionAccountPickerView.delegate = self;
        periodOfSubscriptionAccountPickerView.tag = 3;
        periodOfSubscriptionAccountPickerTextField.inputView = periodOfSubscriptionAccountPickerView;
        
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        noHousePickerTextField.inputAccessoryView = keyboardToolbar
        numberOfFamilyPickerTextField.inputAccessoryView = keyboardToolbar
        periodOfSubscriptionAccountPickerTextField.inputAccessoryView = keyboardToolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        if pickerView.tag == 1 {
            return noHousePeriodPickerArray.count;
        } else if pickerView.tag == 3 {
            return periodOfSubscriptionAccountPickerArray.count;
        }
        return numberOfFamilyPickerArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return noHousePeriodPickerArray[row];
        } else if pickerView.tag == 2 {
            return numberOfFamilyPickerArray[row];
        } else if pickerView.tag == 3 {
            return periodOfSubscriptionAccountPickerArray[row];
        }
        return noHousePeriodPickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1 {
            noHousePickerTextField.text = noHousePeriodPickerArray[row];
            setNoHousePeriod(row: row);
        } else if pickerView.tag == 2 {
            numberOfFamilyPickerTextField.text = numberOfFamilyPickerArray[row];
            setNumberOfFamily(row: row);
        } else if pickerView.tag == 3 {
            periodOfSubscriptionAccountPickerTextField.text = periodOfSubscriptionAccountPickerArray[row];
            setPeriodOfSubscriptionAccount(row: row);
        } else {
            noHousePickerTextField.text = noHousePeriodPickerArray[row];
            setNoHousePeriod(row: row);
        }
    }
    
    func setNoHousePeriod(row: Int) {
        print("noHousePeriodFunc row : ", row);
        noHousePeriod = row;
    }
    
    func setNumberOfFamily(row: Int) {
        print("numberOfFamilyFunc row : ", row);
        numberOfFamily = row;
    }
    
    func setPeriodOfSubscriptionAccount(row: Int) {
        print("periodOfSubscriptionAccountFunc row : ", row);
        periodOfSubscriptionAccount = row;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
    }
    
    
    @IBAction func clickedCalButton(_ sender: Any) {
        print("clicked button");
        var selectedIndex = hasHouse.selectedSegmentIndex;
//        if (selectedIndex == 1 && numberOfFamily == 0 || periodOfSubscriptionAccount == 0) || (selectedIndex == 1 && noHousePeriod == 0 || numberOfFamily == 0 || periodOfSubscriptionAccount == 0) {
//            self.showToast(message: "모든 항목을 선택해주세요.");
//            return;
//        }
        var result = noHousePeriodScoreArray[noHousePeriod] + numberOfFamilyScoreArray[numberOfFamily] + periodOfSubscriptionAccountScoreArray[periodOfSubscriptionAccount];
        
        // 총점
        totalResult.text = String(result);
        // 무주택기간
        if selectedIndex == 0 {
            noHousePeriodTextField.text = "0년"
        } else {
            noHousePeriodTextField.text = String(noHousePeriodPickerArray[noHousePeriod])
        }
        noHouseResultTextField.text = String(noHousePeriodScoreArray[noHousePeriod]) + "점";
        
        // 부양가족 수
        numberOfFamilyResultTextField.text = String(numberOfFamilyScoreArray[numberOfFamily]) + "점";
        numberOfFamilyPeriodTextField.text = String(numberOfFamilyPickerArray[numberOfFamily]);
        // 청약통장 가입 기간
        periodOfSubscriptionAccountResultTextField.text = String(periodOfSubscriptionAccountScoreArray[periodOfSubscriptionAccount]) + "점";
        periodOfSubscriptionAccountTextField.text = String(periodOfSubscriptionAccountPickerArray[periodOfSubscriptionAccount]);
        
        print("합산결과는 : ", result);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "청약 가점"
        self.setNavigationBarItem()
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        let request = Admob.adLoad();
//            GADRequest()
        
        //test
//        request.testDevices = [ kGADSimulatorID,                       // All simulators
//            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        bannerView.load(request)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch hasHouse.selectedSegmentIndex
        {
        case 0:
            noHousePeriod = 0;
            noHousePickerView.selectRow(0, inComponent: 0, animated: true)
            noHousePickerTextField.text = "";
            noHousePickerTextField.placeholder = "무주택자만 해당 합니다."
            noHousePickerTextField.alpha = 0.5;
            noHousePickerTextField.isUserInteractionEnabled = false;
            print("index0")
        case 1:
            noHousePickerTextField.placeholder = "0년"
            noHousePickerTextField.alpha = 1;
            noHousePickerTextField.isUserInteractionEnabled = true;
            print("index 1 ");
        default:
            break;
        }
    }

    func makeEmptyText(text: UITextField) -> Void {
        text.text = ""
    }
}
