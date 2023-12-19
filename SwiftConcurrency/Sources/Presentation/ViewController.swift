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
        
        
        /// fetchThumbnail
//        NetworkManager.shared.fetchThumbnail { [weak self] image in
//            guard let self = self else { return }
//            
//            self.posterImageView = image
//        }
        
        /// fetchThumbnailURLSession
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
    }
    
}
