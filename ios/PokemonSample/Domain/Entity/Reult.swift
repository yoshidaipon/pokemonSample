//
//  Reult.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//
import Foundation

/// API呼び出しの結果を表す enum
enum Result<T> {
    case success(T)      // 成功時の結果を保持
    case failure(Error)  // 失敗時のエラーを保持
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return nil
    }
}

/// API エラー
enum APIError: LocalizedError {
    case networkError
    case decodingError
    case invalidResponse
    case custom(String)
    
    var errorDescription: String? {
        switch self {
            case .networkError:
                return "ネットワークエラーが発生しました"
            case .decodingError:
                return "データの解析に失敗しました"
            case .invalidResponse:
                return "無効なレスポンスです"
            case .custom(let message):
                return message
        }
    }
}
