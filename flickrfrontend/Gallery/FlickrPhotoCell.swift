//
//  FlickrPhotoCell.swift
//  flickrfrontend
//
//  Created by victor amaro on 27/05/21.
//

import Foundation
import Kingfisher

class FlickrPhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func configure(withPhoto photo: PhotoViewModel, imagePlaceHolder: UIImage?=nil) {
        self.photoTitle.text = photo.title
        image.image = imagePlaceHolder
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
    
    
    func clearForReuse(withPlaceHolder placeHolderImage: UIImage?) {
        image.image = placeHolderImage
        image.kf.cancelDownloadTask()
        photoTitle.text = ""
    }
}
