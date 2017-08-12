import UIKit
import GoogleMobileAds

class InterestController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var resultContainer: UIStackView!
    @IBOutlet weak var repaymentStackView: UIStackView!
    @IBOutlet weak var originalPaymentStackView: UIStackView!
    @IBOutlet weak var monthlyInterestStackView: UIStackView!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var loanMethodResult: UILabel!
    @IBOutlet weak var loanDurationResult: UILabel!
    @IBOutlet weak var loanRateResult: UILabel!
    @IBOutlet weak var loanPriceResult: UILabel!
    @IBOutlet weak var totalInterestResult: UILabel!
    @IBOutlet weak var repaymentResult: UILabel!
    @IBOutlet weak var originalPaymentResult: UILabel!
    @IBOutlet weak var monthlyInterestResult: UILabel!
    
    
    @IBOutlet weak var loanMethodSegement: UISegmentedControl!
    @IBOutlet weak var loanDurationTextField: UITextField!
    @IBOutlet weak var loanRateTextField: UITextField!
    @IBOutlet weak var loanPriceTextField: UITextField!
    
    var loanPrice: Double = 0;
    var loanRate: Double = 0.0;
    var loanDuration: Double = 0;
    var selectStatus: InterestSelecteStatus = InterestSelecteStatus.originalPriceEqual;
    
    let formatterToCurrency = NumberFormatter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeTextFields();
        self.title = "대출 이자"
        
        formatterToCurrency.numberStyle = .currency
        formatterToCurrency.currencySymbol = ""
        formatterToCurrency.minimumFractionDigits = 0
        
        originalPaymentStackView.isHidden = false;
        monthlyInterestStackView.isHidden = true;
        repaymentStackView.isHidden = true;
//        resultContainer.isHidden = true;
        
        // admob banner ads
        bannerView.adUnitID = "ca-app-pub-2778546304304506/2899286231"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

