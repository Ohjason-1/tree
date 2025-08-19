//
//  DeveloperPreview.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation
import FirebaseCore

class DeveloperPreview {
    
    static let shared = DeveloperPreview()
    
    var user: Users = Users(uid: "T7MJJoZBPEVio2gjr7vFDJZnJkX2", email: "J2@gmail.com", userName: "Bob2", phoneNumber: "1231231", userImageUrl: "Profile", state: "California", city: "Berkeley")
    
    let message: Messages = Messages(messageId: "OIuGpNNjVV2N6HBVjlTC", fromId: "T7MJJoZBPEVio2gjr7vFDJZnJkX2", toId: "hn2l21rN2KgbjX1bXtcr0jO1qSo1", messageText: "Hoya?", timeStamp: Timestamp(), badge: 2)
    
    let recentMessages: [Messages] = [
        .init(messageId: "OIuGpNNjVV2N6HBVjlTC",
              fromId: "T7MJJoZBPEVio2gjr7vFDJZnJkX2",
              toId: "hn2l21rN2KgbjX1bXtcr0jO1qSo1",
              messageText: "Hoya?",
              timeStamp: Timestamp()
             ),
        .init(messageId: "OIuGpNNjVV2N6HBVjlTC",
              fromId: "T7MJJoZBPEVio2gjr7vFDJZnJkX2",
              toId: "hn2l21rN2KgbjX1bXtcr0jO1qSo1",
              messageText: "Hoya?",
              timeStamp: Timestamp()
             ),
        
    ]
    
    
    // MARK: - mock sublets
    
    
    var sublets: [Sublets] = [
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image2", "Image", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image1", "Image", "Image2"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image", "Image2", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image2", "Image", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image", "Image1", "Image2"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            numberOfBedrooms: "1",
            numberOfBathrooms: "1",
            zipcode: "94704",
            imageURLs: ["Image", "Image1", "Image2"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            shared: true,
            leaseStartDate: Date(),
            leaseEndDate: Date(),
            rentFee: 1500,
            title: "Cozy 2BR/1BA Apartment in Berkeley",
            description: "Welcome to our bright and spacious 2-bedroom, 1-bathroom apartment located just 10 minutes from UC Berkeley campus!, rent fee and lease terms are negotiable",
            timeStamp: Timestamp()
        )
    ]
    // MARK: - mock store products
    var stores: [Stores] = [
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "stunning 65-inch 4K Smart TV 📺 featuring vibrant colors 🌈 and crystal-clear picture quality! 💎🔥🏠",
            description: "Bought this for $130, 5 months ago. Selling this $50 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "Cheap TV",
            description: "stunning 65-inch 4K Smart TV 📺 featuring vibrant colors 🌈 and crystal-clear picture quality! 💎🔥🏠",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "Cheap TV",
            description: "stunning 65-inch 4K Smart TV 📺 featuring vibrant colors 🌈 and crystal-clear picture quality! 💎🔥🏠",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "Cheap TV",
            description: "Bought this for $130, 5 months ago. Selling this $50 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "Cheap TV",
            description: "Bought this for $130, 5 months ago. Selling this $50 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image3", "Image3", "Image3"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 80,
            productName: "Television",
            title: "Cheap TV",
            description: "Bought this for $130, 5 months ago. Selling this $50 cheaper than original price!",
            timeStamp: Timestamp()
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            zipcode: "94704",
            imageURLs: ["Image4", "Image4", "Image1"],
            address: "2520 Hillegass Ave",
            city: "Berkeley",
            state: "California",
            price: 20,
            productName: "Microwave",
            title: "Cheap Microwave",
            description: "Bought this for $100, 3 months ago. Selling this $80 cheaper than original price!",
            timeStamp: Timestamp()
        ),
    ]
}
