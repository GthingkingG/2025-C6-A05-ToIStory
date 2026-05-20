//
//  PatientService.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

class PatientService: PatientServiceProtocol, BaseAPIService {
    
    
    typealias Target = PatientRouter
    
    var provider: MoyaProvider<Target>
    var decoder: JSONDecoder
    var callbackQueue: DispatchQueue
    
    init(
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = APIManager.shared.createProvider(for: Target.self)
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func getList() -> AnyPublisher<ResponseData<[PatientDTO]>, MoyaError> {
        request(.getList)
    }
    
    func deletePatient(path: PatientDeletPath) -> AnyPublisher<ResponseData<EmptyResponse>, Moya.MoyaError> {
        request(.deletePatient(path: path))
    }
    
    func postGenerate(generate: PatientGenerateRequest) -> AnyPublisher<ResponseData<PatientGenerateResponse>, MoyaError> {
        request(.postGenerate(generate: generate))
    }
    
    func putUpdate(path: PatientUpdatePath, update: PatientUpdateRequest) -> AnyPublisher<ResponseData<PatientGenerateResponse>, MoyaError> {
        request(.putUpdate(path: path, update: update))
    }
    
    func getDetail(path: PatientDetailPath) -> AnyPublisher<ResponseData<PatientDTO>, MoyaError> {
        request(.getDetail(path: path))
    }
}
