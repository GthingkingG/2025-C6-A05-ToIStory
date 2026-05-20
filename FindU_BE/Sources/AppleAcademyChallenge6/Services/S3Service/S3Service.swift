//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import SotoS3
import NIOCore

final class S3Service: Sendable {
    let client: AWSClient
    let s3: S3
    let bucket: String
    
    init(app: Application) {
        self.client = AWSClient(
            credentialProvider: .static(
                accessKeyId: Environment.get(EnvironmentValue.S3Key) ?? "",
                secretAccessKey: Environment.get(EnvironmentValue.S3AccessKey) ?? ""
            ),
            httpClient: app.http.client.shared
        )
        
        self.s3 = S3(client: client, region: .apnortheast2)
        self.bucket = Environment.get(EnvironmentValue.S3Bucket) ?? ""
    }
    
    func uploadImage(data: Data, filename: String, folder: String) async throws -> String {
        let fileExtension = (filename as NSString).pathExtension
        let uniqueFilename = "\(UUID().uuidString).\(fileExtension)"
        let key = "\(folder)/\(uniqueFilename)"
        
        let buffer = ByteBuffer(data: data)
        let putRequest = S3.PutObjectRequest(
            body: .init(buffer: buffer),
            bucket: bucket,
            contentType: contentType(for: fileExtension),
            key: key
        )
        
        _ = try await s3.putObject(putRequest)
        
        return "https://\(bucket).s3.ap-northeast-2.amazonaws.com/\(key)"
    }
    
    private func contentType(for fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "gif":
            return "image/gif"
        case "webp":
            return "image/webp"
        default:
            return "application/octet-stream"
        }
    }
    
    deinit {
        try? client.syncShutdown()
    }
}
