//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PaywallViewMode.swift
//
//  Created by Nacho Soto on 7/21/23.

import Foundation

/// The mode for how a paywall is rendered.
public enum PaywallViewMode {

    /// Paywall is displayed full-screen, with as much information as available.
    case fullScreen

    /// Paywall is displayed with a square aspect ratio. It can be embedded inside any other SwiftUI view.
    @available(*, unavailable, message: "Other modes coming soon.")
    case card

    /// Paywall is displayed in a condensed format. It can be embedded inside any other SwiftUI view.
    @available(*, unavailable, message: "Other modes coming soon.")
    case banner

    /// The default ``PaywallViewMode``: ``PaywallViewMode/fullScreen``.
    public static let `default`: Self = .fullScreen

}

extension PaywallViewMode {

    /// Whether this mode is ``PaywallViewMode/fullScreen``.
    public var isFullScreen: Bool {
        switch self {
        case .fullScreen: return true
        case .card, .banner: return false
        }
    }

}

extension PaywallViewMode {

    var identifier: String {
        switch self {
        case .fullScreen: return "full_screen"
        case .card: return "card"
        case .banner: return "banner"
        }
    }

}

// MARK: - Extensions

extension PaywallViewMode: CaseIterable {

    // Note: this manual implementation can be deleted when all modes are available.
    // swiftlint:disable:next missing_docs
    public static var allCases: [PaywallViewMode] {
        return [
            .fullScreen
        ]
    }

}

extension PaywallViewMode: Sendable {}
extension PaywallViewMode: Hashable {}

extension PaywallViewMode: Codable {

    // swiftlint:disable:next missing_docs
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.identifier)
    }

    // swiftlint:disable:next missing_docs
    public init(from decoder: Decoder) throws {
        let identifier = try decoder.singleValueContainer().decode(String.self)

        self = try Self.modesByIdentifier[identifier]
            .orThrow(CodableError.unexpectedValue(Self.self, identifier))
    }

    private static let modesByIdentifier: [String: Self] = Set(Self.allCases)
        .dictionaryWithKeys(\.identifier)

}