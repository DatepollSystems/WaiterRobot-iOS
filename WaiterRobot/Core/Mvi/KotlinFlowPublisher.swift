/// Base on
/// - https://johnoreilly.dev/posts/kotlinmultiplatform-swift-combine_publisher-flow/
/// - https://proandroiddev.com/kotlin-multiplatform-mobile-sharing-the-ui-state-management-a67bd9a49882
/// - https://github.com/orbit-mvi/orbit-swift-gradle-plugin/blob/main/src/main/resources/Publisher.swift.mustache

import Combine
import Foundation
import shared

public extension Kotlinx_coroutines_coreFlow {
	func asPublisher<T: Any>() -> AnyPublisher<T, Never> {
		(KotlinFlowPublisher(flow: self) as KotlinFlowPublisher<T>).eraseToAnyPublisher()
	}
}

private struct KotlinFlowPublisher<T: Any>: Publisher {
	public typealias Output = T
	public typealias Failure = Never
	private let flow: Kotlinx_coroutines_coreFlow

	public init(flow: Kotlinx_coroutines_coreFlow) {
		self.flow = flow
	}

	public func receive<S: Subscriber>(subscriber: S) where S.Input == T, S.Failure == Failure {
		let subscription = FlowSubscription(flow: flow, subscriber: subscriber)
		subscriber.receive(subscription: subscription)
	}

	final class FlowSubscription<S: Subscriber>: Subscription where S.Input == T, S.Failure == Failure {
		private var subscriber: S?
		private let job: Kotlinx_coroutines_coreJob?
		private let flow: Kotlinx_coroutines_coreFlow

		init(flow: Kotlinx_coroutines_coreFlow, subscriber: S) {
			self.flow = flow
			self.subscriber = subscriber
			job = FlowUtilsKt.subscribe(
				flow,
				onEach: { position in
					if let position = position as? T {
						_ = subscriber.receive(position)
					}
				},
				onComplete: { subscriber.receive(completion: .finished) },
				onThrow: { _ in
					// TODO:
					// logger.error(message: "got error in Flow subscription", throwable: error)
				}
			)
		}

		func cancel() {
			subscriber = nil
			job?.cancel(cause: nil)
		}

		func request(_: Subscribers.Demand) {}
	}
}
