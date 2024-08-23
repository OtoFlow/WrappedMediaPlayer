//
//  QueueManager.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/19.
//

import Foundation

final class QueueManager<Item> {

    private let _lock = NSRecursiveLock()

    private func synchronize<T>(_ closure: () -> (T)) -> T {
        _lock.lock()
        defer { _lock.unlock() }
        return closure()
    }

    private func resolveIndexing<T>(
        using resolve: () -> (),
        run closure: () -> (T)
    ) -> T {
        let shouldResolve = !items.isEmpty
        defer { if shouldResolve { resolve() } }
        return closure()
    }

    private var currentIndex: Int = -1

    @Published
    private(set) var currentItem: Item?

    @Published
    private(set) var items: [Item] = [] {
        didSet {
            if oldValue.isEmpty && items.count > 0 {
                jump(to: 0)
            }
        }
    }

    var previousItems: [Item] {
        synchronize {
            Array(items[0..<currentIndex])
        }
    }

    var nextItems: [Item] {
        synchronize {
            Array(items[currentIndex + 1..<items.count])
        }
    }

    func replace(using newItem: Item) {
        synchronize {
            resolveIndexing {
                jump(to: 0)
            } run: {
                items = [newItem]
            }
        }
    }

    func replace(using newItems: [Item]) {
        synchronize {
            resolveIndexing {
                jump(to: 0)
            } run: {
                items = newItems
            }
        }
    }

    func append(_ newItem: Item) {
        synchronize {
            items.append(newItem)
        }
    }

    func append(_ newItems: [Item]) {
        synchronize {
            items.append(contentsOf: newItems)
        }
    }

    func insert(_ newItem: Item, at index: Int) {
        synchronize {
            guard index >= 0 && index <= items.count else {
                return
            }
            if index <= currentIndex {
                currentIndex += 1
            }
            items.insert(newItem, at: index)
        }
    }

    func insert(_ newItems: [Item], at index: Int) {
        synchronize {
            guard index >= 0 && index <= items.count else {
                return
            }
            if index <= currentIndex {
                currentIndex += newItems.count
            }
            items.insert(contentsOf: newItems, at: index)
        }
    }

    func insertNext(_ newItem: Item) {
        synchronize {
            items.insert(newItem, at: currentIndex + 1)
        }
    }

    func insertNext(_ newItems: [Item]) {
        synchronize {
            items.insert(contentsOf: newItems, at: currentIndex + 1)
        }
    }

    private enum SkipDirection: Int {
        case previous = -1
        case next = 1
    }

    private func skip(direction: SkipDirection, cycle: Bool) -> Item? {
        guard items.count > 0 else {
            return nil
        }
        var index = currentIndex + direction.rawValue
        if cycle {
            index %= items.count
        }
        guard index >= 0 && index < items.count,
              index != currentIndex || cycle
        else {
            return nil
        }
        currentIndex = index
        currentItem = items[index]
        return currentItem
    }

    func previous(cycle: Bool = false) -> Item? {
        synchronize {
            skip(direction: .previous, cycle: cycle)
        }
    }

    func next(cycle: Bool = false) -> Item? {
        synchronize {
            skip(direction: .next, cycle: cycle)
        }
    }

    @discardableResult
    func jump(to index: Int) -> Item? {
        synchronize {
            guard index >= 0 && index < items.count else {
                return nil
            }
            currentIndex = index
            currentItem = items[index]
            return currentItem
        }
    }
}
