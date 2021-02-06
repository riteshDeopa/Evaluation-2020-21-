//
//  Coordinator.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import Foundation
import UIKit

public protocol Event {}

public protocol EventDrivenInterface {

    func propagate<T: Event>(event: T)
    func raise<T: Event>(event: T)
    func addHandler<T: Event>(_ handler: @escaping (T) -> Void)
}

public protocol FlowInialiser {

    func createFlow() -> UIViewController
}

protocol EventHandleable {}

private class EventHandlersContainer<T>: EventHandleable {

    private var handlers: [(T) -> Void] = []

    func add(handler: @escaping (T) -> Void) {
        handlers.append(handler)
    }

    func propagate(event: T) {
        for handler in handlers {
            handler(event)
        }
    }

}

open class Coordinator: EventDrivenInterface {

    private var parent: Coordinator?
    fileprivate lazy var children = NSHashTable<Coordinator>.weakObjects()
    private var eventHandlerContainers: [String: EventHandleable] = [:]

    fileprivate let identifier = ProcessInfo.processInfo.globallyUniqueString

    private init() {}

    public init(parent: Coordinator?) {
        parent?.addChild(self)
    }

    deinit {
        print("Deinit of node: \(self)")
    }

    public func propagate<T: Event>(event: T) {
        let etype = String(reflecting: type(of: T.self))

        if let handler = eventHandlerContainers[etype] as? EventHandlersContainer<T> {
            handler.propagate(event: event)
        }

        children.allObjects.forEach {
            $0.propagate(event: event)
        }
    }

    func raise<T: Event>(event: T, from sender: EventDrivenInterface) {
        guard let parent = parent else {
            propagate(event: event)

            return
        }

        parent.raise(event: event, from: sender)
    }

    public func raise<T: Event>(event: T) {
        raise(event: event, from: self)
    }

    func addChild(_ child: Coordinator) {
        child.parent = self
        children.add(child)
    }

    func removeChild(_ child: Coordinator) {
        children.remove(child)
    }

    func removeAllChildrens() {
        children.removeAllObjects()
    }

    func findCoordinatorType(_ item: Coordinator.Type) -> Coordinator? {
        var greatParent = self
        while nil != greatParent.parent {
            greatParent = greatParent.parent!
        }
        return self.findCoordinator(item, parent: greatParent)
    }

    private func findCoordinator(_ item: Coordinator.Type, parent: Coordinator) -> Coordinator? {
        let item1 = type(of: parent)

        guard item1 != item else { return parent }

        if let fIdx = parent.children.allObjects.firstIndex(where: { (child) -> Bool in
            let type1 = type(of: child)
            return type1 == item
        }) {
            return parent.children.allObjects[fIdx]
        } else {
            for it1 in parent.children.allObjects {
                if let foundItem = self.findCoordinator(item, parent: it1) {
                    return foundItem
                }
            }
        }
        return nil
    }

    public func addHandler<T: Event>(_ handler: @escaping (T) -> Void) {
        let eType = String(reflecting: type(of: T.self))
        var container = eventHandlerContainers[eType]
        if container == nil {
            container = EventHandlersContainer<T>()
            eventHandlerContainers[eType] = container
        }
        if let container = container as? EventHandlersContainer<T> {
            container.add(handler: handler)
        }
    }

}
