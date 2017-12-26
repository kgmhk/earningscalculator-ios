// SquareMeterController
//

import UIKit
import GoogleMobileAds

class SquareMeterController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var meterToSquareResult: UILabel!
    @IBOutlet weak var meterToSquareTextField: UITextField!
    @IBOutlet weak var squareToMeterResult: UILabel!
    @IBOutlet weak var squareMeterTextField: UITextField!
    
    private static var METER_TO_PYEONG = 0.3025;
    private static var PYEONG_TO_METER = 3.305785;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTextFields()
        self.title = "평형 계산"
        
        // add done button
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        meterToSquareTextField.inputAccessoryView = keyboardToolbar
        squareMeterTextField.inputAccessoryView = keyboardToolbar
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        
        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID,                       // All simulators
//            "2077ef9a63d2b398840261c8221a0c9b" ];  // Sample device ID
        
        bannerView.load(request)
    }
 
    @IBAction func meterToSquareChanged(_ sender: UITextField) {
        print("meterToSquare : ", sender.text ?? "no")
        
        var meterVaule: Double
        
        if let text = sender.text, !text.isEmpty {
            meterVaule = Double(text)!;
        } else {
            meterVaule = 0;
        }
        
        let meterToSquareCalResult = meterVaule * SquareMeterController.PYEONG_TO_METER
        
        meterToSquareResult.text = String(meterToSquareCalResult)
        
    }
    @IBAction func squareToMeterChanged(_ sender: UITextField) {
        print("meterToSquare : ", sender.text ?? "no1")
        
        var squareVaule: Double;
        
        if let text = sender.text, !text.isEmpty {
            squareVaule = Double(text)!;
        } else {
            squareVaule = 0;
        }
        
        let squareToMeterCalResult = squareVaule * SquareMeterController.METER_TO_PYEONG
        
        squareToMeterResult.text = String(squareToMeterCalResult)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        meterToSquareTextField.delegate = self
        meterToSquareTextField.keyboardType = UIKeyboardType.decimalPad
        
        squareMeterTextField.delegate = self
        squareMeterTextField.keyboardType = UIKeyboardType.decimalPad
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
        case meterToSquareTextField,
             squareMeterTextField:
            print(currentText)
            // I'm explicitly unwrapping newString here, as I want to use reverse() on it, and that
            // apparently doesn't work with implicitly unwrapped Strings.
            let countdots = (textField.text?.components(separatedBy:".").count)! - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return prospectiveText.characters.count <= 14
        default:
            return true
        }
        
    }
}
