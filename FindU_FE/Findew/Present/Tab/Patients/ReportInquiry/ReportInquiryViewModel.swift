//
//  ReportInquiryViewModel.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

@Observable
class ReportInquiryViewModel {
    var email: String?
    var content: String = ""
    var contactType: ContactType
    
    var selectedImages: [PhotosPickerItem] = []
    var displayedImage: [UIImage] = []
    var imageData: Data?
    
    var isLoading: Bool = false
    
    // MARK: - Dependency
    private let container: DIContainer
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(contactType: ContactType, container: DIContainer) {
        self.contactType = contactType
        self.container = container
    }
    
    func loadImage() {
        guard !selectedImages.isEmpty else { return }
        
        Task {
            var loadedImages: [UIImage] = []
            
            for item in selectedImages {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    loadedImages.append(uiImage)
                }
            }
            
            await MainActor.run {
                self.displayedImage = loadedImages
            }
        }
    }
    
    func removeImage(at index: Int) {
        guard index < displayedImage.count else { return }
        displayedImage.remove(at: index)
        
        if index < selectedImages.count {
            selectedImages.remove(at: index)
        }
    }
    
    func removeAllImages() {
        selectedImages.removeAll()
        displayedImage.removeAll()
    }
    
    // MARK: - API Method
    /// 문의/신고 API 호출
    func summitInquiry(completion: @escaping () -> Void) {
        isLoading = true
        
        let imageDataArray: [Data]? = displayedImage.isEmpty ? nil : displayedImage.compactMap { image in
            // 1.0 압축 없음, 0.5 중간
            image.jpegData(compressionQuality: 0.8)
        }
        
        let request = HospitalInquiryRequest(
            content: content,
            email: email ?? "",
            images: imageDataArray
        )
        
        container.usecaseProvider.hospitalUseCase
            .executePostUnquiry(inquiry: request)
            .validateResult()
            .sink{ [weak self] completion in
                guard let self else { return }
                
                defer { self.isLoading = false }
                switch completion {
                case .finished:
                    Logger.logDebug("문의/신고 제출", "요청 완료 (finished)")
                case .failure(let error):
                    Logger.logError("문의/신고 제출", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                Logger.logDebug("문의/신고 제출", "성공: \(result)")
                completion()
            }
            .store(in: &cancellables)
    }
}
