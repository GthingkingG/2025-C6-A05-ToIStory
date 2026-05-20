//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import VaporToOpenAPI

struct ReportController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let reports = routes.grouped("api", "reports")
        let protected = reports.grouped(JWTMiddleware())
        
        protected.on(.POST, "inquiry", body: .collect(maxSize: "10mb"), use: submitInquiry)
            .openAPI(
                tags: TagObject(name: TagObjectValue.report),
                summary: "문의/신고 접수",
                description: """
                 병원 시스템 관련 문의나 신고를 접수합니다.
                 
                 **Content-Type:** `multipart/form-data`
                 
                 **Form Fields:**
                 ```
                 content  : string   (required) - 문의 내용
                 email    : string   (required) - 이메일 주소
                 images   : file[]   (optional) - 이미지 파일들
                 ```
                 
                 **cURL 예시:**
                 ```bash
                 curl -X POST http://localhost:8080/api/reports/inquiry \\
                   -H "Authorization: Bearer YOUR_TOKEN" \\
                   -F "type=INQUIRY" \\
                   -F "content=문의 내용입니다" \\
                   -F "email=test@example.com" \\
                   -F "images=@image1.jpg" \\
                   -F "images=@image2.jpg"
                 ```
                 
                 **인증 필요:** Bearer Token
                 """,
                body: .type(of: InquiryRequest(
                      content: "문의 내용 예시",
                      email: "user@example.com",
                      images: nil
                  )),
                contentType: .multipart(.formData),
                response: .type(CommonResponseDTO<ReportDTO>.self)
            )
    }
    
    func submitInquiry(_ req: Request) async throws -> CommonResponseDTO<ReportDTO> {
        let sessionToken = try req.requireAuth()
        
        // 요청 정보 로깅
        req.logger.info("[Inquiry] Start processing")
        req.logger.info("[Inquiry] Content-Type: \(req.headers.contentType?.serialize() ?? "unknown")")
        if let bodySize = req.body.data?.readableBytes {
            req.logger.info("[Inquiry] Body size: \(bodySize) bytes")
        }
        
        // 필수 필드 파싱
        let content = try parseRequiredField(req, key: "content", fieldName: "content")
        let email = try parseRequiredField(req, key: "email", fieldName: "email")
        
        // 이미지 파싱 (선택)
        let images = parseImages(from: req)
        req.logger.info("[Inquiry] Parsed - content: '\(content)', email: '\(email)', images: \(images.count)")
        
        // S3 업로드
        let imageUrls = try await uploadImages(images, to: req)
        
        // 데이터베이스 저장
        let reportService = req.di.makeReportService(request: req)
        let report = try await reportService.submitInquiry(
            hospitalId: sessionToken.hospitalId,
            content: content,
            email: email,
            images: imageUrls
        )
        try await report.$images.load(on: req.db)
        
        req.logger.info("[Inquiry] Success - Report ID: \(report.id?.uuidString ?? "unknown")")
        
        let result = ReportDTO(from: report)
        return CommonResponseDTO.success(
            code: ResponseCode.CREATED201,
            message: "문의가 성공적으로 접수되었습니다.",
            result: result
        )
    }

    
    private func parseRequiredField(_ req: Request, key: String, fieldName: String) throws -> String {
          do {
              return try req.content.get(String.self, at: key)
          } catch {
              req.logger.error("[Inquiry] Failed to parse '\(fieldName)': \(error)")
              throw Abort(.badRequest, reason: "\(fieldName) 필드가 필요합니다.")
          }
      }

      private func parseImages(from req: Request) -> [File] {
          // 방법 1: [File] 배열로 시도
          if let parsedImages = try? req.content.get([File].self, at: "images") {
              req.logger.info("[Inquiry] Parsed images as [File] array: \(parsedImages.count) files")
              return parsedImages
          }

          // 방법 2: 단일 File로 시도
          if let singleImage = try? req.content.get(File.self, at: "images") {
              req.logger.info("[Inquiry] Parsed images as single File")
              return [singleImage]
          }

          // 방법 3: Data로 시도
          if let imageData = try? req.content.get(Data.self, at: "images") {
              req.logger.info("[Inquiry] Parsed images as Data: \(imageData.count) bytes")
              return [File(data: ByteBuffer(data: imageData), filename: "image.jpg")]
          }

          // 파싱 실패 - 디버깅 정보 출력
          req.logger.warning("[Inquiry] Failed to parse images field")
          if let allFields = try? req.content.decode([String: String].self) {
              req.logger.info("[Inquiry] Available string fields: \(allFields.keys.joined(separator: ", "))")
          }

          return []
      }

      private func uploadImages(_ images: [File], to req: Request) async throws -> [String] {
          guard !images.isEmpty else {
              req.logger.info("[Inquiry] No images to upload")
              return []
          }

          req.logger.info("[Inquiry] Uploading \(images.count) image(s) to S3")
          let s3Service = req.di.makeS3Service(request: req)
          var imageUrls: [String] = []

          for (index, image) in images.enumerated() {
              let data = Data(buffer: image.data)
              req.logger.info("[Inquiry] Uploading [\(index + 1)/\(images.count)]: \(image.filename) (\(data.count) bytes)")

              let imageUrl = try await s3Service.uploadImage(
                  data: data,
                  filename: image.filename,
                  folder: "Inquiries"
              )
              imageUrls.append(imageUrl)
              req.logger.info("[Inquiry] Uploaded [\(index + 1)]: \(imageUrl)")
          }

          return imageUrls
      }
}
