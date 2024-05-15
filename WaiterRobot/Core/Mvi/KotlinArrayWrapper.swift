import Foundation
import shared

// public class KotlinIteratorImpl<T>: NSObject, KotlinIterator, IteratorProtocol {
//    public typealias Element = T
//
//    var iterator: KotlinIterator
//
//    init(iterator: KotlinIterator) {
//        self.iterator = iterator
//    }
//
//    public func next() -> Any? {
//        if hasNext() {
//            iterator.next()
//        } else {
//            nil
//        }
//    }
//
//    public func next() -> T? {
//        if hasNext() {
//            (iterator.next() as! T?)
//        } else {
//            nil
//        }
//    }
//
//    public func hasNext() -> Bool {
//        iterator.hasNext()
//    }
// }

// extension KotlinArray where T: AnyObject {
//    var array: Array<T> {
//        Array(self)
//    }
// }

// extension KotlinArray: Sequence {
//    @objc public func makeIterator() -> KotlinIteratorImpl<Any> {
//        KotlinIteratorImpl(iterator: iterator())
//    }
// }

extension Array where Element: AnyObject {
    init(_ kotlinArray: KotlinArray<Element>) {
        self.init()
        let iterator = kotlinArray.iterator()
        while iterator.hasNext() {
            append(iterator.next() as! Element)
        }
    }
}
