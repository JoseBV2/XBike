//
//  OnboardingViewController.swift
//  XBike
//
//  Created by Jóse Bustamante on 10/08/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    let dataSource = ["Extremely simple to use", "Track your time and distance", "See your progress and challengue yourself"]
    let dataSourceImages = ["bike1", "bike2", "bike3"]
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurePageViewController()
    }
    
    func configurePageViewController() {
        
        guard let pageViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController else { return }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view as Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                 options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: views))
        
        guard let startingViewController = detailViewController(index: currentViewControllerIndex) else { return }
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
    }

    func detailViewController(index: Int) -> OnboardingData? {
        
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: OnboardingData.self)) as? OnboardingData else { return nil }
        
        dataViewController.index = index
        dataViewController.currentText = dataSource[index]
        dataViewController.currentImage = dataSourceImages[index]
        return dataViewController
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataOnboarding = viewController as? OnboardingData
        
        guard var currentIndex = dataOnboarding?.index else { return nil }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewController(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataOnboarding = viewController as? OnboardingData
        
        guard var currentIndex = dataOnboarding?.index else { return nil }
        
        if currentIndex == dataSource.count {
            return nil
        }
        
        currentIndex += 1
        
        currentViewControllerIndex = currentIndex
        
        return detailViewController(index: currentIndex)
    }
}
