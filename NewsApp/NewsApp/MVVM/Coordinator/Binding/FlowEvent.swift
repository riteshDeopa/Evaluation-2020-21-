//
//  FlowEvent.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

enum NewsEvent: Event {
    case searchScreen(data: [Articles])
    case bookmark
}
