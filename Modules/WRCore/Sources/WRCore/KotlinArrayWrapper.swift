import Foundation
import shared

public extension Array where Element: AnyObject {
    init?(_ kotlinArray: KotlinArray<Element>?) {
        guard let array = kotlinArray else {
            return nil
        }
        self.init()
        let iterator = array.iterator()
        while iterator.hasNext() {
            append(iterator.next() as! Element)
        }
    }
}
