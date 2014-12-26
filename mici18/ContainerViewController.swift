//
//  ContainerViewController.swift
//  mici18
//
//  Created by AlienLi on 14/12/24.
//  Copyright (c) 2014年 ALN. All rights reserved.
//

import UIKit

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController {

    var centerVC: CenterTabBarController!
    let screenBounds = UIScreen.mainScreen().bounds
    let CenterVCOffset: CGFloat = 100.0
    var currentState: SlideOutState = .BothCollapsed
    var leftViewController: LeftSideViewController?
    var rightViewController: RightSideViewController?
    
    var scaleF: CGFloat? = 0.0
    let acceleration: CGFloat = 0.3
    let animationSpeed = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        centerVC = UIStoryboard.centerViewController()
        self.view.addSubview(centerVC.view)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleLeftPanel", name: "toggleLeftPanel", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleRightPanel", name: "toggleRightPanel", object: nil)
        
        self.addGesturesForSlide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleLeftPanel() {
        
        if currentState != .LeftPanelExpanded {
            
            self.addLeftPanelViewController()
            
            self.animateCenterViewControllerToRight()
            
        } else {
            
            self.animateCenterViewControllerToCenter()
        }
    }
    
    func addLeftPanelViewController(){
        
        if let leftVC = leftViewController {
            
        } else {
            
            leftViewController = UIStoryboard.leftViewController()
            
            self.view.insertSubview(leftViewController!.view, atIndex: 0)
            self.addChildViewController(leftViewController!)
            }
    }
    
    func animateCenterViewControllerToRight() ->Void {
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height / 2)
            self.centerVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
            self.currentState = .LeftPanelExpanded
        })
    }
    
    func toggleRightPanel(){
        
        if currentState != .RightPanelExpanded {
            
            self.addRightPanelViewController()
            self.animateCenterViewControllerToLeft()
        }else {
            self.animateCenterViewControllerToCenter()
        }
    }
    func addRightPanelViewController() {
        
        if let rightVC = rightViewController {
            
        } else {
            rightViewController = UIStoryboard.rightViewController()
            self.view.insertSubview(rightViewController!.view, atIndex: 0)
            self.addChildViewController(rightViewController!)
        }

    }
    func animateCenterViewControllerToLeft() {
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.origin.x, UIScreen.mainScreen().bounds.height / 2)
            var transform: CGAffineTransform = CGAffineTransformMakeScale(0.8, 0.8)
            self.centerVC.view.transform = transform
            self.currentState = .RightPanelExpanded
        })

    }
    func animateCenterViewControllerToCenter() {
        
        UIView.animateWithDuration(animationSpeed, animations: { () -> Void in
            self.centerVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0)
            self.centerVC.view.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        }) { (finished) -> Void in
            if finished {
                self.currentState = .BothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
                self.scaleF = 0
            }
        }
    }
    
    
    func addGesturesForSlide() -> Void {
        
        var panForSlide: UIPanGestureRecognizer  = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.centerVC.view.addGestureRecognizer(panForSlide)
        
        
//        var tapForSlide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//        self.centerVC.view.addGestureRecognizer(tapForSlide)
        
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        if currentState != .BothCollapsed {
            self.animateCenterViewControllerToCenter()
        }
    }
    
    
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        var point: CGPoint = recognizer.translationInView(self.view)
        
        scaleF = point.x * acceleration + scaleF!
      
 
        if recognizer.view?.frame.origin.x >= 0 {
            
                recognizer.view?.center = CGPointMake(recognizer.view!.center.x + point.x * acceleration, recognizer.view!.center.y)
                
                recognizer.view?.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-(scaleF! / 1000), 1 - scaleF! / 1000)
                
                recognizer.setTranslation(CGPointZero, inView: self.view)
                self.addLeftPanelViewController()
                
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            
        } else {

                recognizer.view?.center = CGPointMake(recognizer.view!.center.x + point.x * acceleration ,recognizer.view!.center.y)
                recognizer.view?.transform = CGAffineTransformScale(CGAffineTransformIdentity,1 + (scaleF! / 1000), 1 + (scaleF! / 1000))
                
                recognizer.setTranslation(CGPointZero, inView: self.view)
                
                self.addRightPanelViewController()
                
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
        }
    
        switch recognizer.state {
            
        case .Ended:
            println(scaleF)
            if scaleF! > 140 * acceleration {
                self.animateCenterViewControllerToRight()
            } else if (scaleF! < -140 * acceleration) {
                self.animateCenterViewControllerToLeft()
            } else {
                self.animateCenterViewControllerToCenter()
                scaleF = 0
            }
            
        default:
            break
        }
    }

    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIStoryboard {
    class func leftViewController() -> LeftSideViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LeftSideViewController") as LeftSideViewController
    }
    class func rightViewController() -> RightSideViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RightSideViewController") as RightSideViewController
    }
    class func centerViewController() -> CenterTabBarController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CenterTabBarController") as CenterTabBarController
    }

}
