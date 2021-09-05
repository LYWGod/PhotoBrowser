//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by chenzhen on 2019/7/9.
//  Copyright © 2019 LYW. All rights reserved.
//

import UIKit
import SDWebImage

//标示ID
private let cellID = "cellID"
//间隔
private let margin : CGFloat = 10

class ViewController: UIViewController {
    //collecitonView
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoCellFlowLayout())
    //存放图片url的数组
    var urlArr : [URL] = [URL]()
    //动画对象
    var animation = PhotoBrowerAnmation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20190122%2F9903e7691c5b43869f01fdb621afb927.jpeg&refer=http%3A%2F%2F5b0988e595225.cdn.sohucs.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=68458f414016b90ba7e96055905688f8")!)
       
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi04.c.aliimg.com%2Fimg%2Fibank%2F2013%2F211%2F016%2F791610112_758613609.jpg&refer=http%3A%2F%2Fi04.c.aliimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=f6dbfd377a57a2920e585132ff744f3a")!)
        
        urlArr.append(URL(string: "https://img2.baidu.com/it/u=982549611,3731122317&fm=26&fmt=auto&gp=0.jpg")!)
        
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhimg2.huanqiu.com%2Fattachment2010%2F2014%2F0219%2F20140219024324755.jpg&refer=http%3A%2F%2Fhimg2.huanqiu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=e0c9f3d9570cf02bc32df0c59212e492")!)
        
        urlArr.append(URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562660700630&di=e4f1728a0baba4c79fce2f2958d45641&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F1%2F5816eccc2e33d.jpg")!)
        
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Ffile01.16sucai.com%2Fd%2Ffile%2F2013%2F0708%2F20130708051417442.jpg&refer=http%3A%2F%2Ffile01.16sucai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=bd93f4f27464e7242ed36231c5cf76a7")!)
        
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcar0.autoimg.cn%2Fupload%2F2013%2F2%2F18%2Fu_20130218165304639264.jpg&refer=http%3A%2F%2Fcar0.autoimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=a027d8055f83574a6c8fc05f07996a83")!)
        
        urlArr.append(URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.baike.soso.com%2Fp%2F20140428%2F20140428105758-240548409.jpg&refer=http%3A%2F%2Fpic.baike.soso.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1633414159&t=b7344440b716b7c3ddeaa5920da6881b")!)
        
        urlArr.append(URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562671247854&di=37eecfd348699127b47677dd8251dd8f&imgtype=0&src=http%3A%2F%2Fwx2.sinaimg.cn%2Forj360%2F7dd58bb4gy1g2welv0sthj20u02tftlh.jpg")!)
        
    
    }
}


extension ViewController {
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellID)
    }
}


extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoCell

        cell.url = urlArr[indexPath.item]
    
        return cell
    }
}

extension ViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoVC = PhotoBrowerViewController(indexPath: indexPath, urlArr: urlArr)
        //自定义动画
        photoVC.modalPresentationStyle = .custom
        //设置谁负责动画
        photoVC.transitioningDelegate = animation
        // 4.设置photoBrowserAnimator的相关属性
        animation.indexPath = indexPath as NSIndexPath
        //设置弹出动画的代理
        animation.presentedDelegate = self
        //设置消失动画的代理
        animation.dismissDelegate = (photoVC as PhotoBrowserDismissDelegate)
        //弹出控制器
        present(photoVC, animated: true, completion: nil)
    }
    
}


// MARK:- 用于提供动画的内容
extension ViewController : PhotoBrowserPresentedDelegate {
    func imageForPresent(indexPath: NSIndexPath) -> UIImageView {
        // 1.创建用于做动画的UIImageView
        let imageView = UIImageView()
        
        // 2.设置imageView属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // 3.设置图片
        imageView.sd_setImage(with: urlArr[indexPath.item], placeholderImage: UIImage(named: "empty_picture"))
        
        return imageView
    }
    
    func startRectForPresent(indexPath: NSIndexPath) -> CGRect {
        // 1.取出cell
        guard let cell = collectionView.cellForItem(at: indexPath as IndexPath) else {
            return CGRect(x: collectionView.bounds.width * 0.5, y: UIScreen.main.bounds.height + 50, width: 0, height: 0)
        }
        
        // 2.计算转化为UIWindow上时的frame
        let startRect = collectionView.convert(cell.frame, to: UIApplication.shared.keyWindow)
        
        
        return startRect
    }
    
    func endRectForPresent(indexPath: NSIndexPath) -> CGRect {
        // 1.获取indexPath对应的URL
        let url = urlArr[indexPath.item]
        
        // 2.取出对应的image
        var image = SDWebImageManager.shared().imageCache!.imageFromDiskCache(forKey: url.absoluteString)
        
        if image == nil {
            image = UIImage(named: "empty_picture")
        }
        
        // 3.根据image计算位置
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        let imageH = screenW / image!.size.width * image!.size.height
        var y : CGFloat = 0
        if imageH < screenH {
            y = (screenH - imageH) * 0.5
        } else {
            y = 0
        }
        
        return CGRect(x: 0, y: y, width: screenW, height: imageH)
    }
}



//自定义cell
class PhotoCell: UICollectionViewCell {
    //设置cell的属性为url
    @objc var url : URL?{
        didSet{
           guard let picUrl = url else { return }
            //下载图片，并设置图片
            pictureImageView.sd_setImage(with: picUrl, placeholderImage: UIImage(named: ""), options: [], completed: nil)
            
        }
    }
    //图片属性
    var pictureImageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        pictureImageView.frame = contentView.bounds
        contentView.addSubview(pictureImageView)
        pictureImageView.contentMode = .scaleAspectFill
        pictureImageView.clipsToBounds = true
    }
}

//自定义布局
class PhotoCellFlowLayout : UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        //三个item
        let width = (UIScreen.main.bounds.width - 4 * margin)/3
        let heigth = width
        //item的大小
        itemSize = CGSize(width: width, height: heigth)
        //行间距
        minimumLineSpacing = margin
        //竖间距
        minimumInteritemSpacing = margin
        //上下左右间距
        sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        //竖滚动条
        collectionView?.showsVerticalScrollIndicator = false
        //横滚动条
        collectionView?.showsHorizontalScrollIndicator = false
    
    }
}
