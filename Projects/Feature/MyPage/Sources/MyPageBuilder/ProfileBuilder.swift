// Content of KeepSources.swift
import SwiftUI

// MARK: - MyPageNavigationController

public final class MyPageNavigationController: UINavigationController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    let vc = MyPageMainRouter()
    vc.safeAreaRegions = .container
    setViewControllers([vc], animated: false)
  }
}

// MARK: - ProfileNavigationView

public struct ProfileNavigationView: UIViewControllerRepresentable {
  public init() {}
  private var vc = MyPageNavigationController()
  public func makeUIViewController(context _: Context) -> MyPageNavigationController {
    return vc
  }

  public func updateUIViewController(_: MyPageNavigationController, context _: Context) {}

  public typealias UIViewControllerType = MyPageNavigationController
}
