import Foundation
import UIKit

enum AppError: Error {
    case networkError(Error)
    case invalidResponse
}

struct Product {
    var name: String
    var imageURL: URL?
    var price: Double
}
//MARK: Closure Methods

//func fetchCategories(completion: @escaping (Result<[String], AppError>) -> Void) {
//    // Network request to fetch categories
//    // ...
//    // Call completion with result
//    completion(.success(["iOS", "macOS", "watchOS", "tvOS", "iOS Simulator"]))
//}
//
//
//func fetchProducts(category: String, completion: @escaping (Result<[Product], AppError>) -> Void) {
//    // Network request to fetch products for a category
//    // ...
//    // Call completion with result
//    let p1 = Product(name: "iPhone",
//                     imageURL: URL(string: "www.example.com/iphone.jpg") ?? nil,
//                     price: 999.0)
//    let p2 = Product(name: "MacBook Pro",
//                     imageURL: URL(string: "www.example.com/macbook.jpg") ?? nil,
//                     price: 1999.0)
//    let p3 = Product(name: "iWatch",
//                     imageURL: URL(string: "www.example.com/iwatch.jpg") ?? nil,
//                     price: 199.0)
//    let p4 = Product(name: "Apple TV",
//                     imageURL: URL(string: "www.example.com/appletv.jpg") ?? nil,
//                     price: 2299.0)
//    let p5 = Product(name: "iOS Simulator",
//                     imageURL: URL(string: "www.example.com/iosSimulator.jpg") ?? nil,
//                     price: 199.0)
//    let products: [Product] = [p1, p2, p3, p4, p5]
//    completion(.success(products))
//}
//
//
//func fetchImage(url: URL, completion: @escaping (Result<UIImage, AppError>) -> Void) {
//    // Network request to fetch image data
//    // ...
//    // Call completion with result
//    completion(.success(#imageLiteral(resourceName: "CircularDeadlock.png")))
//}


//MARK: Approach 1 Nested Clousures
//
//func displayProducts() {
//    print(Date())
//    fetchCategories { categoriesResult in
//        switch categoriesResult {
//        case .success(let categories):
//            if let firstCategory = categories.first {
//                fetchProducts(category: firstCategory) { productsResult in
//                    switch productsResult {
//                    case .success(let products):
//                        fetchImage(url: products.first!.imageURL!) { imageResult in
//                            switch imageResult {
//                            case .success(let image):
//                                print("Image Success: \(image)")
//                                print(Date())
//                            case .failure(_):
//                                 print("Image Failure")
//                            }
//                        }
//                    case .failure(let error):
//                        print("Error fetching products: \(error)")
//                    }
//                }
//            }
//        case .failure(let error):
//            print("Error fetching categories: \(error)")
//        }
//    }
//}
//
//displayProducts()


/*
func displayProducts(for category: String) {
    print(Date())
    fetchCategories { categoriesResult in
        switch categoriesResult {
        case .success(let categories):
            if let firstCategory = categories.first {
                fetchProducts(category: firstCategory) { productsResult in
                    switch productsResult {
                    case .success(let products):
                        var productsWithImages: [(Product, UIImage?)] = []
                        let group = DispatchGroup() // For concurrent image fetching

                        for product in products {
                            group.enter()
                            if let imageUrl = product.imageURL {
                                print("Product: \(product.name), Image URL: \(imageUrl) Start fetching image...")
                                fetchImage(url: imageUrl) { imageResult in
                                    switch imageResult {
                                    case .success(let image):
                                        print("Product: \(product.name), Image URL: \(imageUrl) Success fetching image...")
                                        productsWithImages.append((product, image))
                                    case .failure(_):
                                        print("Product: \(product.name), Image URL: \(imageUrl) Failure fetching image...")
                                        productsWithImages.append((product, nil)) // Use nil for failed images
                                    }
                                    group.leave()
                                }
                            } else {
                                productsWithImages.append((product, nil))
                                group.leave()
                            }
                        }

                        group.notify(queue: .main) {
                            // Display productsWithImages in the list view
                            print("Displaying products with images...")
                        }

                    case .failure(let error):
                        print("Error fetching products: \(error)")
                    }
                }
            }
        case .failure(let error):
            print("Error fetching categories: \(error)")
        }
    }
}
*/

