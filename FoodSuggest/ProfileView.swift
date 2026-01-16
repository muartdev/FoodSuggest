import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var intake: TodayIntakeStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Today")
                            .font(.title3.weight(.semibold))
                        Text("Your macro progress at a glance.")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    TodaysMacrosFullCard(
                        carbs: (consumed: intake.carbsConsumed, target: intake.targets.carbs, color: Color.blue.opacity(0.75)),
                        protein: (consumed: intake.proteinConsumed, target: intake.targets.protein, color: Color.mint.opacity(0.85)),
                        fat: (consumed: intake.fatConsumed, target: intake.targets.fat, color: Color.orange.opacity(0.80))
                    )
                    .padding(.horizontal, 16)

                    Spacer(minLength: 0)
                }
                .padding(.bottom, 24)
            }
            .background(AppBackgroundView())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct TodaysMacrosFullCard: View {
    let carbs: (consumed: Int, target: Int, color: Color)
    let protein: (consumed: Int, target: Int, color: Color)
    let fat: (consumed: Int, target: Int, color: Color)

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Today’s Macros")
                .font(.headline)

            MacroDetailRow(label: "Carbs", consumed: carbs.consumed, target: carbs.target, color: carbs.color)
            MacroDetailRow(label: "Protein", consumed: protein.consumed, target: protein.target, color: protein.color)
            MacroDetailRow(label: "Fat", consumed: fat.consumed, target: fat.target, color: fat.color)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.07), radius: 18, x: 0, y: 12)
    }
}

private struct MacroDetailRow: View {
    let label: String
    let consumed: Int
    let target: Int
    let color: Color

    private var progress: Double {
        guard target > 0 else { return 0 }
        return min(Double(consumed) / Double(target), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)

                Text("\(consumed) / \(target)g")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(color)
                .background(Color.primary.opacity(0.06))
                .clipShape(Capsule())
                .frame(height: 8)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(TodayIntakeStore())
}

