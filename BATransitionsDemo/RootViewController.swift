//
//  RootViewController.swift
//  BATransitionsDemo
//
//  Created by Alexander Barobin
//  Copyright © 2016 Alexander Barobin. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    fileprivate var tableItems = [[String: Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    private func initRootViewController() {
        self.registerTransitions()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initRootViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initRootViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Transitions"

        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
        self.tableView.layoutMargins = UIEdgeInsets.zero
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    //MARK: Private
    
    private func registerTransitions() {
        self.tableItems.removeAll()
        
        //BAFadeTransition
        var fadeTransitions = [[String: Any]]()
        fadeTransitions.append(["transition": BAFadeTransition(animationDuration: 0.3), "text": "BAFadeTransition"])
        self.tableItems.append(["title": "BAFadeTransition", "items": fadeTransitions])
        
        //BAScaleTransition
        var scaleTransitions = [[String: Any]]()
        scaleTransitions.append(["transition": BAScaleTransition(animationDuration: 0.2), "text": "BAScaleTransition"])
        self.tableItems.append(["title": "BAScaleTransition", "items": scaleTransitions])
        
        //BASlide1Transition
        var slide1Transitions = [[String: Any]]()
        
        let slide1 = BASlide1Transition(animationDuration: 0.8)
        slide1.slideFrom = .fromLeft
        slide1Transitions.append(["transition": slide1, "text": "fromLeft"])
        
        let slide2 = BASlide1Transition(animationDuration: 0.8)
        slide2.slideFrom = .fromRight
        slide1Transitions.append(["transition": slide2, "text": "fromRight"])
        
        let slide3 = BASlide1Transition(animationDuration: 0.8)
        slide3.slideFrom = .fromTop
        slide1Transitions.append(["transition": slide3, "text": "fromTop"])
        
        let slide4 = BASlide1Transition(animationDuration: 0.8)
        slide4.slideFrom = .fromBottom
        slide1Transitions.append(["transition": slide4, "text": "fromBottom"])
        
        self.tableItems.append(["title": "BASlide1Transition", "items": slide1Transitions])
        
        //BASwap1Transition
        var swap1Transitions = [[String: Any]]()
        let swap1 = BASwap1Transition(animationDuration: 0.8)
        swap1.slideFrom = .fromLeft
        swap1Transitions.append(["transition": swap1, "text": "fromLeft"])
        
        let swap2 = BASwap1Transition(animationDuration: 0.8)
        swap2.slideFrom = .fromRight
        swap1Transitions.append(["transition": swap2, "text": "fromRight"])
        
        let swap3 = BASwap1Transition(animationDuration: 0.8)
        swap3.slideFrom = .fromTop
        swap1Transitions.append(["transition": swap3, "text": "fromTop"])
        
        let swap4 = BASwap1Transition(animationDuration: 0.8)
        swap4.slideFrom = .fromBottom
        swap1Transitions.append(["transition": swap4, "text": "fromBottom"])
        
        self.tableItems.append(["title": "BASwap1Transition", "items": swap1Transitions])
        
        //BASquaresTransition
        var squaresTransitions = [[String: Any]]()
        let squares1 = BASquaresTransition(animationDuration: 0.5)
        squaresTransitions.append(["transition": squares1, "text": "squares"])
        
        self.tableItems.append(["title": "BASquaresTransition", "items": squaresTransitions])
        
        //BAGapTransition
        var gapTransitions = [[String: Any]]()
        let gap1 = BAGapTransition(animationDuration: 0.8)
        gap1.gapDirection = .fromCenterHorizontal
        gapTransitions.append(["transition": gap1, "text": "fromCenterHorizontal"])
        
        let gap2 = BAGapTransition(animationDuration: 0.8)
        gap2.gapDirection = .toCenterHorizontal
        gapTransitions.append(["transition": gap2, "text": "toCenterHorizontal"])
        
        let gap3 = BAGapTransition(animationDuration: 0.8)
        gap3.gapDirection = .fromCenterVertical
        gapTransitions.append(["transition": gap3, "text": "fromCenterVertical"])
        
        let gap4 = BAGapTransition(animationDuration: 0.8)
        gap4.gapDirection = .toCenterVertical
        gapTransitions.append(["transition": gap4, "text": "fromCenterVertical"])
        
        let gap5 = BAGapTransition(animationDuration: 0.8)
        gap5.gapDirection = .fromCenterHorizontalMasked
        gapTransitions.append(["transition": gap5, "text": "fromCenterHorizontalMasked"])
        
        let gap6 = BAGapTransition(animationDuration: 0.8)
        gap6.gapDirection = .toCenterHorizontalMasked
        gapTransitions.append(["transition": gap6, "text": "toCenterHorizontalMasked"])
        
        self.tableItems.append(["title": "BAGapTransition", "items": gapTransitions])
        
        if self.isViewLoaded {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        
        guard let items = self.tableItems[indexPath.section]["items"] as? [[String: Any]] else { fatalError() }
        cell.textLabel?.text = items[indexPath.row]["text"] as? String
    }
    
    fileprivate func presentViewController(forTransition: UIViewControllerTransitioningDelegate) {
        let modalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        modalVC.currentTransition = forTransition
        
        let navigationVC = UINavigationController(rootViewController: modalVC)
        navigationVC.transitioningDelegate = forTransition
        self.present(navigationVC, animated: true, completion: nil)
    }
}

extension RootViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = self.tableItems[section]["items"] as? [[String: Any]] else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell")!
        self.setupCell(cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableItems[section]["title"] as? String
    }
}

extension RootViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let items = self.tableItems[indexPath.section]["items"] as? [[String: Any]] else { fatalError() }
        self.presentViewController(forTransition: items[indexPath.row]["transition"] as! UIViewControllerTransitioningDelegate)
    }
}