/*
//MARK: Approach 2: Fetch Categories
func displayProducts(for category: String) {
    print("Category: \(category)")
    fetchCategories { result in
        handleCategoriesResult(completion: result)
    }
}

func handleCategoriesResult(completion: (Result<[String], AppError>)) {
    switch completion {
    case .success(let categories):
        print("Categories Success: \(categories)")
        handleProducts(categories)
    case .failure(let error):
        print("Categories Failure: \(error)")
        handleFailure(error: error)
    }
}

func handleProducts(_ categories: [String]) {
    fetchProducts(category: categories.first ?? "") { result in
        switch result {
        case .success(let products):
            print("Products Success: \(products)")
            handleFetchProductImage(products)
        case .failure(let error):
            print("Products Failure: \(error)")
            handleFailure(error: error)
        }
    }
}

func handleFetchProductImage(_ products: [Product]) {
    
    var dispatchGroup = DispatchGroup()
    
    for product in products {
        guard let url = product.imageURL else {
            print("Product \(product.name) Fetch image failed!!")
            return
        }
        dispatchGroup.enter()
        fetchImage(url: url) { result in
            dispatchGroup.leave()
            handleImageFetchResult(result: result)
        }
    }
    dispatchGroup.notify(queue: .main) {
        print("Displaying products with images... Done!")
    }
}

func handleImageFetchResult(result: Result<UIImage, AppError>) {
    
    switch result {
    case .success(let image):
        print("Image Fetch Success: \(image)")
    case .failure(let error):
        print("Image Fetch Error: \(error)")
        handleFailure(error: error)
    }
}

func handleFailure(error: AppError) {
    print("Error: \(error)")
}

displayProducts(for: "Electronics")
*/
//Drawbacks:
//
//Deeply nested closures make the code hard to read and understand.
//Error handling is scattered across multiple closures.
//Managing concurrent image fetching with DispatchGroup adds complexity.
//It's difficult to follow the sequential flow of data fetching and processing.

//MARK: Async/Await with Return as Result (Not Recommended)


//func fetchCategories() async -> Result<[String], AppError> {
//    // Simulate fetching categories
//    let success = Bool.random()
//    if success {
//        return .success(["iOS", "macOS", "watchOS"])
//    } else {
//        return .failure(AppError.invalidResponse)
//    }
//}
//
////Usage
//Task {
//    let result = await fetchCategories()
//    switch result {
//    case .success(let categories):
//        print("Categories: \(categories)")
//    case .failure(let error):
//        print("Error: \(error)")
//    }
//}

/*
Why Returning Result is Generally Not Recommended with async/await:

- Redundancy: async/await already provides built-in error handling through throws and do-catch blocks. Returning a Result type adds an extra layer of wrapping that's often unnecessary.
- Clarity: The throws mechanism makes it very clear that a function can fail. Result obscures this by requiring you to unwrap the result even in successful cases.
- Idiomatic Swift: The idiomatic way to handle errors in async/await is to use throws.
*/


//MARK: Async/Await with Return as Required Data
//func fetchCategories() async throws -> [String] {
//    // Simulate fetching categories
//    let success = Bool.random()
//    if success {
//        return ["iOS", "macOS", "watchOS"]
//    } else {
//        throw AppError.invalidResponse
//    }
//}
//
//do {
//    let categories = try await fetchCategories()
//    print("Categories: \(categories)")
//} catch {
//    print("Error: \(error)")
//}

/*
 This is the most common use case. You call functions that are marked with the async keyword.
 Because async functions can suspend execution, they must be called within an asynchronous context, and Task provides that context.
 */

//Task {
//    do {
//        let categories = try await fetchCategories()
//        print("Categories: \(categories)")
//    } catch {
//        print("Error: \(error)")
//    }
//}



//MARK: Async Await Approach

func fetchCategories() async throws -> [String] {
    let success = true//Bool.random()
    if success {
        return ["iOS", "macOS", "watchOS"]
    } else {
        throw AppError.invalidResponse
    }
}

