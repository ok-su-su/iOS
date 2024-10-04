//
//  KeyBoardNotification.swift
//  Designsystem
//
//  Created by MaraMincho on 8/14/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation
import UIKit

// MARK: - KeyboardReadable

/// Publisher to read keyboard changes.
public protocol KeyboardReadable {
  var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

public extension KeyboardReadable {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers.Merge(
      NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { _ in true },

      NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in false }
    )
    .eraseToAnyPublisher()
  }
}

// MARK: - KeyBoardReadablePublisher

public final class KeyBoardReadablePublisher: KeyboardReadable, @unchecked Sendable {
  public static let shared: KeyBoardReadablePublisher = .init()
  private init() {}
}
