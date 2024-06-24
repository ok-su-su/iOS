import Combine
import OSLog
import SwiftUI

// MARK: - SliderValue

/// SliderValue to restrict double range: 0.0 to 1.0
@propertyWrapper
public struct SliderValue {
  var value: Double

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
  /// Slider Size
  let sliderWidth: CGFloat
  let sliderHeight: CGFloat

  /// Slider Range
  let sliderValueStart: Double
  let sliderValueRange: Double

  /// Slider Handle
  var diameter: CGFloat = 24
  var startLocation: CGPoint

  /// Current Value
  @Published public var currentPercentage: SliderValue

  /// Slider Button Location
  @Published var onDrag: Bool
  @Published var currentLocation: CGPoint

  init(sliderWidth: CGFloat, sliderHeight: CGFloat, sliderValueStart: Double, sliderValueEnd: Double, startPercentage: SliderValue) {
    self.sliderWidth = sliderWidth
    self.sliderHeight = sliderHeight

    self.sliderValueStart = sliderValueStart
    sliderValueRange = sliderValueEnd - sliderValueStart

    let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue) / 1.0) * sliderWidth, y: sliderHeight / 2)

    self.startLocation = startLocation
    currentLocation = startLocation
    currentPercentage = startPercentage

    onDrag = false
  }

  lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>> = DragGesture()
    .onChanged { value in
      self.onDrag = true

      let dragLocation = value.location

      // Restrict possible drag area
      self.restrictSliderBtnLocation(dragLocation)

      // Get current value
      self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)

    }.onEnded { _ in
      self.onDrag = false
    }

  private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
    // 왼쪽 핸들 오른쪽 핸들 분기
    if (isLeftHandle && dragLocation.x > otherSlide!.currentLocation.x) ||
      (!isLeftHandle && dragLocation.x < otherSlide!.currentLocation.x) {
      return
    }

    if dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth {
      calcSliderBtnLocation(dragLocation)
    }
  }

  private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
    if dragLocation.y != sliderHeight / 2 {
      currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight / 2)
    } else {
      currentLocation = dragLocation
    }
  }

  /// Current Value
  var currentValue: Double {
    return sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
  }

  public var currentValueBy1000: Int {
    return Int(currentValue) / 1000 * 1000
  }
}

// MARK: - CustomSlider

public class CustomSlider: ObservableObject {
  /// Slider Size
  let width: CGFloat
  let lineWidth: CGFloat = 8

  /// Slider value range from valueStart to valueEnd
  let valueStart: Double
  let valueEnd: Double

  /// Slider Handle
  @Published public var highHandle: SliderHandle
  @Published public var lowHandle: SliderHandle

  /// Handle start percentage (also for starting point)
  @SliderValue var highHandleStartPercentage = 1.0
  @SliderValue var lowHandleStartPercentage = 0.0

  var anyCancellableHigh: AnyCancellable?
  var anyCancellableLow: AnyCancellable?

  public init(start: Double, end: Double, width: CGFloat = 300) {
    self.width = width
    valueStart = start
    valueEnd = end

    highHandle = SliderHandle(
      sliderWidth: width,
      sliderHeight: lineWidth,
      sliderValueStart: valueStart,
      sliderValueEnd: valueEnd,
      startPercentage: _highHandleStartPercentage
    )

    lowHandle = SliderHandle(
      sliderWidth: width,
      sliderHeight: lineWidth,
      sliderValueStart: valueStart,
      sliderValueEnd: valueEnd,
      startPercentage: _lowHandleStartPercentage
    )

    // MARK: Dependency Injection Other Handle

    highHandle.otherSlide = lowHandle
    highHandle.isLeftHandle = false
    lowHandle.otherSlide = highHandle
    lowHandle.isLeftHandle = true

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

  /// Value between high and low handle
  var valueBetween: String {
    return String(format: "%.2f", highHandle.currentValue - lowHandle.currentValue)
  }

  public func isInitialState() -> Bool {
    return highHandle.currentValueBy1000 == 100_000 && lowHandle.currentValueBy1000 == 0
  }

  public func reset() {
    highHandle.currentPercentage.wrappedValue = 1
    highHandle.currentLocation = highHandle.startLocation

    lowHandle.currentPercentage.wrappedValue = 0
    lowHandle.currentLocation = lowHandle.startLocation
  }
}
