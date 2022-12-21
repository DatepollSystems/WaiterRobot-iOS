import Foundation
import SwiftUI
import shared
import UIPilot

func handleNavigation(_ navAction: NavAction, _ navigator: UIPilot<Screen>) {
  koin.logger(tag: "Navigation").d { "Handle navigation: \(navAction.description)" }
  switch navAction {
  case is NavAction.Pop:
    navigator.pop()
  case let nav as NavAction.Push:
    navigator.push(nav.screen)
  case let nav as NavAction.PopUpTo:
    navigator.popTo(nav.screen, inclusive: nav.inclusive)
  case let nav as NavAction.PopUpAndPush:
    navigator.popTo(nav.popUpTo, inclusive: nav.inclusive)
    navigator.push(nav.screen)
  default:
    koin.logger(tag: "Navigation").e {
      "No nav action for nav effect \(navAction.self.description)"
    }
  }
}
