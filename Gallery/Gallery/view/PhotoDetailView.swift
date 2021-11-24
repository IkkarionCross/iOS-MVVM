//
//  PhotoDetailView.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 11/10/21.
//

import UIKit


class PhotoDetailView {
    
    lazy var view: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addSubview(image)
        stack.addSubview(title)
        
        image.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        image.widthAnchor.constraint(greaterThanOrEqualToConstant: 150.0).isActive = true
        image.heightAnchor.constraint(greaterThanOrEqualToConstant: 150.0).isActive = true
        
        title.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true

        return stack
        
    }()
    
    lazy var image: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
}
