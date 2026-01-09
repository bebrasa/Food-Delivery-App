//
//  NetworkManager.swift
//  FitoNyash
//
//  Created by Никита Кочанов on 09.01.2026.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int, String?)
    case unauthorized
    case networkError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .noData:
            return "Нет данных от сервера"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return message ?? "Ошибка сервера: \(code)"
        case .unauthorized:
            return "Требуется авторизация"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

// MARK: - Network Manager
class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.requestTimeout
        config.timeoutIntervalForResource = APIConfig.resourceTimeout
        
        self.session = URLSession(configuration: config)
        
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .useDefaultKeys
        
        self.encoder = JSONEncoder()
        self.encoder.keyEncodingStrategy = .useDefaultKeys
    }
    
    // MARK: - Public Methods
    
    /// Выполнить запрос без авторизации
    func request<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        queryParams: [String: String]? = nil
    ) async throws -> T {
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            queryParams: queryParams,
            requiresAuth: false
        )
    }
    
    /// Выполнить запрос с авторизацией
    func authorizedRequest<T: Codable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        queryParams: [String: String]? = nil
    ) async throws -> T {
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            queryParams: queryParams,
            requiresAuth: true
        )
    }
    
    /// Выполнить запрос без ожидания ответа (void)
    func authorizedRequestVoid(
        endpoint: String,
        method: HTTPMethod = .POST,
        body: Encodable? = nil,
        queryParams: [String: String]? = nil
    ) async throws {
        let _: APIResponse<EmptyResponse> = try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            queryParams: queryParams,
            requiresAuth: true
        )
    }
    
    // MARK: - Private Methods
    
    private func performRequest<T: Codable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        queryParams: [String: String]?,
        requiresAuth: Bool
    ) async throws -> T {
        // Построение URL
        var urlString = APIConfig.baseURL + endpoint
        
        if let queryParams = queryParams, !queryParams.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlString = components?.string ?? urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // Создание запроса
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Добавление токена авторизации
        if requiresAuth {
            if let token = TokenStorage.shared.accessToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                throw NetworkError.unauthorized
            }
        }
        
        // Добавление тела запроса
        if let body = body {
            request.httpBody = try encoder.encode(body)
        }
        
        // Выполнение запроса
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            // Обработка статус кодов
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                    print("Response data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    throw NetworkError.decodingError(error)
                }
                
            case 401:
                // Попытка обновить токен
                if requiresAuth {
                    let refreshed = await refreshTokenIfNeeded()
                    if refreshed {
                        // Повторяем запрос с новым токеном
                        return try await performRequest(
                            endpoint: endpoint,
                            method: method,
                            body: body,
                            queryParams: queryParams,
                            requiresAuth: true
                        )
                    }
                }
                throw NetworkError.unauthorized
                
            default:
                let errorMessage = try? decoder.decode(APIResponse<EmptyResponse>.self, from: data).message
                throw NetworkError.serverError(httpResponse.statusCode, errorMessage)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    private func refreshTokenIfNeeded() async -> Bool {
        guard let refreshToken = TokenStorage.shared.refreshToken else {
            return false
        }
        
        do {
            let request = RefreshTokenRequest(refreshToken: refreshToken)
            let response: APIResponse<AuthResponse> = try await self.request(
                endpoint: APIConfig.Auth.refresh,
                method: .POST,
                body: request
            )
            
            if let authData = response.data {
                TokenStorage.shared.saveTokens(
                    accessToken: authData.accessToken,
                    refreshToken: authData.refreshToken
                )
                return true
            }
            return false
        } catch {
            // Если refresh токен невалиден, очищаем токены
            TokenStorage.shared.clearTokens()
            return false
        }
    }
}

// MARK: - Empty Response Helper
struct EmptyResponse: Codable {}

