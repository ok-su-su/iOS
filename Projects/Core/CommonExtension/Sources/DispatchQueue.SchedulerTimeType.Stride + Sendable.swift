//
//  DispatchQueue.SchedulerTimeType.Stride + Sendable.swift
//  CommonExtension
//
//  Created by MaraMincho on 10/3/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - DispatchQueue.SchedulerTimeType.Stride + Sendable

extension DispatchQueue.SchedulerTimeType.Stride: @unchecked @retroactive Sendable {}
