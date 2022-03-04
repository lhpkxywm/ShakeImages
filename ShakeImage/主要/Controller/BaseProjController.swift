//
//  BaseProjController.swift
//  ShakeFigure
//
//  Created by MacMini on 2021/4/28.
//

import UIKit

class BaseProjController: UIViewController {
    
    let frameLayout = TGFrameLayout()
    
    override func loadView() {
        super.loadView()
        edgesForExtendedLayout = UIRectEdge(rawValue:0)
        frameLayout.backgroundColor = UIColor(named: "BackColor")
        view = frameLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color_Theme
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor(named: "TabNavLabelColor") ?? .label]
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
