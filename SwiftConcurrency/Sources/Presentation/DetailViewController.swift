//
//  DetailViewController.swift
//  SwiftConcurrency
//
//  Created by Taekwon Lee on 12/20/23.
//

import UIKit

final class MyClassA {
    var target: MyClassB?
    
    deinit {
        print("DEINIT MyClassA")
    }
}

final class MyClassB {
    var target: MyClassA?
    
    deinit {
        print("DEINIT MyClassB")
    }
}

final class DetailViewController: UIViewController {
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBrown
        
        let a = MyClassA()
        let b = MyClassB()
        
        /// Strong Reference Cycles
        a.target = b
        b.target = a
    }
    
    deinit {
        print("DEINIT DetailViewController")
    }
}
