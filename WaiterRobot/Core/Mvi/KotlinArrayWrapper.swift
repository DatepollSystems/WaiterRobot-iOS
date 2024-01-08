import Foundation
import shared

@objc public class KotlinIteratorImpl: NSObject, KotlinIterator, IteratorProtocol {
    public typealias Element = KotlinInt

    var iterator: KotlinIterator

    init(iterator: KotlinIterator) {
        self.iterator = iterator
    }

    public func next() -> Any? {
        if hasNext() {
            iterator.next()
        } else { nil }
    }

    public func next() -> KotlinInt? {
        if hasNext() {
            (iterator.next() as! KotlinInt?)
        } else { nil }
    }

    public func hasNext() -> Bool {
        iterator.hasNext()
    }
}

extension KotlinArray: Sequence {
    @objc public func makeIterator() -> KotlinIteratorImpl {
        KotlinIteratorImpl(iterator: iterator())
    }
}

extension Array where Element: AnyObject {
    init(_ kotlinArray: KotlinArray<Element>) {
        self.init()
        let iterator = kotlinArray.iterator()
        while iterator.hasNext() {
            append(iterator.next() as! Element)
        }
    }
}
