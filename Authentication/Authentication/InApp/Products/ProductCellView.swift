//
//  ProductCellView.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/17/24.
//

import SwiftUI

struct ProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 75, height: 75)
            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Price: $" + String(product.price))
                Text("Rating: " + String(product.rating))
                Text("Category: " + (product.category))
                Text("Brand: " + (product.brand ?? ""))
            }
            .font(.callout)
            .foregroundColor(.secondary)
        }
    }
}

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCellView(product: Product(id: 1, title: "aaa", description: "bbb", price: 123, discountPercentage: 123, rating: 1, stock: 12, brand: "ccc", category: "ddd", thumbnail: "eee", images: []))
    }
}
