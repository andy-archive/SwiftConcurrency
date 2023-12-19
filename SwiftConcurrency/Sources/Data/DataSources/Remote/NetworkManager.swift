//
//  NetworkManager.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

/* 📝 GCD vs Swift Concurrency
 - completion handler
   - 비동기를 동기처럼
 - Thread Explosion
 - Context Switching
   -> 코어의 수와 스레드의 수를 같게 함
   -> 같은 스레드 내에 continuation 전환 형식으로 방식을 변경
 
 - async throws / try await -> 비동기를 동기처럼 작동
 - Task: 비동기 함수와 동기 함수를 연결
 - async let : DispatchGroup와 같은 역할
 */

final class NetworkManager {
    
    //MARK: - Error
    enum NetworkError: Int, Error, LocalizedError {
        case unknown = 1
        case invalidData = 2
        case badRequest = 400
        case unauthorized = 401
        case permissionDenied = 403
        case serverError = 500
        
        var errorDescription: String {
            switch self {
            case .unknown:
                return "알 수 없습니다."
            case .invalidData:
                return "잘못된 데이터입니다."
            case .badRequest:
                return "잘못된 요청입니다."
            case .unauthorized:
                return "다시 로그인해 주세요"
            case .permissionDenied:
                return "권한이 없습니다"
            case .serverError:
                return "서버 오류"
            }
        }
    }
    
    //MARK: - Singleton
    static let shared = NetworkManager()
    
    private init() { }
    
    //MARK: - Methods
    /// completion with UIImage
    func fetchThumbnail(completion: @escaping (UIImage) -> Void ) {
        let urlString = "https://an2-img.amz.wtchn.net/image/v2/y8zw23wQG88i2Y3lNWetpQ.jpg?jwt=ZXlKaGJHY2lPaUpJVXpJMU5pSjkuZXlKdmNIUnpJanBiSW1SZk5Ea3dlRGN3TUhFNE1DSmRMQ0p3SWpvaUwzWXlMM04wYjNKbEwybHRZV2RsTHpFMk9UazFPVEkwTmpnM016QTVNamd6TWpFaWZRLjFQU194eWZtVWFUZG5KUmhsY2V5RHVlVnZXVVhEQ2hhYlhnY01KZ1Fka1k"
        
        DispatchQueue.global().async {
            
            guard let url = URL(string: urlString) else { return }
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    /// completion with Result
    func fetchThumbnailURLSession(completion: @escaping ( Result<UIImage, NetworkError> ) -> Void ) {
        let urlString = "https://an2-img.amz.wtchn.net/image/v2/y8zw23wQG88i2Y3lNWetpQ.jpg?jwt=ZXlKaGJHY2lPaUpJVXpJMU5pSjkuZXlKdmNIUnpJanBiSW1SZk5Ea3dlRGN3TUhFNE1DSmRMQ0p3SWpvaUwzWXlMM04wYjNKbEwybHRZV2RsTHpFMk9UazFPVEkwTmpnM016QTVNamd6TWpFaWZRLjFQU194eWZtVWFUZG5KUmhsY2V5RHVlVnZXVVhEQ2hhYlhnY01KZ1Fka1k"
        
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest( /// 요청을 할 때 타이머, 캐시 설정 시 사용
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.badRequest))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
    
    /// async await
    func fetchThumbnailAsyncAwait(urlString: String) async throws -> UIImage {
        /// async - 비동기임을 명시
        guard let url = URL(string: urlString) else {
            return UIImage()
        }
        
        /// 요청을 할 때 타이머, 캐시 설정 시 사용
        let request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5
        )
        
        /// await - 비동기를 동기처럼 보이도록 작업 -> 응답이 올 때까지 기다림 ⭐️
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidData
        }
        
        return image
    }
    
    func fetchThumbnailAsyncLet() async throws -> [UIImage] {
        async let result1 = NetworkManager.shared.fetchThumbnailAsyncAwait(urlString: "https://www.themoviedb.org/t/p/w1280/sbgDVWrDxuUK7wHgpw8y9yMpIGD.jpg")
        async let result2 = NetworkManager.shared.fetchThumbnailAsyncAwait(urlString: "https://www.themoviedb.org/t/p/w1280/jpD6z9fgNe7OqsHoDeAWQWoULde.jpg")
        async let result3 = NetworkManager.shared.fetchThumbnailAsyncAwait(urlString: "https://www.themoviedb.org/t/p/w1280/318YNPBDdt4VU1nsJDdImGc8Gek.jpg")
        
        /// 세 가지가 모두 올 때까지 기다림
        return try await [result1, result2, result3]
    }
}
