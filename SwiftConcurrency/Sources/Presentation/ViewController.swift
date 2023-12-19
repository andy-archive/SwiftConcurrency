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
        
        
        NetworkManager.shared.fetchThumbnail { [weak self] image in
            guard let self = self else { return }
            
            self.posterImageView = image
        }
    }
    
}
