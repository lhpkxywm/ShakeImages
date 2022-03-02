//
//  MyFilterUserController.swift
//  ShakeImage
//
//  Created by MacMini on 2021/5/18.
//

import UIKit

class MyFilterUserController: BaseProjController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var filterUserArr = [BmobUser]()
    let emptyLayout = TGLinearLayout(.vert)
    
    override func loadView() {
        super.loadView()
        tableView.tg_margin(0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        frameLayout.addSubview(tableView)
        
        emptyLayout.tg_top.equal(screenWidth/3)
        emptyLayout.tg_horzMargin(100)
        emptyLayout.tg_height.equal(screenWidth)
        emptyLayout.tg_gravity = TGGravity.horz.center
        frameLayout.addSubview(emptyLayout)
        
        let emptyImgView = UIImageView(image: UIImage(named: "emptyData"))
        emptyImgView.tg_width.equal(196)
        emptyImgView.tg_height.equal(128)
        emptyLayout.addSubview(emptyImgView)
        
        let emptyLabel = UILabel()
        emptyLabel.tg_top.equal(10)
        emptyLabel.tg_horzMargin(0)
        emptyLabel.tg_height.equal(40)
        emptyLabel.textColor = .label
        emptyLabel.font = .systemFont(ofSize: 15)
        emptyLabel.textAlignment = .center
        emptyLabel.text = "您的黑名单为空!"
        emptyLayout.addSubview(emptyLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的黑名单"
        loadNetworkData()
    }
    
    func loadNetworkData() {
        let userQuery = BmobUser.query()
        // 黑名单用户id数组
        let filterIdArr = BmobUser.current().object(forKey: "filterIdArr") as? [String] ?? []
        userQuery?.whereKey("objectId", containedIn: filterIdArr)
        userQuery?.findObjectsInBackground({ [self] queryUserArr, error in
            for i in 0..<queryUserArr!.count {
                let blackUser = queryUserArr![i] as! BmobUser
                filterUserArr.append(blackUser)
            }
            if queryUserArr!.count > 0 {
                emptyLayout.isHidden = true
                tableView.reloadData()
            } else {
                emptyLayout.isHidden = false
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterUserArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "filterUserCell"
        var filterUserCell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if filterUserCell == nil {
            filterUserCell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        var userName = filterUserArr[indexPath.row].username ?? ""
        // 截取后10位显示
        if userName.count > 20 {
            userName = String(userName.suffix(20))
        }
        filterUserCell?.textLabel?.text = "用户名：" + userName
        return filterUserCell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let deleteUserId = filterUserArr[indexPath.row].objectId
        let currentUser = BmobUser.current()
        // 获取当前用户的黑名单id
        var filterIdArr = currentUser?.object(forKey: "filterIdArr") as? [String] ?? []
        filterIdArr.removeAll{
            $0 == deleteUserId
        }
        currentUser?.setObject(filterIdArr, forKey: "filterIdArr")
        currentUser?.updateInBackground(resultBlock: { result, error in
            if result {
                //删除数据源中的用户数据
                self.filterUserArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
            }
        })
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        "删除"
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
