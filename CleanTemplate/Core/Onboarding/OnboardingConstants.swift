//
//  OnboardingConstants.swift
//  CleanTemplate
//
//  Created by Nick Sarno on 10/24/25.
//

import SwiftUI
import SwiftfulOnboarding
import DesignSystem

@MainActor
struct OnboardingConstants {

    static let headerConfiguration = OnbHeaderConfiguration(
        headerStyle: .progressBar,
        headerAlignment: .center,
        showBackButton: .afterFirstSlide,
        backButtonColor: Color.themeAccent,
        progressBarAccentColor: Color.themeAccent
    )

    static let slideDefaults = OnbSlideDefaults(
        ctaButtonStyle: .solid(
            backgroundColor: Color.themeAccent,
            textColor: Color.textOnPrimary,
            selectedBackgroundColor: Color.themeAccent,
            selectedTextColor: Color.textOnPrimary
        ),
        optionsButtonStyle: .solid(
            backgroundColor: Color.backgroundSecondary,
            textColor: .primary,
            selectedBackgroundColor: Color.themeAccent,
            selectedTextColor: Color.textOnPrimary
        )
    )

    static let slides: [OnbSlideType] = [
        .regular(
            id: "welcome",
            title: "Welcome!",
            subtitle: "Get started with our amazing app",
            media: .systemIcon(named: "star.fill"),
            mediaPosition: .top,
            contentAlignment: .center
        ),
        .multipleChoice(
            id: "interests",
            title: "What are you interested in?",
            subtitle: "Select all that apply",
            options: [
                OnbChoiceOption(
                    id: "tech",
                    content: OnbButtonContentData(
                        text: "Technology",
                        secondaryContent: .media(media: .systemIcon(named: "laptopcomputer", size: .small))
                    )
                ),
                OnbChoiceOption(
                    id: "design",
                    content: OnbButtonContentData(
                        text: "Design",
                        secondaryContent: .media(media: .systemIcon(named: "paintbrush", size: .small))
                    )
                ),
                OnbChoiceOption(
                    id: "business",
                    content: OnbButtonContentData(
                        text: "Business",
                        secondaryContent: .media(media: .systemIcon(named: "briefcase", size: .small))
                    )
                )
            ],
            selectionBehavior: .multi(max: 3),
            contentAlignment: .top
        )
    ]
}
