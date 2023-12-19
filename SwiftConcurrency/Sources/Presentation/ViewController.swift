//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        /* completion with UIImage */
//        NetworkManager.shared.fetchThumbnail { [weak self] image in
//            guard let self = self else { return }
//            
//            self.posterImageView = image
//        }
        
//        /* completion with Result */
//        NetworkManager.shared.fetchThumbnailURLSession { [weak self] result in
//            guard let self else { return }
//            
//            switch result {
//            case .success(let image):
//                DispatchQueue.main.async {
//                    self.posterImageView.image = image
//                }
//            case .failure(let error):
//                self.posterImageView.backgroundColor = .systemGray
//                print(error.localizedDescription)
//            }
//        }
        
        
        /*
         async await
         - 비동기 함수인데 왜 동기인 viewDidLoad에 쓰냐?
         - Task를 이용 (DispatchQueue의 역할을 수행)
           - 여러 개의 await을 사용하면 비동기를 동기로 작동하기에 하염없이 기다림
         */
        Task {
            let image = try await NetworkManager.shared.fetchThumbnailAsyncAwait()
            posterImageView.image = image
        }
        
    }
}
