//
//  ComposeController.swift
//  weibo
//
//  Created by dalu on 2016/10/29.
//  Copyright © 2016年 dalu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeController: UIViewController {
    lazy var titleView : ComposeTitleView  = ComposeTitleView()
    lazy var images : [UIImage] = [UIImage]()
    lazy var emoticonVc : EmoticonViewController = EmoticonViewController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    @IBOutlet weak var toolBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeightCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        setupNotifications()
    }
    
    //移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
}

// MARK: - 设置UI
extension ComposeController {
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(ComposeController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(ComposeController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    func setupNotifications(){
        //键盘
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeController.keyboardWillChangeFrame(note:)), name:
            NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //添加照片的通知
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeController.addPhotoClick), name:
            NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeController.delPhotoClick(note:)), name:
            NSNotification.Name(rawValue: PicPickerDelPhotoNote), object: nil)
    }
}


// MARK: - 事件
extension ComposeController {
    func closeItemClick(){
        dismiss(animated: true, completion: nil)
    }
    
    func sendItemClick(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        textView.resignFirstResponder()
        SVProgressHUD.showProgress(0, status: "正在发送...")
        let statusText = textView.getEmoticonString()
        //
        let requestCallback = {[weak self](isSuccess: Bool) in
            if !isSuccess {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                SVProgressHUD.showError(withStatus: "发送失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            self?.dismiss(animated: true, completion: nil)
        }
        if let image = images.first {
            NetworkTools.shareInstance.sendStatus(statusText: statusText,image: image,isSuccess : requestCallback)
        }else{
            NetworkTools.shareInstance.sendStatus(statusText: statusText,isSuccess : requestCallback)
        }
    }
    
    func keyboardWillChangeFrame(note: NSNotification){
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        //y value
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //计算工具栏距离底部的位置
        let margin = UIScreen.main.bounds.height-y
        toolBottomCons.constant = margin
        
        //        if margin > 0 {
        //            dismissPicPicker()
        //        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPicker() {
        textView.resignFirstResponder()
        picPickerViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //    func dismissPicPicker() {
    //        if picPickerViewHeightCons.constant > 0 {
    //            self.picPickerViewHeightCons.constant = 0
    //            UIView.animate(withDuration: 0.5) {
    //                self.view.layoutIfNeeded()
    //            }
    //        }
    //
    //    }
    
    //添加照片
    func addPhotoClick(){
        //判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        //创建照片选择器材
        let ipc = UIImagePickerController()
        //设置照片源
        ipc.sourceType = .photoLibrary
        //设置代理
        ipc.delegate = self
        
        //弹出
        present(ipc, animated: true, completion: nil)
    }
    
    func delPhotoClick(note: NSNotification){
        guard let image = note.object as? UIImage else {
            return
        }
        guard let index = images.index(of: image) else {
            return
        }
        
        images.remove(at: index)
        picPickerView.images = images
    }
    
    @IBAction func emoticonBtnClick(){
        //先退出键盘
        textView.resignFirstResponder()
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        textView.becomeFirstResponder()
    }
    
}

// MARK: - 添加照片代理
extension ComposeController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 展示照片
        images.append(image)
        picPickerView.images = images
        // 退出
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - 代理
extension ComposeController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.hintLable.isHidden = textView.hasText ? true : false
        
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText ? true : false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
