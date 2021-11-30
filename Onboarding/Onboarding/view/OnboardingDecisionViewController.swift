//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by Victor Amaro on 13/11/21.
//

import UIKit
import Coordinator

protocol PDecisionDelegate {
    func decision1()
    func decision2()
}

class OnboardingDecisionViewController: UIViewController {
    
    private var viewModel: OnboardingDecisionViewModel
    
    private lazy var decision1: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.decision1Title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(decision1Tapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var decision2: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.decision2Title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(decision2Tapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8.0
        stack.distribution = .fill
        stack.alignment = .center
        
        stack.addArrangedSubview(decision1)
        stack.addArrangedSubview(decision2)
        
        return stack
    }()
    
    weak var coordinator: OnBoardingCoordinator?
    
    var decisionDelegate: PDecisionDelegate?
    
    init(viewModel: OnboardingDecisionViewModel) {
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
    
    private func arrangeViews() {
        view.addSubview(buttonsStackView)
        
        buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func decision1Tapped() {
        decisionDelegate?.decision1()
    }
    
    @objc private func decision2Tapped() {
        decisionDelegate?.decision2()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            coordinator?.back()
        }
    }
}

extension OnboardingDecisionViewController: CoordinatableViewController {}
