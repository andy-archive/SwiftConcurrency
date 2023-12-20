//
//  DetailViewController.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/20/23.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
    }
    
    deinit {
        print("DEINIT DetailViewController")
    }
}
