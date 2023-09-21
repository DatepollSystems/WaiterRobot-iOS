import Foundation
import shared

extension Int64 {
    func toKotlinLong() -> KotlinLong {
        KotlinLong(value: self)
    }
}
