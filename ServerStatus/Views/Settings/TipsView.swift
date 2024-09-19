import SwiftUI
import StoreKit

struct TipsView: View {
    @EnvironmentObject private var iapManager: IAPManager
    
    var body: some View {
        Group {
            if iapManager.products.isEmpty {
                VStack {
                    Image(systemName: "nosign")
                        .font(.system(size: 40))
                    Spacer().frame(height: 20)
                    Text("Currently there are no options available.")
                        .font(.system(size: 24))
                        .multilineTextAlignment(.center)
                }
            }
            else {
                List {
                    Section {
                        ForEach($iapManager.products, id: \.self) { item in
                            Item(product: item.wrappedValue) {
                                iapManager.purchase(product: item.wrappedValue)
                            }
                        }
                    } header: {
                        Text("Hi! I'm the developer of Server Status.\nServer Status is free and I want it to remain free, but by offering this application on the App Store I run into some costs, such as Apple's developer license. I would appreciate a lot every donation to help me paying this costs.\nThank you.")
                            .padding(.bottom, 12)
                            .textCase(nil)
                    }
                }
            }
        }
        .navigationTitle("Tips")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if iapManager.purchaseInProgress {
                    ProgressView()
                }
            }
        }
        .alert("Purchase failed or cancelled", isPresented: $iapManager.failedPurchase) {} message: {
            Text("The purchase could not be completed. An error occured on the process or it has been cancelled by the user.")
        }.alert("Purchase completed successfully", isPresented: $iapManager.successfulPurchase) {} message: {
            Text("The purchase has been completed. Thank you for contributing with the development and mantenience of this application.")
        }

    }
}

fileprivate struct Item: View {
    let product: SKProduct
    let action: () -> Void
    
    @EnvironmentObject private var iapManager: IAPManager
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(product.localizedTitle)
                    .foregroundColor(.foreground)
                Spacer()
                if let currency = product.priceLocale.currencySymbol {
                    Text("\(product.price.stringValue) \(String(describing: currency))")
                }
                else {
                    Text(String(describing: "N/A"))
                }
            }
        }
        .disabled(iapManager.purchaseInProgress)
    }
}
