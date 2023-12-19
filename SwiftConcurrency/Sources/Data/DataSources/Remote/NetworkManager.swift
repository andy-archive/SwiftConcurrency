//
//  NetworkManager.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class NetworkManager {

    //MARK: - Singleton
    static let shared = NetworkManager()
    
    private init() { }
    
    //MARK: - Methods
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

}
