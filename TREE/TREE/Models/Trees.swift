import Foundation
import FirebaseCore
protocol Tree: Identifiable, Codable, Hashable {
    var id: String { get }
    var ownerUid: String { get }
    var imageURLs: [String] { get }
    var address: String { get }
    var city: String { get }
    var state: String { get }
    var title: String { get }
    var description: String { get }
    var zipcode: String { get }
    var timeStamp: Timestamp { get }
}

// add timestamp
struct Sublets: Tree {
    let id: String
    let ownerUid: String
    let numberOfBedrooms: String
    let numberOfBathrooms: String
    let zipcode: String
    let imageURLs: [String]
    let address: String
    let city: String
    let state: String
    let shared: Bool
    let leaseStartDate: Date
    let leaseEndDate: Date
    var rentFee: Int
    let title: String
    let description: String
    let timeStamp: Timestamp
    
    var user: Users?
}

struct Stores: Tree {
    let id: String
    let ownerUid: String
    let zipcode: String
    let imageURLs: [String]
    let address: String
    let city: String
    let state: String
    var price: Int
    let productName: String // didn't use it in feed post, but will be useful for categorization
    let title: String
    let description: String
    let timeStamp: Timestamp
    
    var user: Users?
}