func fetchProducts(category: String? = nil) async throws -> [Product] {
    let p1 = Product(name: "iPhone",
                     imageURL: URL(string: "www.example.com/iphone.jpg") ?? nil,
                     price: 999.0)
    let p2 = Product(name: "MacBook Pro",
                     imageURL: URL(string: "www.example.com/macbook.jpg") ?? nil,
                     price: 1999.0)
    let p3 = Product(name: "iWatch",
                     imageURL: URL(string: "www.example.com/iwatch.jpg") ?? nil,
                     price: 199.0)
    let p4 = Product(name: "Apple TV",
                     imageURL: URL(string: "www.example.com/appletv.jpg") ?? nil,
                     price: 2299.0)
    let p5 = Product(name: "iOS Simulator",
                     imageURL: URL(string: "www.example.com/iosSimulator.jpg") ?? nil,
                     price: 199.0)
    let products: [Product] = [p1, p2, p3, p4, p5]
    try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
    return products
}

func fetchImage(url: URL? = nil) async throws -> UIImage {
    
    try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
    return #imageLiteral(resourceName: "CircularDeadlock.png")
}


func displayProducts() async {
    do {
        let category = try await fetchCategories()
        //update UI
        let product = try await fetchProducts(category: category.first!)
        let image = try await fetchImage(url: product.first!.imageURL!)
        print("Category: \(category.first!)")
        print("Product: \(product.first!)")
        print("Image: \(image)")
        
    } catch (let error) {
        print(error)
    }
}

//func displayProducts() async {
//    do {
//        async let category = fetchCategories()
//        async let product = fetchProducts()
//        async let image = fetchImage()
//
//        let (categoryResult, productResult, imageResult) = try await (category, product, image)
//        print("Final Category: \(categoryResult.first!)")
//        print("Final Product: \(productResult.first!)")
//        print("Final Image: \(imageResult)")
//        
//    } catch (let error) {
//        print(error)
//    }
//}


Task {
    //show loder
    print(Date())
    await displayProducts()
    await MainActor.run {
        //hide loader
        print("update UI")
        print(Date())
    }
}

func displayProducts() {
        
//        let categoryTask = Task {
//            try await fetchCategories()
//        }
//        
//        let productTask = Task {
//            try await fetchProducts()
//        }
//        
//        let imageTask = Task {
//            try await fetchImage()
//        }
//
        Task {
            let categoryFinal = try await fetchCategories()
            print("category fetched: \(categoryFinal), Time: \(Date())")
        }
        Task {
            let productFinal = try await fetchProducts()
            print("product fetched: \(productFinal), Time: \(Date())")
        }
        Task {
            let imageFinal = try await fetchImage()
            print("image fetched: \(imageFinal), Time: \(Date())")
        }
}

func callConcurrentOperationStreaming() {
    print("Concurrent (streaming results) operation started.")
    
    displayProducts()
    print("Concurrent (streaming results) operation completed.")
}

callConcurrentOperationStreaming()

//
func displayProductsWithCompletionAsyncLet() async {
    print("--- Concurrent operations started ---")

    async let categoryResult = Task {
        try await fetchCategories()
    }.value

    async let productResult = Task {
        try await fetchProducts()
    }.value

    async let imageResult = Task {
        try await fetchImage()
    }.value

    do {
        let categoryFinal = try await categoryResult
        print("category fetched: \(categoryFinal), Time: \(Date())")

        let productFinal = try await productResult
        print("product fetched: \(productFinal), Time: \(Date())")

        let imageFinal = try await imageResult
        print("image fetched: \(imageFinal), Time: \(Date())")

        print("--- All concurrent operations completed ---")
    } catch {
        print("Error in concurrent operations: \(error)")
    }
}

func callConcurrentOperationWithCompletionAsyncLet() {
    print("Concurrent operation initiated.")
    Task {
        MainActor.run {
            
        }
        await displayProductsWithCompletionAsyncLet()
        print("Outer task completed after all inner operations.")
    }
}

callConcurrentOperationWithCompletionAsyncLet()
