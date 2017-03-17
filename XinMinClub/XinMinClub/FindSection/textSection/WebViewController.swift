//
//  WebViewController.swift
//  XinMinClub
//
//  Created by 杨科军 on 2016/12/27.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

import UIKit

class WebViewController : UINavigationController,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    @available(iOS 2.0, *)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0{
            return 1
        }else{
            return kj_dataDictArr.count+1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:"webCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier:"webCell")
                cell?.contentView.addSubview(self.webView)
                /* 忽略点击效果 */
                cell?.selectionStyle = .none
            }
            return cell!
        }else if indexPath.section==1&&indexPath.row==kj_dataDictArr.count{
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:"endCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier:"endCell")
                cell?.textLabel?.text = "已经到底了~"
                cell?.textLabel?.textAlignment = .center
                /* 忽略点击效果 */
                cell?.selectionStyle = .none
            }
            return cell!
        }else {
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:"detailsCell2")!
            if cell == nil {
                cell = UITableViewCell(style:.default, reuseIdentifier:"detailsCell2")
            }
            /* 忽略点击效果 */
            cell?.selectionStyle = .none
            let kj_dict:NSDictionary = kj_dataDictArr[indexPath.row] as! NSDictionary
            (cell as! DetailsCell2).details2Text = kj_dict.value(forKey:"USER_NAME") as! String!
            (cell as! DetailsCell2).details2Title = kj_dict.value(forKey:"PL_KCXJ_CONTENT") as! String!
            (cell as! DetailsCell2).details2Time = kj_dict.value(forKey:"PL_OPS_TIME") as! String!
            (cell as! DetailsCell2).detailsImageUrl = kj_dict.value(forKey:"USER_IMG") as! String!
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
            return self.webView.frame.size.height
        }else if indexPath.section==1&&indexPath.row==kj_dataDictArr.count{
            return 60
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section==1 {
            return "➢ 用户评价"
        }else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==1 {
            return 30
        }else{
            return 0.1
        }
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        //获取到webview的高度
        let hs:String = self.webView.stringByEvaluatingJavaScript(from:"document.body.offsetHeight")!
        let height = (hs as NSString).floatValue
        self.webView.frame = MY_CGRECT(x:self.webView.frame.origin.x, y:self.webView.frame.origin.y, w:SCREEN_WIDTH, h:CGFloat(height))
        self.courseTable.reloadData()
    }
    
    private var dataDic:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view!.addSubview(self.courseTable)
        
        self.initKeyboard()
    }
    
    var kcxjID:String = ""
    var kcID:String = ""
    func setDic(dic:NSDictionary) {
        dataDic = dic
        self.setNavigationBar()
        kcxjID = dic.value(forKey:"KCXJ_ID") as! String
        let urlHead = "http://www.kingwant.com/m/KC/Html/kc_Info.aspx?ID="
        let url = NSURL.init(string:urlHead+kcxjID)
        let request = NSURLRequest.init(url:url as! URL)
        self.webView.loadRequest(request as URLRequest)
        
        // 重新请求数据
        self.getEvaluate(bookID:kcxjID)
    }
    
    func setNavigationBar() {
        let btn2=UIButton()
        btn2.frame = CGRect(x:10, y:27, width:30, height:30)
        btn2.setImage(UIImage(named:"goback"), for:.normal)
        btn2.addTarget(self, action:#selector(buttonAction2(sender:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn2)
        
        let lab = UILabel()
        lab.frame = CGRect(x:0, y:0, width:screenWidth-70, height:30)
        lab.center = CGPoint(x:screenWidth/2,y:42)
        lab.text = dataDic.value(forKey:"KCXJ_NAME") as? String
        lab.textAlignment = .center
        self.view.addSubview(lab)
        
        let shareImage = UIImage(named:"share_web")
        let shareNavBar = UIButton(type:.custom)
        shareNavBar.frame = CGRect(x:screenWidth-40,y:27,width:30,height:30)
        shareNavBar.setImage(shareImage, for:.normal)
        shareNavBar.addTarget(self, action:#selector(self.clickRightButton), for:.touchUpInside)
        
        self.view.addSubview(shareNavBar)
    }
    
    var teacher:String = ""
    func clickRightButton() {
        let shareBut = ShareView()
        shareBut.setShareContent = .ShareWeb
        shareBut.title = dataDic.value(forKey:"KCXJ_NAME") as! String
        let string_1 = "http://www.kingwant.com/m/KC/Html/kc_Info.aspx?ID="
        let string_2 = dataDic.value(forKey:"KCXJ_ID") as! String
        shareBut.webUrl = string_1 + string_2
        shareBut.thumbImage = networkPictureUrl_swift
        shareBut.describe = teacher
        self.view.addSubview(shareBut)
    }
    
    func buttonAction2(sender:UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    private lazy var webView : UIWebView = {
        let wv = UIWebView()
        wv.frame = CGRect(x:0, y:0, width:screenWidth, height:1)
        wv.backgroundColor = .gray
        wv.delegate = self
        wv.scrollView.isScrollEnabled = false
        return wv
    }()
    
    private lazy var courseTable : UITableView = {
        let ct = UITableView()
        ct.frame = CGRect(x:0, y:64, width:screenWidth, height:screenHeight-64);
        ct.delegate = self
        ct.dataSource = self
        let cellNib = UINib(nibName:"DetailsCell2", bundle:nil)
        ct.register(cellNib, forCellReuseIdentifier:"detailsCell2")
        return ct;
    }()
    
    // 键盘相关
    func initKeyboard(){
        self.view.addSubview(self.backView)
        self.view.addSubview(self.kj_backView)
        self.backView.isHidden = true
        // 添加观察者,监听键盘弹出，隐藏事件
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private lazy var backView : UIView = {
        let bv = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        bv.backgroundColor = UIColor(white: CGFloat(0.5), alpha: CGFloat(0.3))
        var singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap))
        bv.addGestureRecognizer(singleTap)
        return bv
    }()
    
    private lazy var kj_backView : UIView = {
        let kjbv = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(SCREEN_HEIGHT - 60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(60)))
        kjbv.backgroundColor = RGB255_COLOR(r: 235, g: 235, b: 235, a: 1)
        let detailsTextField = UITextField(frame: CGRect(x: CGFloat(10), y: CGFloat(10), width: CGFloat(SCREEN_WIDTH * 3 / 4 - 10), height: CGFloat(40)))
        detailsTextField.borderStyle = .roundedRect
        //外框类型
        detailsTextField.keyboardType = .default
        detailsTextField.clearButtonMode = .whileEditing
        //编辑时会出现个修改X
        detailsTextField.delegate = self
        
        let detailsButon = UIButton(type: .custom)
        detailsButon.frame = CGRect(x: CGFloat(SCREEN_WIDTH * 3 / 4 + 5), y: CGFloat(10), width: CGFloat(SCREEN_WIDTH / 4 - 15), height: CGFloat(40))
        detailsButon.setTitle("发送", for: .normal)
        detailsButon.setTitleColor(UIColor(red: CGFloat(0.553), green: CGFloat(0.281), blue: CGFloat(0.248), alpha: CGFloat(1.000)), for: .normal)
        detailsButon.addTarget(self, action: #selector(self.updateUser), for: .touchUpInside)
        detailsButon.layer.masksToBounds = true
        detailsButon.layer.cornerRadius = 6.0
        detailsButon.layer.borderColor = UIColor(white: CGFloat(0.503), alpha: CGFloat(0.800)).cgColor
        detailsButon.layer.borderWidth = 0.5
        detailsButon.showsTouchWhenHighlighted = true
        kjbv.addSubview(detailsTextField)
        kjbv.addSubview(detailsButon)
        
        return kjbv
    }()
    
    var kj_dataDictArr:NSArray = NSArray()
    func getEvaluate(bookID:String){
        let dic:NSDictionary = ["KCXJ_ID":kcxjID]
        let paramString = networkSection.getParamString(param:["Right_ID":"","FunName":"Get_Sys_KCXJ_PL","Params":dic])
        networkSection.getRequestDataBlock(ipurl, paramString, block: {(json) -> Void in
            self.kj_dataDictArr = (json.value(forKey:"RET") as! NSDictionary).value(forKey:"SYS_KCXJ_PL") as! NSArray
            self.courseTable.reloadData()
        })
    }
    
    func toJSONString(dict:NSDictionary!)->String{
        let data = try! JSONSerialization.data(withJSONObject:dict, options:JSONSerialization.WritingOptions.prettyPrinted)
        let string = String(data:data, encoding:String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return string!
    }
    
    func updateUser() {
        let but:UIButton = self.kj_backView.subviews[1] as! UIButton
        but.isEnabled = false
        let encodedImageStr = DetailsCell2().image(toString:UserDataModel.default().userImage)
        let txf:UITextField = self.kj_backView.subviews[0] as! UITextField
        let dic:NSDictionary = ["PL_KCXJ_ID":kcxjID,"PL_KCXJ_CONTENT":txf.text!,"USER_IMG":encodedImageStr!,"USER_NAME":UserDataModel.default().userName]
        let paramString = self.toJSONString(dict:["Right_ID":"","FunName":"Add_Sys_KCXJ_PL","Params":dic])
        networkSection.getRequestDataBlock(ipurl, paramString, block: {(json) -> Void in
            print(json)
            if ((json["Error"] as? String) == "") {
                but.isEnabled = true
                self.successs()
            }
            else {
                but.isEnabled = true
                self.error()
            }
        })
    }
    
    func error() {
        SVProgressHUD.showSuccess(withStatus: "添加评论失败!")
        self.dismiss()
    }
    
    func successs() {
//        self.kj_backView.frame = CGRect(x: CGFloat(0), y: CGFloat(SCREEN_HEIGHT - 60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(60))
//        self.backView.isHidden = true
        SVProgressHUD.showSuccess(withStatus: "添加评论成功!")
        self.dismiss()
        // 重新请求数据
        self.getEvaluate(bookID:kcxjID)
    }
    
    func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    // 最后，响应的方法中，可以获取点击的坐标哦！
    func handleSingleTap(_ sender: UITapGestureRecognizer) {
        let txf:UITextField = self.kj_backView.subviews[0] as! UITextField
        txf.resignFirstResponder()
        self.kj_backView.frame = CGRect(x: CGFloat(0), y: CGFloat(SCREEN_HEIGHT - 60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(60))
        self.backView.isHidden = true
    }
    
    // 键盘弹出时不产生遮挡关系的设置
    func keyboardShow(_ notify: Notification) {
        //通知里的内容
        let userInfo = notify.userInfo as NSDictionary!
        let aValue = userInfo?.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRect = (aValue as AnyObject).cgRectValue
        //键盘的高度
        let keyboardHeight:CGFloat = (keyboardRect?.size.height)!
        self.kj_backView.frame = CGRect(x: CGFloat(0), y: CGFloat(SCREEN_HEIGHT - keyboardHeight - 60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(60))
        self.backView.isHidden = false
    }
    
    // 键盘隐藏
    func keyboardHide(_ notify: Notification) {
        self.kj_backView.frame = CGRect(x: CGFloat(0), y: CGFloat(SCREEN_HEIGHT - 60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(60))
        self.backView.isHidden = true
    }
    
}