//        for i in 0..<37 {
//            //Text Label
//            let textLabel = UILabel()
//            textLabel.backgroundColor = UIColor.yellow
//            textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//            textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//            textLabel.text  = "Hi World"
//            textLabel.textAlignment = .center
//            
//            let textLabel1 = UILabel()
//            textLabel1.backgroundColor = UIColor.yellow
//            textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//            textLabel1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//            textLabel1.text  = "Hi Tingtoa"
//            textLabel1.textAlignment = .center
//            
//            //Stack View
//            let stackView   = UIStackView()
//            stackView.axis  = UILayoutConstraintAxis.horizontal
//            stackView.distribution  = UIStackViewDistribution.fillEqually
//            stackView.alignment = UIStackViewAlignment.center
//            stackView.spacing   = 16.0
//            
//            stackView.addArrangedSubview(textLabel)
//            stackView.addArrangedSubview(textLabel1)
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            
//            resultContainer.addArrangedSubview(stackView)
//        }
        
        
        
        // number to currency
        loanPriceTextField.addTarget(self, action: #selector(loanPriceTextFieldDidChange), for: .editingChanged)
        
    }
    
    // Designate this class as the text fields' delegate
    // and set their keyboards while we're at it.
    func initializeTextFields() {
        loanPriceTextField.delegate = self
        loanPriceTextField.keyboardType = UIKeyboardType.numberPad
        
        loanRateTextField.delegate = self
        loanRateTextField.keyboardType = UIKeyboardType.decimalPad
        
        loanDurationTextField.delegate = self
        loanDurationTextField.keyboardType = UIKeyboardType.numberPad
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
        case loanPriceTextField:
            print(currentText)
            return prospectiveText.characters.count <= 14
        case loanRateTextField:
            let countdots = (textField.text?.components(separatedBy:".").count)! - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return prospectiveText.characters.count <= 6
        case loanDurationTextField:
            return prospectiveText.characters.count <= 3
        default:
            return true
        }
        
    }
    
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch loanMethodSegement.selectedSegmentIndex
        {
        case 0:
            selectStatus = InterestSelecteStatus.originalPriceEqual
            originalPaymentStackView.isHidden = false;
            monthlyInterestStackView.isHidden = true;
            repaymentStackView.isHidden = true;
        case 1:
            selectStatus = InterestSelecteStatus.principalAndInterest
            originalPaymentStackView.isHidden = true;
            monthlyInterestStackView.isHidden = true;
            repaymentStackView.isHidden = false;
        case 2:
            selectStatus = InterestSelecteStatus.expiryDateOfPrincipalMaturity
            originalPaymentStackView.isHidden = true;
            monthlyInterestStackView.isHidden = false;
            repaymentStackView.isHidden = false;
        default:
            break;
        }
    }
    
    @IBAction func onClickCalBtn(_ sender: Any) {
        if let text = loanPriceTextField.text, !text.isEmpty {
            let replacedText = text.replacingOccurrences(of: ",", with: "")
            loanPrice = Double(replacedText)!;
        } else {
            loanPrice = 0;
        }
        
        if let text = loanRateTextField.text, !text.isEmpty {
            loanRate = Double(text)!;
        } else {
            loanRate = 0;
        }
        
        if let text = loanDurationTextField.text, !text.isEmpty {
            loanDuration = Double(text)!;
        } else {
            loanDuration = 0;
        }
        
        if (loanPrice == 0 || loanRate == 0 || loanDuration == 0) {
            self.showToast(message: "모든 항목을 입력해주세요.");
            return
        }
        
        initStatckView();
        
        if (selectStatus == InterestSelecteStatus.originalPriceEqual) {
            calFirstMethod(loanPrice: loanPrice, loanRate: loanRate, loanDuration: loanDuration)
        }
    }
    
    func calFirstMethod(loanPrice: Double, loanRate: Double, loanDuration: Double) {

        var calInterestResult: Double = 0;
        var calOriginalResult: Double = loanPrice / loanDuration;
        var calInterestTotalResult: Double = 0;
        
        loanPriceResult.text = formatterToCurrency.string(from: loanPrice as NSNumber);
        loanRateResult.text = String(loanRate);
        loanDurationResult.text = String(loanDuration);
        loanMethodResult.text = "원리균등상환";
        originalPaymentResult.text = formatterToCurrency.string(from: calOriginalResult as NSNumber);
        
        for i in 0..<Int(loanDuration + 1) {
            if (i == 0) {
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.yellow
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel.text  = "No"
                textLabel.textAlignment = .center
                textLabel.sizeToFit()
                
                let textLabel1 = UILabel()
                textLabel1.backgroundColor = UIColor.yellow
                textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel1.text  = "상환금"
                textLabel1.textAlignment = .center
                
                let textLabel2 = UILabel()
                textLabel2.backgroundColor = UIColor.yellow
                textLabel2.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel2.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel2.text  = "납입원금"
                textLabel2.textAlignment = .center
                
                let textLabel3 = UILabel()
                textLabel3.backgroundColor = UIColor.yellow
                textLabel3.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel3.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel3.text  = "이자"
                textLabel3.textAlignment = .center
                
                let textLabel4 = UILabel()
                textLabel4.backgroundColor = UIColor.yellow
                textLabel4.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel4.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel4.text  = "잔금"
                textLabel4.textAlignment = .center
                
                //Stack View
                let stackView   = UIStackView()
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution  = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.center
                stackView.spacing   = 5.0
                
                stackView.addArrangedSubview(textLabel)
                stackView.addArrangedSubview(textLabel1)
                stackView.addArrangedSubview(textLabel2)
                stackView.addArrangedSubview(textLabel3)
                stackView.addArrangedSubview(textLabel4)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                            
                resultContainer.addArrangedSubview(stackView)
            } else if (i == Int(loanDuration)) {
                calInterestResult = ((loanPrice - (calOriginalResult * Double(i - 1))) * (loanRate / Double(100))) / Double(12);
                calInterestTotalResult += calInterestResult;
                
                
                
                
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.yellow
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel.text  = String(i)
                textLabel.textAlignment = .center
                textLabel.sizeToFit()
                textLabel.adjustsFontSizeToFitWidth = true
                
                let textLabel1 = UILabel()
                textLabel1.backgroundColor = UIColor.yellow
                textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel1.text  = formatterToCurrency.string(from: Int(calOriginalResult + calInterestResult) as NSNumber)
                textLabel1.textAlignment = .center
                textLabel1.sizeToFit()
                textLabel1.adjustsFontSizeToFitWidth = true
                
                let textLabel2 = UILabel()
                textLabel2.backgroundColor = UIColor.yellow
                textLabel2.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel2.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel2.text  = formatterToCurrency.string(from: Int(calOriginalResult) as NSNumber)
                textLabel2.textAlignment = .center
                textLabel2.sizeToFit()
                textLabel2.adjustsFontSizeToFitWidth = true
                
                let textLabel3 = UILabel()
                textLabel3.backgroundColor = UIColor.yellow
                textLabel3.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel3.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel3.text  = formatterToCurrency.string(from: Int(calInterestResult) as NSNumber)
                textLabel3.textAlignment = .center
                textLabel3.sizeToFit()
                textLabel3.adjustsFontSizeToFitWidth = true
                
                let textLabel4 = UILabel()
                textLabel4.backgroundColor = UIColor.yellow
                textLabel4.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel4.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel4.text  = "0"
                textLabel4.textAlignment = .center
                textLabel4.sizeToFit()
                textLabel4.adjustsFontSizeToFitWidth = true
                
                //Stack View
                let stackView   = UIStackView()
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution  = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.center
                stackView.spacing   = 5.0
                
                stackView.addArrangedSubview(textLabel)
                stackView.addArrangedSubview(textLabel1)
                stackView.addArrangedSubview(textLabel2)
                stackView.addArrangedSubview(textLabel3)
                stackView.addArrangedSubview(textLabel4)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                resultContainer.addArrangedSubview(stackView)
            } else {
                calInterestResult = ((loanPrice - (calOriginalResult * Double(i - 1))) * (loanRate / Double(100))) / Double(12);
                calInterestTotalResult += calInterestResult;
                
                let textLabel = UILabel()
                textLabel.backgroundColor = UIColor.yellow
                textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel.text  = String(i)
                textLabel.textAlignment = .center
                textLabel.sizeToFit()
                textLabel.adjustsFontSizeToFitWidth = true
                
                let textLabel1 = UILabel()
                textLabel1.backgroundColor = UIColor.yellow
                textLabel1.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel1.text  = formatterToCurrency.string(from: Int(calOriginalResult + calInterestResult) as NSNumber)
                textLabel1.textAlignment = .center
                textLabel1.sizeToFit()
                textLabel1.adjustsFontSizeToFitWidth = true
                
                let textLabel2 = UILabel()
                textLabel2.backgroundColor = UIColor.yellow
                textLabel2.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel2.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel2.text  = formatterToCurrency.string(from: Int(calOriginalResult) as NSNumber)
                textLabel2.textAlignment = .center
                textLabel2.sizeToFit()
                textLabel2.adjustsFontSizeToFitWidth = true
                
                let textLabel3 = UILabel()
                textLabel3.backgroundColor = UIColor.yellow
                textLabel3.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel3.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel3.text  = formatterToCurrency.string(from: Int(calInterestResult) as NSNumber)
                textLabel3.textAlignment = .center
                textLabel3.sizeToFit()
                textLabel3.adjustsFontSizeToFitWidth = true
                
                let textLabel4 = UILabel()
                textLabel4.backgroundColor = UIColor.yellow
                textLabel4.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
                textLabel4.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                textLabel4.text  = formatterToCurrency.string(from: Int(loanPrice - (calOriginalResult * Double(i))) as NSNumber)
                textLabel4.textAlignment = .center
                textLabel4.sizeToFit()
                textLabel4.adjustsFontSizeToFitWidth = true
                
                //Stack View
                let stackView   = UIStackView()
                stackView.axis  = UILayoutConstraintAxis.horizontal
                stackView.distribution  = UIStackViewDistribution.fillEqually
                stackView.alignment = UIStackViewAlignment.center
                stackView.spacing   = 5.0
                
                stackView.addArrangedSubview(textLabel)
                stackView.addArrangedSubview(textLabel1)
                stackView.addArrangedSubview(textLabel2)
                stackView.addArrangedSubview(textLabel3)
                stackView.addArrangedSubview(textLabel4)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                
                resultContainer.addArrangedSubview(stackView)
            }
        }
        totalInterestResult.text = formatterToCurrency.string(from: calInterestTotalResult as NSNumber)
    }
    
    
    func loanPriceTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = loanPriceTextField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func initStatckView() {
        let subviews = resultContainer.subviews;
        
        for i in subviews {
            i.removeFromSuperview()
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


