//
//  PhotoDetailViewController.swift
//  flickrfrontend
//
//  Created by Victor Amaro on 10/10/21.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }
    
    var coordinator: AppCoordinator?
    var photoDetailView: PhotoDetailView
    
    private var viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        photoDetailView = PhotoDetailView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        arrangeSubviews()
        photoDetailView.title.text = viewModel.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupImage()
    }
    
    private func setupImage() {
        
        guard let url = URL(string: viewModel.largeSquareImageUrl ?? "") else {
            return
        }
        let imageResource = ImageResource(downloadURL: url)
        let processor = DownsamplingImageProcessor(size: photoDetailView.image.bounds.size)
        photoDetailView.image.kf.setImage(with: imageResource,
                                          options:
                                           [
                                               .processor(processor),
                                               .transition(.fade(0.5)),
                                               .cacheOriginalImage
                                          ])
    }
    
    private func arrangeSubviews() {
        view.addSubview(photoDetailView.view)
        photoDetailView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoDetailView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoDetailView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        photoDetailView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}
