//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet weak var topPosterImageView: UIImageView!
    @IBOutlet weak var midPosterImageView: UIImageView!
    @IBOutlet weak var bottomPosterImageView: UIImageView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let result = try await NetworkManager.shared.fetchThumbnailTaskGroup()
            topPosterImageView.image = result[0]
            midPosterImageView.image = result[1]
            bottomPosterImageView.image = result[2]
            
            return result
        }
    }
}

/*
 /* 📌 completion with UIImage */
 NetworkManager.shared.fetchThumbnail { [weak self] image in
     guard let self = self else { return }
     
     self.posterImageView = image
 }
 
 /* 📌 completion with Result */
 NetworkManager.shared.fetchThumbnailURLSession { [weak self] result in
     guard let self else { return }
     
     switch result {
     case .success(let image):
         DispatchQueue.main.async {
             self.posterImageView.image = image
         }
     case .failure(let error):
         self.posterImageView.backgroundColor = .systemGray
         print(error.localizedDescription)
     }
 }
 
 /* 📌 async, await & Task
   - 비동기 함수인데 왜 동기인 viewDidLoad에 쓰냐?
   - Task를 이용 (DispatchQueue의 역할을 수행)
     - 여러 개의 await을 사용하면 비동기를 동기로 작동하기에 하염없이 기다림
  */
 Task {
     let image1 = try await NetworkManager.shared.fetchThumbnailAsyncAwait(
         urlString: "https://www.themoviedb.org/t/p/w1280/sbgDVWrDxuUK7wHgpw8y9yMpIGD.jpg"
     )
     let image2 = try await NetworkManager.shared.fetchThumbnailAsyncAwait(
         urlString: "https://www.themoviedb.org/t/p/w1280/jpD6z9fgNe7OqsHoDeAWQWoULde.jpg"
     )
     let image3 = try await NetworkManager.shared.fetchThumbnailAsyncAwait(
         urlString: "https://www.themoviedb.org/t/p/w1280/318YNPBDdt4VU1nsJDdImGc8Gek.jpg"
     topPosterImageView.image = image1
     midPosterImageView.image = image2
     bottomPosterImageView.image = image3
 }
 
 /* 📌 async let */
 Task {
     let result = try await NetworkManager.shared.fetchThumbnailAsyncLet()
     
     topPosterImageView.image = result[0]
     midPosterImageView.image = result[1]
     bottomPosterImageView.image = result[2]
 }
 */
