//
//  PatientUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

class PatientUseCase: PatientUseCaseProtocol {
    private let service: PatientServiceProtocol

    init(service: PatientServiceProtocol = PatientService()) {
        self.service = service
    }

    /// 환자 전체 조회
    func executeGetList() -> AnyPublisher<ResponseData<[PatientDTO]>, MoyaError> {
        service.getList()
    }

    /// 환자 삭제
    func executeDeletePatient(path: PatientDeletPath) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        service.deletePatient(path: path)
    }

    /// 환자 등록
    func executePostGenerate (generate: PatientGenerateRequest) -> AnyPublisher<ResponseData<PatientGenerateResponse>, MoyaError> {
        service.postGenerate(generate: generate)
    }

    /// 환자 수정
    func executePutUpdate(path: PatientUpdatePath, update: PatientUpdateRequest) -> AnyPublisher<ResponseData<PatientGenerateResponse>, MoyaError> {
        service.putUpdate(path: path, update: update)
    }

    /// 환자 상세 조회
    func executeGetDetail(path: PatientDetailPath) -> AnyPublisher<ResponseData<PatientDTO>, MoyaError> {
        service.getDetail(path: path)
    }
}
