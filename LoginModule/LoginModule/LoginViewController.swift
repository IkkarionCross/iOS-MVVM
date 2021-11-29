//
//  LoginViewController.swift
//  LoginModule
//
//  Created by Victor Amaro on 11/10/21.
//

import UIKit
import Coordinator

class LoginViewController: UIViewController {
    
    var coordinator: LoginCoordinator?
    
    private lazy var loginButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onLoginTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        arrangeViews()
    }
    
    private func arrangeViews() {
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -50.0).isActive = true
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
    
    @objc private func onLoginTapped() {
        self.coordinator?.loginSuccessful()
    }
    
    @objc private func onRegisterTapped() {
        self.coordinator?.registerFlow()
    }
}

extension LoginViewController: CoordinatableViewController {}
