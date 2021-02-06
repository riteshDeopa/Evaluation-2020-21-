//
//  UIStoryboardExtension.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

extension UIStoryboard {

    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func instantiateViewController<T>(withId: String? = nil, forClass: T.Type) -> T? {
        let sceneId = withId ?? String(describing: T.self)
        return self.instantiateViewController(withIdentifier: sceneId) as? T
    }
}
