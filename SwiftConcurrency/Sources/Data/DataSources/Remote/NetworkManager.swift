//
//  NetworkManager.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class NetworkManager {
    
    //MARK: - Error
    enum NetworkError: Int, Error, LocalizedError {
        case unknown = 1
        case invalidImage = 400
        case unauthorized = 401
        case permissionDenied = 403
        case invalidServer = 500
        case missingParameter = 400
        
        var errorDescription: String {
            switch self {
            case .unknown:
                return "알 수 없습니다."
            case .invalidImage:
                return "잘못된 이미지입니다."
            case .unauthorized:
                return "다시 로그인해 주세요"
            case .permissionDenied:
                return "권한이 없습니다"
            case .invalidServer:
                return "서버 오류"
            case .missingParameter:
                return "검색어를 입력해 주세요"
            }
        }
    }
    
    //MARK: - Singleton
    static let shared = NetworkManager()
    
    private init() { }
    
    //MARK: - Methods
    /// try Data
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
    
    /// URLSession
    func fetchThumbnailURLSession(completion: @escaping ( UIImage?, NetworkError? ) -> Void ) {
        let urlString = "https://an2-img.amz.wtchn.net/image/v2/y8zw23wQG88i2Y3lNWetpQ.jpg?jwt=ZXlKaGJHY2lPaUpJVXpJMU5pSjkuZXlKdmNIUnpJanBiSW1SZk5Ea3dlRGN3TUhFNE1DSmRMQ0p3SWpvaUwzWXlMM04wYjNKbEwybHRZV2RsTHpFMk9UazFPVEkwTmpnM016QTVNamd6TWpFaWZRLjFQU194eWZtVWFUZG5KUmhsY2V5RHVlVnZXVVhEQ2hhYlhnY01KZ1Fka1k"
        
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest( /// 요청을 할 때 타이머, 캐시 설정 시 사용
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 10
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(nil, .unknown)
                return
            }
            
            guard let data else {
                completion(nil, .invalidImage)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(nil, .unauthorized)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil, .invalidImage)
                return
            }
        }
        
        task.resume()
    }
}
