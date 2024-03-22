import Foundation
import StoreKit

struct ContributionProduct: Hashable {
    let id: String
    let title: String
    let description: String
    var price: String?
    let numericPrice: Double
    let locale: Locale
    
    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        return nf
    }()
    
    init(product: SKProduct, blocked: Bool = true) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.locale = product.priceLocale
        self.numericPrice = Double(truncating: product.price)
        if blocked == true {
            self.price = formatter.string(from: product.price)
        }
        else {
            self.price = nil
        }
    }
}
