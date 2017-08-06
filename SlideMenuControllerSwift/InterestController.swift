

import UIKit

extension InterestController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as! CustomCell
        
        cell.firstLabel.text = "11"//menus[indexPath.row]
        cell.secondLabel.text = "22"//images[indexPath.row]
        
        return cell
    }
}

extension InterestController: UITableViewDelegate{
    
}

class InterestController: UIViewController {
    
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
    
    
    @IBOutlet weak var tableview: UITableView!
    let menus = ["swift","tableview","example"]
    let images = ["dog1","dog2","dog3"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        originalPaymentStackView.isHidden = true;
        tableview.delegate = self
        tableview.dataSource = self
        
//        testLabel.text = "salkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjf111.salkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjf111salkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjfsalkdjfalksdfjlkasjlksdjflsdjflksadfjlksdjflksdjf111"
        
    }
}


