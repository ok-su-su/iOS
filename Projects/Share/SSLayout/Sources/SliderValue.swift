import Combine
import OSLog
import SwiftUI

// MARK: - SliderValue

/// SliderValue to restrict double range: 0.0 to 1.0
@propertyWrapper
public struct SliderValue {
  private var value: Double

  public init(wrappedValue: Double) {
    value = wrappedValue
  }

  public var wrappedValue: Double {
    get { value }
    set { value = min(max(0.0, newValue), 1.0) }
  }
}

// MARK: - SliderHandle

public class SliderHandle: ObservableObject {
  var isLeftHandle = false
  weak var otherSlide: SliderHandle? = nil

  /// Slider Range
  let sliderValueStart: Double = 0
  let sliderValueRange: Double = 1

  /// Current Value
  @Published public var currentPercentage: SliderValue

  /// Slider Button Location
  @Published var onDrag: Bool

  init(startPercentage: SliderValue) {
    currentPercentage = startPercentage

    onDrag = false
  }

  func updateCurrentPercentage(_ val: Double) {
    currentPercentage.wrappedValue = val
    objectWillChange.send()
  }
}

// MARK: - CustomSlider

public class CustomSlider: ObservableObject, Equatable {
  public static func == (lhs: CustomSlider, rhs: CustomSlider) -> Bool {
    lhs === rhs
  }

  /// For GA
  let _tapPublisher: PassthroughSubject<Void, Never> = .init()
  public var tapPublisher: AnyPublisher<Void, Never> { _tapPublisher.eraseToAnyPublisher() }

  /// Slider Size
  let lineWidth: CGFloat = 8

  /// Slider value range from valueStart to valueEnd
  var valueStart: Double = 0
  var valueEnd: Double = 1

  /// Slider Handle
  @Published public var highHandle: SliderHandle
  @Published public var lowHandle: SliderHandle

  /// Handle start percentage (also for starting point)
  @SliderValue var highHandleStartPercentage = 1.0
  @SliderValue var lowHandleStartPercentage = 0.0

  public var currentLowHandlePercentage: Double {
    lowHandle.currentPercentage.wrappedValue
  }

  public var currentHighHandlePercentage: Double {
    highHandle.currentPercentage.wrappedValue
  }

  public var isInitialState: Bool {
    currentLowHandlePercentage == lowHandleStartPercentage &&
      currentHighHandlePercentage == highHandleStartPercentage
  }

  var anyCancellableHigh: AnyCancellable?
  var anyCancellableLow: AnyCancellable?

  public init() {
    highHandle = SliderHandle(
      startPercentage: _highHandleStartPercentage
    )

    lowHandle = SliderHandle(
      startPercentage: _lowHandleStartPercentage
    )

    anyCancellableHigh = highHandle.objectWillChange.sink { _ in
      self.objectWillChange.send()
    }
    anyCancellableLow = lowHandle.objectWillChange.sink { _ in
      self.objectWillChange.send()
    }
  }

  /// Percentages between high and low handle
  var percentagesBetween: String {
    return String(format: "%.2f", highHandle.currentPercentage.wrappedValue - lowHandle.currentPercentage.wrappedValue)
  }

  public func reset() {
    highHandle.currentPercentage.wrappedValue = 1

    lowHandle.currentPercentage.wrappedValue = 0
  }
}
