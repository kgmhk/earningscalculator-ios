
import Foundation

enum CommissionSelecteStatus: Int {
    case Deal = 1
    case Lease
    case Month
}

enum InterestSelecteStatus: Int {
    case originalPriceEqual = 1
    case principalAndInterest
    case expiryDateOfPrincipalMaturity
}

enum TypeOfAccountStatus: Int {
    case deposit = 1
    case installmentSavings
}

enum TypeOfInterest: Int {
    case simpleInterest = 1
    case compoundInteres
}
