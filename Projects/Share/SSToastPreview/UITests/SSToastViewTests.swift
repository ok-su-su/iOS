//
//  SSToastViewTests.swift
//  SSToastPreviewUITests
//
//  Created by MaraMincho on 5/19/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

@testable import SSToastPreview
import XCTest

// MARK: - SSToastViewTests

final class SSToastViewTests: XCTestCase {
  override func setUpWithError() throws {
    continueAfterFailure = true
  }

  override func tearDownWithError() throws {
    
  }

  func testExample() throws {
    let app = XCUIApplication()
    app.launch()

    let toastMessage = app.staticTexts["ToastMessage"]

    let sstoastpreviewIfTapShowToastButton = app.buttons["SSToastPreview if tap show Toast"]
    sstoastpreviewIfTapShowToastButton.tap()
    XCTAssertEqual(toastMessage.label, Constants.shortToastMessage)

    let multilineSstoastpreviewIfTapShowToastButton = app.buttons["Multiline SSToastPreview if tap show Toast"]
    multilineSstoastpreviewIfTapShowToastButton.tap()
    XCTAssertEqual(toastMessage.label, Constants.longToastMessage)

    multilineSstoastpreviewIfTapShowToastButton.tap()
    let sstoastpreviewIfTapCloseToastButton = app.buttons["SSToastPreview if tap close Toast"]
    sstoastpreviewIfTapCloseToastButton.tap()
    XCTAssertFalse(toastMessage.exists)
  }

  private enum Constants {
    static let shortToastMessage = "수수의 토스트"
    static let longToastMessage = "수수의 토스트 수수의 \n토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 수수의 토스트 "
  }
}

/// XCTAssertFalse(isDisplayed(app.buttons["...."]))
extension XCTestCase {
  /// 해당 요소가 화면에 보이는지 체크해주는 함수
  func isDisplayed(_ value: Any) -> Bool {
    switch value {
    // 텍스트인 경우
    case is String:
      guard let text = value as? String else { return false }
      if XCUIApplication().staticTexts[text].waitForExistence(timeout: 4.0) {
        return true
      } else {
        return false
      }
    // UI 요소인 경우
    case is XCUIElement:
      guard let element = value as? XCUIElement else { return false }
      if element.waitForExistence(timeout: 4.0) {
        return true
      } else {
        return false
      }
    default:
      return false
    }
  }
}
