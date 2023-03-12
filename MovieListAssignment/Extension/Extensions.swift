//
//  Extensions.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit


class ImageCache {
    private init() {}
    static let shared = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getImage(from url: URL) {
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            print("Image from cache")
            self.image = cachedImage
        }
        
        downloadImage(from: url) { (data, response, error) in
            if let _ = error {
                self.image = nil
            } else if let imgData = data, let image = UIImage(data: imgData) {
                ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
                print("Image to cache")
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTapAnyWhere(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func showError(message: String, hideBtn: Bool = false) {
        let errView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        errView.tag = 11298756
        errView.backgroundColor = UIColor(named: "errBG")
        
        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .white
        label.textAlignment = .center
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.tintColor = .white
        
        self.view.addSubview(errView)
        errView.addSubview(label)
        errView.addSubview(button)
        
        errView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var other: CGFloat = -10
        
        if (UIDevice().userInterfaceIdiom == .phone) && (UIScreen.main.nativeBounds.height != 2436){
            other = 0
            NSLayoutConstraint.activate([ errView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50) ])
        }
        
        var topConstraint = errView.topAnchor.constraint(equalTo: label.topAnchor)
        
        if #available(iOS 11.0, *) {
            topConstraint = errView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: label.topAnchor)
        }
        
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: errView.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: errView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: errView.trailingAnchor),
            errView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: other),
            errView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16),
            errView.leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -16),
            topConstraint,
            errView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            errView.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: other),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            errView.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        }, completion: nil)
        
        
        button.addTarget(self, action: #selector(dismissErrorView), for: .touchUpInside)
        
        if hideBtn {
            button.isHidden = true
            UIView.animate(withDuration: 4, animations: {
                errView.alpha = 1
            }) { _ in
                errView.removeFromSuperview()
            }
        }
        
    }
    
    
    @objc fileprivate func dismissErrorView() {
        
        if let errView = view.viewWithTag(11298756) {
            UIView.animate(withDuration: 0.4, animations: {
                errView.alpha = 1
            }) { _ in
                self.view.subviews.forEach({ (view) in
                    if view.tag == 11298756 {
                        view.removeFromSuperview()
                    }
                })
            }
        }
        
    }
    
}
