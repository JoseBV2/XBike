//
//  OnboardingViewController.swift
//  XBike
//
//  Created by Jóse Bustamante on 10/08/22.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.setTitle("Continue", for: .normal)
            continueButton.isHidden = true
            continueButton.addTarget(self, action: #selector(moveToMap), for: .touchUpInside)
        }
    }
    @IBOutlet weak var skipButton: UIButton! {
        didSet {
            skipButton.addTarget(self, action: #selector(moveToMap), for: .touchUpInside)
        }
    }
    
    let dataSource = ["Extremely simple to use", "Track your time and distance", "See your progress and challengue yourself"]
    let dataSourceImages = ["bike1", "bike2", "bike3"]
    var currentViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.=
        navigationController?.navigationBar.barTintColor = .white
        configurePageViewController()
        timerToCheckContinueButton()
    }
    
    @objc func donePressed() {
        print("skip")
    }
    
    @objc func moveToMap() {
        let tabbar = UITabBarController()
        let vcRide = UINavigationController(rootViewController: CurrentRideController())
        let vcProgress = UINavigationController(rootViewController: MyProgressController())
        
        vcRide.title = "Current Ride"
        vcProgress.title = "My Progress"
        tabbar.setViewControllers([vcRide, vcProgress], animated: false)
        tabbar.modalPresentationStyle = .fullScreen
        UITabBar.appearance().barTintColor = UIColor.systemOrange
        tabbar.tabBar.tintColor = .white
        tabbar.tabBar.items![0].image = UIImage(named: "bike4")
        tabbar.tabBar.items![1].image = UIImage(named: "bike5")
        UserDefaults.standard.set(true, forKey: "isOnboardingDone")
        self.present(tabbar, animated: true)
    }
    
    func timerToCheckContinueButton() {
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(update),
                             userInfo: nil,
                             repeats: true)
    }
    // @objc selector expected for Timer
    @objc func update() {
        if currentViewControllerIndex == dataSource.count {
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
        }
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
        UIView.transition(with: continueButton, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
            self.continueButton.isHidden = true
        })
        
        return detailViewController(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataOnboarding = viewController as? OnboardingData
        
        guard var currentIndex = dataOnboarding?.index else { return nil }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        
        if currentIndex == dataSource.count {
            UIView.transition(with: continueButton, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.continueButton.isHidden = false
            })
            return nil
        }
        
        
        return detailViewController(index: currentIndex)
    }
}
