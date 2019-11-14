//
//  UICollectionView+Type.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import UIKit


extension UICollectionView {

    // MARK: - Cell

    func register<T: UICollectionViewCell>(_ type: T.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }

    func register<T: UICollectionViewCell>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellWithReuseIdentifier: String(describing: type))
    }

    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    // MARK: - SupplementaryView
    
    func register<T: UICollectionReusableView>(_ type: T.Type, of kind: String) {
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: type))
    }
    
    func register<T: UICollectionReusableView>(nib type: T.Type, of kind: String) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: type))
    }
    
    func dequeue<T: UICollectionReusableView>(of kind: String, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}


extension UITableView {
    
    // MARK: - Cell
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }
    
    func register<T: UITableViewCell>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: String(describing: type))
    }
    
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    // MARK: - HeaderFooterView
    
    func register<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
    
    func register<T: UITableViewHeaderFooterView>(nib type: T.Type) {
        let nib = UINib(nibName: String(describing: type), bundle: Bundle(for: type))
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: type))
    }
    
    func dequeue<T: UITableViewHeaderFooterView>() -> T {
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}
