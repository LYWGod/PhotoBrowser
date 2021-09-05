//
//  PhotoBrowerCollectionViewCell.swift
//  PhotoBrowser
//
//  Created by chenzhen on 2019/7/9.
//  Copyright © 2019 LYW. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowerCollectionViewCellDelegate : NSObjectProtocol {
    func pictureClick()
}

class PhotoBrowerCollectionViewCell: UICollectionViewCell {
    
        @objc var url : URL? {
            didSet{
                guard let picUrl = url else { return }
                
                let picture = SDWebImageManager.shared().imageCache?.imageFromCache(forKey:picUrl.absoluteString)
                
                guard let pictureImage = picture else { return }
                // 3.计算imageView的位置和尺寸
                calculateImageFrame(image: pictureImage)

                pictureImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""), options: [], progress: { (current, total, _) in
                    
                }) { (image, _, _, _) in
                    if image != nil {
                        self.calculateImageFrame(image:image!)
                        self.pictureImageView.image = image
                    }
                }
                
            }
        }
    
        /// 计算imageView的frame和显示位置
        private func calculateImageFrame(image : UIImage) {
            // 1.计算位置
            let imageWidth = UIScreen.main.bounds.width
            let imageHeight = image.size.height / image.size.width * imageWidth
            
            // 2.设置frame
            pictureImageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
            // 3.设置contentSize
            scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
            
            // 4.判断是长图还是短图
            if imageHeight < UIScreen.main.bounds.height { // 短图
                // 设置偏移量
                let topInset = (UIScreen.main.bounds.height - imageHeight) * 0.5
                scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            } else { // 长图
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    
        //scrollView
        var scrollView = UIScrollView()
        //图片
        var pictureImageView = UIImageView()
        //代理
        var delegate : PhotoBrowerCollectionViewCellDelegate?
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupUI() {
            contentView.addSubview(scrollView)
            scrollView.addSubview(pictureImageView)
            scrollView.frame = bounds
            scrollView.frame.size.width -= 20
            
            // 4.设置scrollView的代理
//            scrollView.delegate = self
//            scrollView.minimumZoomScale = 0.5
//            scrollView.maximumZoomScale = 1.5
            //给图片添加手势
            pictureImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(pictureClick))
            pictureImageView.addGestureRecognizer(tap)
        }
    
        @objc func pictureClick() {
            delegate?.pictureClick()
        }
}


//extension PhotoBrowerCollectionViewCell : UIScrollViewDelegate {
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return pictureImageView
//    }
//    
//    // view : 被缩放的视图
//    // scale : 当前缩放的比例
//    private func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        var topInset = (scrollView.bounds.height - view!.frame.size.height) * 0.5
//        topInset = topInset < 0 ? 0 : topInset
//        
//        var leftInset = (scrollView.bounds.width - view!.frame.size.width) * 0.5
//        leftInset = leftInset < 0 ? 0 : leftInset
//        
//        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: 0, right: 0)
//    }
//    
//    private func scrollViewDidZoom(scrollView: UIScrollView) {
//        // 当缩小到一定比例,则自动退出控制器
//        
//    }
//}
