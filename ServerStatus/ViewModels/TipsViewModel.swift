import Foundation
import StoreKit
import Sentry

typealias FetchCompleteHandler = (([SKProduct]) -> Void)
typealias PurchasesCompleteHandler = ((SKPaymentTransaction) -> Void)

class TipsViewModel: NSObject, ObservableObject {
    @Published var allProducts = [ContributionProduct]()
    @Published var purchaseInProgress = false
    @Published var failedPurchase = false
    @Published var successfulPurchase = false
    
    private let allIdentifiers = Set([
        "com.jgeek00.ServerStatus.SmallTip",
        "com.jgeek00.ServerStatus.MediumTip",
        "com.jgeek00.ServerStatus.BigTip",
        "com.jgeek00.ServerStatus.VeryBigTip",
        "com.jgeek00.ServerStatus.GloriousTip"
    ])

    private var productsRequest: SKProductsRequest?
    private var fetchedProductos = [SKProduct]()
    private var fetchCompleteHandler : FetchCompleteHandler?
    private var purchasesCompleteHandler : PurchasesCompleteHandler?
    
    
    override init(){
        super.init()
        startObservingPayment()
        fetchProducts { products in
            self.allProducts = products.map() {
                ContributionProduct(product: $0)
            }.sorted(by: { a, b in
                a.numericPrice < b.numericPrice
            })
        }
    }
    
    private func startObservingPayment() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompleteHandler){
        guard self.productsRequest == nil else { return }
        fetchCompleteHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: allIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy(_ product: SKProduct, completion: @escaping PurchasesCompleteHandler){
        purchasesCompleteHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension TipsViewModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else{
            if !invalidProducts.isEmpty {
                SentrySDK.capture(message: "Cannot load products: \(invalidProducts)")
                print("Cannot load products: \(invalidProducts)")
            }
            productsRequest = nil
            return
        }
        
        fetchedProductos = loadedProducts
        DispatchQueue.main.async {
            self.fetchCompleteHandler?(loadedProducts)
            self.fetchCompleteHandler = nil
            self.productsRequest = nil
        }
        
    }
}

extension TipsViewModel : SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var finishTransaction = false
            switch transaction.transactionState {
                case .purchased, .restored:
                    self.successfulPurchase = true
                    finishTransaction = true
                case .failed:
                    self.failedPurchase = true
                    finishTransaction = true
                case .deferred, .purchasing:
                    break
                @unknown default:
                    break
            }
            
            if finishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseInProgress = false
                    self.purchasesCompleteHandler?(transaction)
                    self.purchasesCompleteHandler = nil
                }
            }
        }
    }
}

extension TipsViewModel {
    func product(for identifier: String) -> SKProduct? {
        return fetchedProductos.first(where: { $0.productIdentifier == identifier })
    }
    
    func purchaseProduct(product: SKProduct){
        self.purchaseInProgress = true
        startObservingPayment()
        buy(product) { _ in }
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

