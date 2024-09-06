import ComposableArchitecture

// Content of KeepSources.swift
import SwiftUI

// MARK: - MyPageNavigationController

public final class MyPageNavigationController: UINavigationController {
  let vc = MyPageMainRouter()
  override public func viewDidLoad() {
    super.viewDidLoad()

    vc.safeAreaRegions = .container
    setViewControllers([vc], animated: false)
  }
}

// MARK: - ProfileNavigationView

public struct ProfileNavigationView: UIViewControllerRepresentable {
  public init() {}
  @State private var vc = MyPageNavigationController()
  public func makeUIViewController(context _: Context) -> MyPageNavigationController {
    return vc
  }

  public func updateUIViewController(_: MyPageNavigationController, context _: Context) {}

  public typealias UIViewControllerType = MyPageNavigationController
}
