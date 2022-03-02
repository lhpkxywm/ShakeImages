//
//  TabBarController.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let homeNavVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let publishNavVC = UIStoryboard(name: "Publish", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let meNavVC = UIStoryboard(name: "Me", bundle: nil).instantiateInitialViewController() as! UINavigationController
        
        addChildVC("首页", "tabar_home", "tabar_home_s", homeNavVC)
        addChildVC("发布", "tabar_add", "tabar_add_s", publishNavVC)
        addChildVC("我的", "tabar_me", "tabar_me_s", meNavVC)
    }
    
    func addChildVC(_ title:String, _ image:String, _ selectImg:String, _ navVC:UINavigationController) {
        
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:Color_Theme], for: .selected)
        navVC.tabBarItem.title = title
        
        guard let tabarImg = UIImage(named: image) else {
            return
        }
        navVC.tabBarItem.image = tabarImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        guard let selectImg = UIImage(named: selectImg) else {
            return
        }
        navVC.tabBarItem.selectedImage = selectImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        addChild(navVC)
    }
    
    func addChildVC(_ title:String, _ image:String, _ selectImg:String, _ vcType:UIViewController.Type) {
        let childVC = UINavigationController(rootViewController: vcType.init())
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
        childVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:Color_Theme], for: .selected)
        childVC.tabBarItem.title = title
        
        guard let tabarImg = UIImage(named: image) else {
            return
        }
        childVC.tabBarItem.image = tabarImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        guard let selectImg = UIImage(named: selectImg) else {
            return
        }
        childVC.tabBarItem.selectedImage = selectImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        addChild(childVC)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
