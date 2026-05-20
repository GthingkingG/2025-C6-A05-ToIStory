//
//  KeychainStored.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation
import Security

// MARK: - Keychain Error

enum KeychainError: Error, LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case encodingFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "키체인 저장 실패: \(status)"
        case .loadFailed(let status):
            return "키체인 로드 실패: \(status)"
        case .deleteFailed(let status):
            return "키체인 삭제 실패: \(status)"
        case .encodingFailed:
            return "인코딩 실패"
        case .decodingFailed:
            return "디코딩 실패"
        }
    }
}

// MARK: - Keychain Stored Property Wrapper

@propertyWrapper
struct KeychainStored<Value: Codable>: @unchecked Sendable {

    // MARK: Propertiesx
    private let key: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: Initialization

    init(key: String = "FindU") {
        self.key = key
    }

    // MARK: Wrapped Value
    var wrappedValue: Value? {
        get {
            guard let data = Self.load(key: key) else { return nil }

            do {
                return try decoder.decode(Value.self, from: data)
            } catch {
                Logger.logError("KeychainStored", "디코딩 실패: \(error.localizedDescription)")
                return nil
            }
        }
        set {
            if let newValue = newValue {
                do {
                    let data = try encoder.encode(newValue)
                    let success = Self.save(data, for: key)

                    if success {
                        Logger.logDebug("KeychainStored", "키체인 저장 성공: \(key)")
                    }
                } catch {
                    Logger.logError("KeychainStored", "인코딩 실패: \(error.localizedDescription)")
                }
            } else {
                let success = Self.delete(key: key)

                if success {
                    Logger.logDebug("KeychainStored", "키체인 삭제 성공: \(key)")
                }
            }
        }
    }

    // MARK: Private Methods - Save

    @discardableResult
    private static func save(_ data: Data, for key: String) -> Bool {
        // 기존 항목 삭제
        let deleteQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(deleteQuery as CFDictionary)

        // 새 항목 추가
        let saveQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(saveQuery as CFDictionary, nil)

        if status != errSecSuccess {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
            Logger.logError("KeychainStored", "키체인 저장 실패: \(status) - \(errorMessage)")
        }

        return status == errSecSuccess
    }

    // MARK: Private Methods - Load

    private static func load(key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            // 항목이 없는 경우는 정상 (에러 로그 없음)
            return nil
        }

        if status != errSecSuccess {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "알 수 없는 오류"
            Logger.logError("KeychainStored", "키체인 로드 실패: \(status) - \(errorMessage)")
            return nil
        }

        return item as? Data
    }

    // MARK: Private Methods - Delete

    @discardableResult
    private static func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            let errorMessage = SecCopyErrorMessageString(status, nil) as String? ?? "알 수 없는 오류"
            Logger.logError("KeychainStored", "키체인 삭제 실패: \(status) - \(errorMessage)")
        }

        return status == errSecSuccess || status == errSecItemNotFound
    }
}
