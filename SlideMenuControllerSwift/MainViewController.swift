//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    var depositPrice: Int = 0;
    var monthlyPrice: Int = 0;
    var buyTotalPrice: Int = 0;
    var loanPrice: Int = 0;
    var loanRate: Float = 0.0;
    @IBOutlet var propertyPriceResult: UILabel!
    
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
//        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
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
             loanPriceTextField,
             loanRateTextField:
            print(currentText)
            return prospectiveText.characters.count <= 3
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
        
        propertyPriceResult.text = String(calPropertyPriceResult)
        print("monthlyPrice : ",monthlyPrice);
        print("depositPrice : ",depositPrice);
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
        
        propertyPriceResult.text = String(calPropertyPriceResult)
        
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
        
        
    }

    // 대출금
    @IBAction func loanPriceTextFieldChanged(_ sender: UITextField) {
        print("loanPrice");
        
        if let text = sender.text, !text.isEmpty {
            loanPrice = Int(text)!;
        } else {
            loanPrice = 0;
        }
        
        
    }
    
    // 대출금리
    @IBAction func loanRateTextFieldChanged(_ sender: UITextField) {
        print("loanRate");
        
        if let text = sender.text, !text.isEmpty {
            loanRate = Float(text)!;
        } else {
            loanRate = 0;
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
