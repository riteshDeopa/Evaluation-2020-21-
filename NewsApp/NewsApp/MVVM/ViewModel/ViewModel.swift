//
//  ViewModel.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

public class ViewModel {
    ///Flow coordinator
    var coordinator: Coordinator?

    init(withCoordinator: Coordinator?) {
        coordinator = withCoordinator
    }
}
