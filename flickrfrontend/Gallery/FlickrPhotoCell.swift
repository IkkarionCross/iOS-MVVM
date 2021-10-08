//
//  FlickrPhotoCell.swift
//  flickrfrontend
//
//  Created by victor amaro on 27/05/21.
//

import UIKit
import Kingfisher

class FlickrPhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "FlickrCell"
    
    lazy var photoTitle: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var image: UIImageView = {
        let imageview: UIImageView = UIImageView(frame: .zero)
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    weak var router: GalleryRouter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withPhoto photo: PhotoViewModel,
                   imagePlaceHolder: UIImage?=nil,
                   router: GalleryRouter) {
        self.photoTitle.text = photo.title
        image.image = imagePlaceHolder
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(openImageView))
        image.addGestureRecognizer(gestureRecognizer)
        self.router = router
    }
    
    func setImage(withUrl url: URL, andPlaceHolder placeHolder: UIImage?) {
        let imageResource = ImageResource(downloadURL: url)
        let processor = DownsamplingImageProcessor(size: image.bounds.size)
        image.kf.setImage(with: imageResource, placeholder: placeHolder,
                               options:
                                [
                                    .processor(processor),
                                    .transition(.fade(0.5)),
                                    .cacheOriginalImage
                               ])
    }
    
    @objc func openImageView() {}
    
    func clearForReuse(withPlaceHolder placeHolderImage: UIImage?) {
        image.image = placeHolderImage
        image.kf.cancelDownloadTask()
        photoTitle.text = ""
    }
    
    func arrangeSubViews() {
        addSubview(image)
        addSubview(photoTitle)
        
        image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        photoTitle.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        photoTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
}
