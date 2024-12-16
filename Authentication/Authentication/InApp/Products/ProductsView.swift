//
//  ProductsView.swift
//  Authentication
//
//  Created by Likhitha Mandapati on 10/16/24.
//

import SwiftUI

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
              ProductCellView(product: product)
                    .contextMenu {
                        Button("Add to Favorites") {
                            viewModel.addUserFavoriteProduct(productId: product.id)
                        }
                    }
                
                if product == viewModel.products.last {
                    ProgressView()
                        .onAppear {
                            viewModel.getProducts()
                        }
                }
            }
        }
        .navigationTitle("Products")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu("Filter: \(viewModel.selectedFilter?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.FilterOption.allCases, id: \.self) { filterOption in
                        Button(filterOption.rawValue) {
                            Task {
                                try? await viewModel.filterSelected(option: filterOption)
                            }
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu("Category: \(viewModel.selectedCategory?.rawValue ?? "NONE")") {
                    ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self) { categoryOption in
                        Button(categoryOption.rawValue) {
                            Task {
                                try? await viewModel.categorySelected(option: categoryOption)
                            }
                        }
                    }
                }
            }
        })
        .onAppear {
            viewModel.getProducts()
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductsView()
        }
    }
}
