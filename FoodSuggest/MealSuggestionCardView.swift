import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

private struct SafeSystemImage: View {
    let name: String
    var fallback: String = "fork.knife"

    var body: some View {
#if canImport(UIKit)
        if UIImage(systemName: name) != nil {
            Image(systemName: name)
        } else {
            Image(systemName: fallback)
        }
#else
        Image(systemName: name)
#endif
    }
}

struct MealSuggestionCardView: View {
    let meal: Meal
    let isSaved: Bool
    let onToggleSave: () -> Void
    let onQuickAdd: () -> Void

    @State private var didQuickAddPulse = false

    var body: some View {
        HStack(spacing: 14) {
            icon

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(meal.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer(minLength: 0)

                    Text(meal.category.uppercased())
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                }

                Text(meal.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button {
                onQuickAdd()
                withAnimation(.spring(response: 0.25, dampingFraction: 0.70)) {
                    didQuickAddPulse = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        didQuickAddPulse = false
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .background(.thinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
            .scaleEffect(didQuickAddPulse ? 1.10 : 1.0)

            Button(action: onToggleSave) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isSaved ? Color.pink : .secondary)
                    .frame(width: 34, height: 34)
                    .background(.thinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.20))
            SafeSystemImage(name: meal.imageName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(accent)
        }
        .frame(width: 44, height: 44)
    }

    private var accent: Color {
        switch meal.category.lowercased() {
        case "high protein": return .mint
        case "comfort": return .red
        case "healthy": return .green
        case "quick meal": return .blue
        case "breakfast": return .orange
        case "vegetarian": return .purple
        case "asian": return .indigo
        default: return .secondary
        }
    }
}

struct MealCompactCardView: View {
    let meal: Meal
    let isSaved: Bool
    let onToggleSave: () -> Void
    let onQuickAdd: () -> Void

    @State private var didQuickAddPulse = false

    var body: some View {
        HStack(spacing: 10) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(meal.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    Text("\(meal.calories) kcal")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Text(meal.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            Button {
                onQuickAdd()
                withAnimation(.spring(response: 0.25, dampingFraction: 0.70)) {
                    didQuickAddPulse = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        didQuickAddPulse = false
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 28, height: 28)
                    .background(.thinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
            .scaleEffect(didQuickAddPulse ? 1.10 : 1.0)

            Button(action: onToggleSave) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSaved ? Color.pink : .secondary)
                    .frame(width: 30, height: 30)
                    .background(.thinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.045), radius: 10, x: 0, y: 5)
    }

    private var thumbnail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(accent.opacity(0.18))
            SafeSystemImage(name: meal.imageName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(accent)
        }
        .frame(width: 40, height: 40)
    }

    private var accent: Color {
        switch meal.category.lowercased() {
        case "breakfast": return .orange
        case "lunch": return .mint
        case "dinner": return .red
        case "snack": return .purple
        case "dessert": return .pink
        default: return .secondary
        }
    }
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [
                    Color.blue.opacity(0.12),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 420
            )

            RadialGradient(
                colors: [
                    Color.mint.opacity(0.10),
                    Color.clear
                ],
                center: .bottomLeading,
                startRadius: 20,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

