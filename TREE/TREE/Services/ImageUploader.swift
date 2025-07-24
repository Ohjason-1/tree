//
//  ProfileService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/18/25.
//

import FirebaseStorage
import UIKit

struct ImageUploader {
    
    func uploadImage(_ image: UIImage) async throws -> String? {
        // 0.1 for profile, 0.5 for feed
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return  nil } // smaller quality -> worse quality but smaller filesize
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        let _ = try await ref.putDataAsync(imageData)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
    
    func uploadPostImage(_ images: [UIImage]) async throws -> [String]? {
        // 0.1 for profile, 0.5 for feed
        var result = [String]()
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return  nil } // smaller quality -> worse quality but smaller filesize
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            result.append(url.absoluteString)
        }
        return result
        
    }
}
