//
//  ReportInquiry.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import SwiftUI
import PhotosUI

struct ReportInquiry: View {
    
    // MARK: - Property
    @State var viewModel: ReportInquiryViewModel
    @Environment(\.dismiss) var dismiss
    
    fileprivate enum ReportInquiryConstant {
        static let mainVspacing: CGFloat = 20
        static let fieldPadding: CGFloat = 10
        static let fieldVspacing: CGFloat = 12
        static let imageSpacing: CGFloat = 20
        
        static let imageFrameSize: CGSize = .init(width: 104, height: 104)
        
        static let cornerRadius: CGFloat = 8
        static let imagePadding: CGFloat = 2
        static let imageOffset: CGFloat = 5
        
        static let sendTitle: String = "보내기"
        static let cancelTitle: String = "취소"
        static let cameraImage: String = "camera.on.rectangle"
        static let photo: String = "photo"
        static let xmark: String = "xmark"
    }
    
    // MARK: - Init
    init(contactType: ContactType, container: DIContainer) {
        self.viewModel = .init(contactType: contactType, container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, content: {
            middleContents
            Spacer()
            
        })
        .onChange(of: viewModel.selectedImages, {
            viewModel.loadImage()
        })
        .safeAreaBar(edge: .bottom, alignment: .leading, content: {
            bottomImage
        })
        .safeAreaBar(edge: .top, spacing: ReportInquiryConstant.mainVspacing, content: {
            topContents
        })
        .safeAreaBar(edge: .bottom, alignment: .trailing, content: {
            PhotosPicker(
                selection: $viewModel.selectedImages,
                maxSelectionCount: 5,
                matching: .images,
                photoLibrary: .shared()) {
                    Image(systemName: ReportInquiryConstant.photo)
                        .font(.system(size: 30))
                        .foregroundStyle(.blue03)
                        .padding(ReportInquiryConstant.fieldPadding)
                }
                .padding(.vertical, 10)
                .glassEffect(.regular, in: .circle)
        })
        .safeAreaPadding(.horizontal, DefaultConstants.defaultHorizonPadding)
        .safeAreaPadding(.vertical, DefaultConstants.defaultVerticalPadding)
    }
    
    // MARK: - TopContents
    /// 상단 컨트롤 영역
    private var topContents: some View {
        ZStack {
            topController
            topTitle
        }
    }
    
    ///  상단 문의 및 신고 타이틀
    private var topTitle: some View {
        Text(viewModel.contactType.rawValue)
            .font(.b2)
            .foregroundStyle(.black)
    }
    
    /// 취소 및 보내기 버튼
    private var topController: some View {
        HStack {
            Button("취소", role: .cancel,  action: {
                dismiss()
            })
            .buttonStyle(.glass)
            
            Spacer()
            
            Button(ReportInquiryConstant.sendTitle, action: {
                viewModel.summitInquiry {
                    dismiss()
                }
            })
            .buttonStyle(.glass)
        }
    }
    
    // MARK: - Middle
    /// 중간 컨텐츠
    private var middleContents: some View {
        VStack(spacing: ReportInquiryConstant.fieldVspacing, content: {
            if viewModel.contactType == .inquiry {
                emailField
                Divider()
            }
            
            contentField
        })
        .safeAreaPadding(.horizontal, ReportInquiryConstant.fieldPadding)
    }
    
    /// 이메일 작성 필드(문의 시 동작)
    private var emailField: some View {
        TextField("", text: Binding(get: { viewModel.email ?? "" },
                                    set: { viewModel.email = $0 }), prompt: placeholder(idx: .zero, font: .b3))
        .font(.h4)
        .foregroundStyle(.black)
    }
    
    /// 신고 내용 작성
    private var contentField: some View {
        TextField("", text: $viewModel.content, prompt: placeholder(idx: viewModel.contactType == .inquiry ? 1 : 0, font: .b3), axis: .vertical)
            .font(.b3)
            .foregroundStyle(.black)
    }
    
    /// 텍스트 필드 내부 placeholder
    /// - Parameters:
    ///   - idx: placeholder 인덱스(0,1)
    ///   - font: placeholder 폰트
    /// - Returns: plceholder 반환
    private func placeholder(idx: Int, font: Font) -> Text {
        Text(viewModel.contactType.placeholder[idx])
            .font(font)
            .foregroundStyle(.gray03)
    }
    
    // MARK: - Bottom
    /// 하단 선택된 이미지 + 삭제 버튼
    private var bottomImage: some View {
        HStack(spacing: ReportInquiryConstant.imageSpacing, content: {
            ForEach(viewModel.displayedImage.enumerated(), id: \.offset) { index, image in
                ZStack(alignment: .topTrailing, content: {
                    displayImage(image: image)
                    deleteBtn(idx: index)
                })
            }
        })
    }
    
    /// 선택 이미지 뷰
    /// - Parameter image: 선택한 이미지
    /// - Returns: 이미지 뷰 반환
    private func displayImage(image: UIImage) ->  some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: ReportInquiryConstant.imageFrameSize.width, height: ReportInquiryConstant.imageFrameSize.height)
            .clipShape(.rect(cornerRadius: ReportInquiryConstant.cornerRadius, style: .continuous))
    }
    
    /// 이미지 삭제 버튼
    /// - Parameter idx: 선택한 이미지 삭제
    /// - Returns: 삭제 버튼
    private func deleteBtn(idx: Int) -> some View {
        Button(action: {
            withAnimation {
                viewModel.removeImage(at: idx)
            }
        }, label: {
            Image(systemName: ReportInquiryConstant.xmark)
                .padding(ReportInquiryConstant.imagePadding)
        })
        .clipShape(.circle)
        .buttonStyle(.glass)
        .offset(y: ReportInquiryConstant.imageOffset)
    }
}

#Preview {
    ReportInquiry(contactType: .inquiry, container: DIContainer())
}
