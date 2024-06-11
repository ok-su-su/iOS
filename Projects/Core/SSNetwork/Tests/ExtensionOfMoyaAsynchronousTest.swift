//
//  ExtensionOfMoyaAsynchronousTest.swift
//  SSNetworkTests
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Moya
@testable import SSNetwork
import XCTest

final class ExtensionOfMoyaAsynchronousTest: XCTestCase {
  struct FakeDTO: Encodable, Decodable, Equatable {
    var message: String
  }

  var testTargetType: TestTargetType!
  var stubbingProvider: MoyaProvider<TestTargetType>!
  struct TestTargetType: TargetType {
    let jsonEncoder = JSONEncoder()
    var baseURL: URL = .init(string: "www.susu.com")!
    var path: String = ""
    var method: Moya.Method = .get
    var task: Moya.Task = .requestPlain
    var headers: [String: String]? = nil

    var sampleData: Data {
      try! jsonEncoder.encode(FakeDTO(message: "Hi"))
    }
  }

  override func setUpWithError() throws {
    testTargetType = .init()
    let customEndpointClosure = { (target: TestTargetType) -> Endpoint in
      return Endpoint(
        url: URL(target: target).absoluteString,
        sampleResponseClosure: { .networkResponse(200, TestTargetType().sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
      )
    }
    stubbingProvider = MoyaProvider<TestTargetType>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
  }

  override func tearDownWithError() throws {
    testTargetType = nil
    stubbingProvider = nil
  }

  func test_AsyncExtension() async throws {
    // Arrange
    let value = FakeDTO(message: "Hi")

    // Act
    let data: FakeDTO = try await stubbingProvider.request(.init())

    // Assert
    XCTAssertEqual(value, data)
  }

  func test_CombineExtension() {
    // Arrange
    let value = FakeDTO(message: "Hi")
    var cancellable: AnyCancellable? = nil
    let target = TestTargetType()
    let promise = expectation(description: "compare Values")

    // Act
    let publisher: AnyPublisher<FakeDTO, Error> = stubbingProvider.requestPublisher(target)
    cancellable = publisher.sink(receiveCompletion: { result in
      switch result {
      case .finished:
        break
      case let .failure(failure):
        XCTAssertThrowsError(failure)
      }
      promise.fulfill()
    }, receiveValue: { dto in
      // Assert
      XCTAssertEqual(value, dto)
    })

    wait(for: [promise], timeout: 5)
  }
}
