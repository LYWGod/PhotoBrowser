//
//  PhotoBrowerViewController.swift
//  PhotoBrowser
//
//  Created by chenzhen on 2019/7/9.
//  Copyright © 2019 LYW. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let photoBrowerCellID = "photoBrowerCellID"
class PhotoBrowerViewController: UIViewController {

    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowerCellFlowLayout())
    lazy var saveBtn = UIButton(bgColor: UIColor.lightGray, font: 14, title: "保存")
    lazy var closeBtn = UIButton(bgColor: UIColor.lightGray, font: 14, title: "关闭")
    var urlArr : [URL] = [URL]()
    var indexpath : IndexPath
    
    //构造函数，传进图片数组和下标
    init(indexPath:IndexPath,urlArr:[URL]) {
        
        self.urlArr = urlArr
        self.indexpath = indexPath
        //控制器的构造函数要重写父类的这个方法
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        //屏幕尺寸增加20的宽度。这里是为了item的间距，到时候cell的srollview还要减去20
        view.frame.size.width += 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        //滚动到对应cell
        collectionView.scrollToItem(at:indexpath as IndexPath, at: .left, animated: false)

    }
    
}

extension PhotoBrowerViewController{
    func setupUI() {
        
        view.addSubview(collectionView)
        view.addSubview(saveBtn)
        view.addSubview(closeBtn)
        //保存按钮的约束
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 35))
        }
        //关闭按钮的约束
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 35))
        }
    
        collectionView.frame = view.bounds
        //给保存按钮增加点击事件
        collectionView.dataSource = self
        collectionView.delegate = self
        //注册cell
        collectionView.register(PhotoBrowerCollectionViewCell.self, forCellWithReuseIdentifier: photoBrowerCellID)
        //给关闭按钮增加点击事件
        closeBtn.addTarget(self, action: #selector(PhotoBrowerViewController.closeBtnClick), for: .touchUpInside)
        //给保存按钮增加点击事件
        saveBtn.addTarget(self, action: #selector(PhotoBrowerViewController.saveBtnClick), for: .touchUpInside)
    }
}

extension PhotoBrowerViewController {
    //关闭按钮点击事件
    @objc func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    //保存图片按钮点击事件
    @objc func saveBtnClick() {
        //获取展示的cell
        let cell = collectionView.visibleCells.first as! PhotoBrowerCollectionViewCell
        //获取cell中的图片
        let picture = cell.pictureImageView.image
        //校验
        guard let pictureImage = picture else { return }
        //保存到相册
        UIImageWriteToSavedPhotosAlbum(pictureImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image : UIImage, didFinishSavingWithError error : NSError?, contextInfo context : AnyObject) {
        // 1.判断是否有错误
        let message = error == nil ? "保存成功" : "保存失败"
        // 2.显示保存结果
        SVProgressHUD.showInfo(withStatus: message)
    }
}

extension PhotoBrowerViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(urlArr.count)
        return urlArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell  = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowerCellID, for: indexPath) as! PhotoBrowerCollectionViewCell
        //图片的url
        cell.url = urlArr[indexPath.item]
        //设置代理 手势代理
        cell.delegate = self as PhotoBrowerCollectionViewCellDelegate
        
        return cell
    }
    
}


extension PhotoBrowerViewController : PhotoBrowserDismissDelegate {
    func imageViewForDismiss() -> UIImageView {
        // 创建UIImageView对象
        let tempImageView = UIImageView()
        // 设置属性
        tempImageView.contentMode = .scaleAspectFill
        tempImageView.clipsToBounds = true
        // 获取cell
        let cell = collectionView.visibleCells[0] as! PhotoBrowerCollectionViewCell
        // cell的图片
        tempImageView.image = cell.pictureImageView.image
        // 图片的尺寸转相对坐标系
        tempImageView.frame = cell.scrollView.convert(cell.pictureImageView.frame, to: UIApplication.shared.keyWindow)
        //返回图片
        return tempImageView
    }
    
    func indexPathForDismiss() -> NSIndexPath {
        //显示中的cell
        let cell = collectionView.visibleCells.first
        //cell的index
        return collectionView.indexPath(for: cell!)! as NSIndexPath
    }
}

//cell 手势图片点击的代理
extension PhotoBrowerViewController : PhotoBrowerCollectionViewCellDelegate {
    func pictureClick() {
        //关闭按钮点击
        closeBtnClick()
    }
}

//布局
class PhotoBrowerCellFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        //设置item的大小
        itemSize = (collectionView?.frame.size)!
        //行间距
        minimumLineSpacing = 0
        //列间距
        minimumInteritemSpacing = 0
        //滚动方向
        scrollDirection = .horizontal
        //竖滚动条
        collectionView?.showsVerticalScrollIndicator = false
        //横滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        //分页
        collectionView?.isPagingEnabled = true
    }
}
