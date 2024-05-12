// Content of KeepSources.swift
import SwiftUI

// MARK: - ProfileBuilder

struct ProfileBuilder: View {
  var body: some View {
    ProfileRouterView(store: .init(initialState: ProfileRouter.State()) {
      ProfileRouter()
    })
  }
}

// MARK: - ProfileBuilderHostingViewController

final class ProfileBuilderHostingViewController: UIHostingController<ProfileBuilder> {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - MyPageNavigationController

public final class MyPageNavigationController: UINavigationController {
  override public func viewDidLoad() {
    super.viewDidLoad()
    setViewControllers([MyPageMainRouter()], animated: false)
  }
}

// MARK: - ProfileNavigationView

public struct ProfileNavigationView: UIViewControllerRepresentable {
  public init() {}
  public func makeUIViewController(context _: Context) -> MyPageNavigationController {
    MyPageNavigationController()
  }

  public func updateUIViewController(_: MyPageNavigationController, context _: Context) {}

  public typealias UIViewControllerType = MyPageNavigationController
}
