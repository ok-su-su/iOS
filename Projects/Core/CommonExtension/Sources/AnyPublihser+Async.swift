//
//  AnyPublihser+Async.swift
//  CommonExtension
//
//  Created by MaraMincho on 9/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

public extension AnyPublisher {
  public func async() async throws -> Output {
    try await withCheckedThrowingContinuation { continuation in
      var cancellable: AnyCancellable?

      cancellable = first()
        .sink { result in
          switch result {
          case .finished:
            break
          case let .failure(error):
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        } receiveValue: { value in
          continuation.resume(with: .success(value))
        }
    }
  }
}
