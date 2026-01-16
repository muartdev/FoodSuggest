import SwiftUI

struct MealSuggestionCardView: View {
    let meal: Meal
    let isSaved: Bool
    let onToggleSave: () -> Void

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
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 12)
    }

    private var icon: some View {
        ZStack {
            Circle()
                .fill(accent.opacity(0.20))
            Image(systemName: meal.imageName)
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

