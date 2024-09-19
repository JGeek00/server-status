import StoreKit
import SwiftUI
import Combine

final class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, @unchecked Sendable {    
    @Published var products = [SKProduct]()
    @Published var purchaseState: PurchaseState = .idle
    
    // Alerts
    @Published var successfulPurchase = false
    @Published var purchaseInProgress = false
    @Published var failedPurchase = false
    
    private var productRequest: SKProductsRequest?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts() {
        productRequest = SKProductsRequest(productIdentifiers: iapIds)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        Task { @MainActor in
            self.products = response.products.sorted(by: { a, b in
                a.price.doubleValue < b.price.doubleValue
            })
        }
    }

    func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            Task { @MainActor in
                self.purchaseState = .failed(message: "User cannot make payments")
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .failed:
                failedTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
            default:
                break
            }
        }
    }

    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        Task { @MainActor in
            print("Purchase successful for product: \(transaction.payment.productIdentifier)")
            self.purchaseState = .successful
            self.purchaseInProgress = false
            self.successfulPurchase = true
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        Task { @MainActor in
            if let error = transaction.error as NSError? {
                print("Transaction failed with error: \(error.localizedDescription)")
                self.purchaseState = .failed(message: error.localizedDescription)
                self.purchaseInProgress = false
                self.failedPurchase = true
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restoreTransaction(_ transaction: SKPaymentTransaction) {
        Task { @MainActor in
            print("Restored transaction for product: \(transaction.payment.productIdentifier)")
            self.purchaseState = .restored
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

enum PurchaseState {
    case idle
    case successful
    case failed(message: String)
    case restored
}
