import Foundation
import StoreKit

typealias FetchCompleteHandler = (([SKProduct]) -> Void)
typealias PurchasesCompleteHandler = ((SKPaymentTransaction) -> Void)

class TipsViewModel: NSObject, ObservableObject {
    @Published var allProducts = [ContributionProduct]()
    @Published var purchaseInProgress = false
    @Published var failedPurchase = false
    @Published var successfulPurchase = false
    
    private let allIdentifiers = Set([
        "com.jgeek00.ServerStatus.SmallContribution",
        "com.jgeek00.ServerStatus.MediumContribution",
        "com.jgeek00.ServerStatus.BigContribution",
        "com.jgeek00.ServerStatus.VeryBigContribution",
        "com.jgeek00.ServerStatus.GloriousContribution"
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
        let invalidProductos = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else{
            print("No se pueden cargar los productos")
            if !invalidProductos.isEmpty {
                print("productos invalidos encontrados: \(invalidProductos)")
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
                    self.purchaseInProgress = false
                    finishTransaction = true
                case .failed:
                    self.failedPurchase = true
                    self.purchaseInProgress = false
                    finishTransaction = true
                case .deferred, .purchasing:
                    self.purchaseInProgress = true
                    break
                @unknown default:
                    self.purchaseInProgress = false
                    break
            }
            
            if finishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchasesCompleteHandler?(transaction)
                    self.purchasesCompleteHandler = nil
                }
            }
            
            DispatchQueue.main.async {
                self.purchaseInProgress = false
            }
        }
    }
}

extension TipsViewModel {
    func product(for identifier: String) -> SKProduct? {
        return fetchedProductos.first(where: { $0.productIdentifier == identifier })
    }
    
    func purchaseProduct(product: SKProduct){
        startObservingPayment()
        buy(product) { _ in }
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

