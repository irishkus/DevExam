//
//  LoginViewController.swift
//  DevExam
//
//  Created by Ирина Соловьева on 12/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import SnapKit
import SwiftKeychainWrapper
import JMMaskTextField_Swift

class LoginViewController: UIViewController {
    private let phoneNumber = JMMaskTextField()
    private let password = UITextField()
    private let signIn = UIButton()
    private let logoImage = UIImageView()
    private let lineNumberPhone = UIView()
    private let linePassword = UIView()
    private var mask = JMStringMask(mask: "000-0000-0000")
    private var maskTextField = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
    }
    
    private func createUI() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(logoImage)
        view.addSubview(phoneNumber)
        view.addSubview(password)
        view.addSubview(signIn)
        view.addSubview(lineNumberPhone)
        view.addSubview(linePassword)
        logoImage.image = UIImage(named: "logo")
        textFieldsUI()
        buttonUI()
        settingsConstraints()
    }
    
    //настройка констрейнтов между элементами UI
    private func settingsConstraints() {
        let guide = view.safeAreaLayoutGuide
        logoImage.snp.makeConstraints { (make) in
            make.top.equalTo(guide).offset(25)
            make.centerX.equalTo(guide)
        }
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(logoImage.snp.bottom).offset(30)
            make.left.equalTo(guide).offset(20)
            make.right.equalTo(guide)
        }
        lineNumberPhone.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom).offset(7)
            make.left.equalTo(guide).offset(20)
            make.right.equalTo(guide)
            make.height.equalTo(2)
        }
        linePassword.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(7)
            make.left.equalTo(guide).offset(20)
            make.right.equalTo(guide)
            make.height.equalTo(2)
        }
        password.snp.makeConstraints { (make) in
            make.left.equalTo(guide).offset(20)
            make.right.equalTo(guide).offset(-20)
            make.top.equalTo(lineNumberPhone.snp.bottom).offset(30)
        }
        signIn.snp.makeConstraints { (make) in
            make.top.equalTo(linePassword.snp.bottom).offset(20)
            make.centerX.equalTo(guide)
        }
    }
    
    //внешний вид textFields
    private func textFieldsUI() {
        textInPhoneNumber()
        lineNumberPhone.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                               attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        phoneNumber.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        password.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        password.text =  KeychainWrapper.standard.string(forKey: "password")
        linePassword.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    //заполнение поля ввода телефона, если сохраненный номер не соответсвует сохраненной маске, то выводится алерт
    private func textInPhoneNumber() {
        Requests.getMask(completion: { (mask) in
            if mask == "" {
                self.phoneNumber.text = KeychainWrapper.standard.string(forKey: "phoneNumber")
                self.mask = JMStringMask(mask: mask)
            } else {
                if let maskKeychain = KeychainWrapper.standard.string(forKey: "mask") {
                    if mask == maskKeychain {
                        self.phoneNumber.text = KeychainWrapper.standard.string(forKey: "phoneNumber")
                    } else {
                        let alert = UIAlertController(title: "Сохраненный номер телефона не соответсвует текущей маске \(mask), введите новый номер", message: nil, preferredStyle: .alert)
                        let actionOK = UIAlertAction(title: "ОК", style: .default, handler: nil)
                        alert.addAction(actionOK)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                self.mask = JMStringMask(mask: mask)
                self.phoneNumber.maskString = self.changeCharacters(mask: mask)
                self.maskTextField = mask
            }
        })
    }
    
    private func changeCharacters(mask: String) -> String {
        var result = ""
        mask.forEach { (char) in
            if char == "Х" {
                result.append("0")
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    //внешний вид кнопки входа
    private func buttonUI() {
        signIn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        signIn.setTitle("  Sign In  ", for: .normal)
        signIn.layer.borderWidth = 2
        signIn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        signIn.layer.shadowColor = UIColor.black.cgColor
        signIn.layer.shadowOffset = CGSize(width: 2, height: 2)
        signIn.layer.shadowRadius = 2
        signIn.layer.shadowOpacity = 1.0
        signIn.layer.masksToBounds = false
        signIn.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
    }
    
    //нажатие кнопки входа, если сети нет то в любом случает открывается следующий экран, если есть то проверка логина-пароля, если правильные то открывается следующий экран
    @objc private func buttonTapped(button: UIButton) {
        signIn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.signIn.transform = .identity
            },
                       completion: nil)
        guard let number = phoneNumber.text,
            let pas = password.text,
            let unmask = mask.unmask(string: number)else {return}
        Requests.postPhoneAndPass(phone: unmask, password: pas) { (result) in
            print(result)
            if result {
                KeychainWrapper.standard.set("\(self.maskTextField)", forKey: "mask")
                KeychainWrapper.standard.set("\(number)", forKey: "phoneNumber")
                KeychainWrapper.standard.set("\(pas)", forKey: "password")
                let navigationController = UINavigationController(rootViewController: DevExamViewController())
                self.present(navigationController, animated: true, completion: nil)
            } else {
                if self.mask == JMStringMask(mask: "") {
                    let navigationController = UINavigationController(rootViewController: DevExamViewController())
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Не правильный логин/пароль", message: nil, preferredStyle: .alert)
                    let actionOK = UIAlertAction(title: "ОК", style: .default, handler: nil)
                    alert.addAction(actionOK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

