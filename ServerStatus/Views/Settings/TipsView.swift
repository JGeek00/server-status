import SwiftUI

struct TipsView: View {
    @EnvironmentObject private var tipsModel: TipsViewModel
    
    var body: some View {
        Group {
            if tipsModel.allProducts.isEmpty {
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
                    Section("A message from the developer") {
                        Text("Hi! I'm the developer of Server Status.\nServer Status is free and I want it to remain free, but by offering this application on the App Store I run into some costs, such as Apple's developer license. I would appreciate a lot every donation to help me paying this costs.\nThank you.")
                        
                    }
                    Section("Donation options") {
                        ForEach($tipsModel.allProducts, id: \.self) { item in
                            TipItem(contributionProduct: item.wrappedValue) {
                                if let product = tipsModel.product(for: item.wrappedValue.id) {
                                    tipsModel.purchaseProduct(product: product)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Tips")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if tipsModel.purchaseInProgress {
                    ProgressView()
                }
            }
        }
        .alert("Purchase failed or cancelled", isPresented: $tipsModel.failedPurchase) {} message: {
            Text("The purchase could not be completed. An error occured on the process or it has been cancelled by the user.")
        }.alert("Purchase completed successfully", isPresented: $tipsModel.successfulPurchase) {} message: {
            Text("The purchase has been completed. Thank you for contributing with the development and mantenience of this application.")
        }

    }
}

private struct TipItem: View {
    let contributionProduct: ContributionProduct
    let action: () -> Void
    
    @EnvironmentObject private var tipsModel: TipsViewModel
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(contributionProduct.title)
                    .foregroundColor(.foreground)
                Spacer()
                if let price = contributionProduct.price {
                    Text(price)
                }
            }
        }
        .disabled(tipsModel.purchaseInProgress)
    }
}

#Preview {
    TipsView()
}
