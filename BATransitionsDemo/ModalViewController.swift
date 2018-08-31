//
//  ModalViewController.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var currentTransition: UIViewControllerTransitioningDelegate?
    
    deinit {
        Swift.print("[\(self.className)]: deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Swift.print("[\(self.className)]: viewDidLoad")

        self.navigationItem.title = "Modal VC"
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onEvent_cancelBarButtonItemClick(_:)))
        self.navigationItem.leftBarButtonItems = [cancelBarButtonItem]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Swift.print("[\(self.className)]: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Swift.print("[\(self.className)]: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Swift.print("[\(self.className)]: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Swift.print("[\(self.className)]: viewDidDisappear")
    }

    //MARK: Events
    
    @objc private func onEvent_cancelBarButtonItemClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
