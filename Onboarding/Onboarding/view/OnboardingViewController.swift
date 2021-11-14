//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by Victor Amaro on 01/11/21.
//

import UIKit
import Coordinator

class OnboardingViewController: UIViewController {
    
    private var viewModel: OnboardingViewModel
    
    private lazy var field: UITextField = {
        let field: UITextField = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = viewModel.placeHolder
        
        return field
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.actionButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var coordinator: OnBoardingCoordinator?
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        arrangeViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func arrangeViews() {
        view.addSubview(actionButton)
        view.addSubview(field)
        
        field.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        field.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0).isActive = true
        
        actionButton.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 16.0).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func actionButtonTapped() {
        coordinator?.nextScreen()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            coordinator?.back()
        }
    }
}

extension OnboardingViewController: CoordinatableViewController {}
