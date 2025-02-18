//
//  ProductCellViewBuilder.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/29/24.
//

import SwiftUI

struct ProductCellViewBuilder: View {
    
    let productId: String
    @State private var product: Product? = nil
    
    var body: some View {
        ZStack {
            if let product = product {
                ProductCellView(product: product)
            }
        }
        .task {
            self.product = try? await ProductManager.shared.getProduct(productId: productId)
        }
    }
}

struct ProductCellViewBuilder_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellViewBuilder(productId: "1")
    }
}
