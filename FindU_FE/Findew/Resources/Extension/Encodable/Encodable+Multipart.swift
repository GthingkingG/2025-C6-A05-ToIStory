//
//  Encodable+Multipart.swift
//  Findew
//
//  Created by 내꺼다 on 10/30/25.
//

import Foundation
import Moya

extension HospitalRouter {
    
    /// 공통 멀티파트
    func makeMultipartData<T: ReportsData>(for request: T) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        
        if let inquiry = request as? HospitalInquiryRequest {
            if let contentData = inquiry.content.data(using: .utf8) {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(contentData),
                        name: "content"
                    )
                )
            }

            if let emailData = inquiry.email.data(using: .utf8) {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(emailData),
                        name: "email"
                    )
                )
            }
        }
        
        if let images = request.images {
            for (index, imageData) in images.enumerated() {
                let imagePart = MultipartFormData(
                    provider: .data(imageData),
                    name: "images",
                    fileName: "image\(index).jpg",
                    mimeType: "image/jpeg"
                )
                multipartData.append(imagePart)
            }
        }
        
        return multipartData
    }
}
