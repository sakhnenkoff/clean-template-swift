//
//  Builder.swift
//  CleanTemplate
//
//  
//
import SwiftUI

@MainActor
protocol Builder {
    func build() -> AnyView
}
