//
//  ViewController.swift
//  UserBehaviorDrivenExampleUITests
//
//  Created by Peteranny on 2024/3/6.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray

        let label = UILabel(frame: UIScreen.main.bounds)
        label.accessibilityIdentifier = "welcome.label"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0

        var button: UIButton!
        button = UIButton(frame: UIScreen.main.bounds, primaryAction: UIAction(title: "Log In") { [unowned self] _ in
            let vc = FormViewController(nibName: nil, bundle: nil)
            vc.onLoginSuccess = { account in
                label.text = "Welcome back, \(account)!"
                label.isHidden = false
                button.isHidden = true
            }
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        })

        view.addSubview(label)
        view.addSubview(button)
    }
}

class FormViewController: UIViewController {
    var onLoginSuccess: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpForm()
        setUpDoubleTap()
        setUpLongPress()
    }

    private func setUpForm() {
        view.backgroundColor = .lightGray
        title = "Enter You Information"

        let defaults = UserDefaults.standard
        let presetKey = "account.preset"

        let rememberMeSwitch = UISwitch()
        rememberMeSwitch.isOn = defaults.string(forKey: presetKey).map { $0.isEmpty == false } ?? false
        rememberMeSwitch.accessibilityIdentifier = "remember.switch"
        let rememberMeLabel = UILabel()
        rememberMeLabel.text = "Remember me"
        let rememberMeStackView = UIStackView(arrangedSubviews: [rememberMeSwitch, rememberMeLabel])
        rememberMeStackView.alignment = .center
        rememberMeStackView.spacing = 8

        let accountField = UITextField()
        accountField.text = defaults.string(forKey: presetKey)
        accountField.placeholder = "Account"
        accountField.borderStyle = .roundedRect
        accountField.accessibilityIdentifier = "account"

        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.accessibilityIdentifier = "password"

        let button = UIButton(primaryAction: UIAction(title: "Submit") { [unowned self] _ in
            defer {
                if rememberMeSwitch.isOn {
                    defaults.setValue(accountField.text!, forKey: presetKey)
                } else {
                    defaults.removeObject(forKey: presetKey)
                }
                defaults.synchronize()
            }

            if accountField.text == "P.S@g.com" && passwordField.text == "000000" {
                dismiss(animated: true)
                onLoginSuccess?(accountField.text!)
            } else {
                let alert = UIAlertController(title: "Incorrect", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in alert.dismiss(animated: true) })
                present(alert, animated: true)
            }
        })
        button.backgroundColor = .cyan

        let stackView = UIStackView(arrangedSubviews: [accountField, passwordField, button])
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually

        let vStackView = UIStackView(arrangedSubviews: [stackView, rememberMeStackView])
        vStackView.axis = .vertical
        vStackView.alignment = .fill
        vStackView.distribution = .fillEqually
        vStackView.frame = UIScreen.main.bounds

        view.addSubview(vStackView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: UIAction { [unowned self] _ in
            dismiss(animated: true)
        })
    }

    private func setUpDoubleTap() {
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleGesture.numberOfTapsRequired = 2
        navigationController?.navigationBar.addGestureRecognizer(doubleGesture)
    }

    @objc
    func didDoubleTap() {
        let alert = UIAlertController(title: "Double Tapped", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in alert.dismiss(animated: true) })
        present(alert, animated: true)
    }

    private func setUpLongPress() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        longPressGesture.minimumPressDuration = 2
        navigationController?.navigationBar.addGestureRecognizer(longPressGesture)
    }

    @objc
    func didLongPress() {
        let alert = UIAlertController(title: "Long Pressed", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in alert.dismiss(animated: true) })
        present(alert, animated: true)
    }
}

