//
//  HospitalUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

class HospitalUseCase: HospitalUseCaseProtocol {
    private let service: HospitalServiceProtocol
    
    init(service: HospitalServiceProtocol = HospitalService()) {
        self.service = service
    }
    
    /// 앱 문의
    func executePostUnquiry(inquiry: HospitalInquiryRequest) -> AnyPublisher<ResponseData<HospitalDTO>, MoyaError> {
        service.postInquiry(inquiry: inquiry)
    }
}
