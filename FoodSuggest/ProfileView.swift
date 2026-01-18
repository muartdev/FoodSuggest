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
        GlassMacrosChartCard(
            title: "Today’s Macros",
            carbs: (consumed: carbs.consumed, target: carbs.target, color: carbs.color),
            protein: (consumed: protein.consumed, target: protein.target, color: protein.color),
            fat: (consumed: fat.consumed, target: fat.target, color: fat.color)
        )
    }
}

private struct GlassMacrosChartCard: View {
    let title: String
    let carbs: (consumed: Int, target: Int, color: Color)
    let protein: (consumed: Int, target: Int, color: Color)
    let fat: (consumed: Int, target: Int, color: Color)

    private var consumedKcal: Int {
        (carbs.consumed * 4) + (protein.consumed * 4) + (fat.consumed * 9)
    }

    private var targetKcal: Int {
        (carbs.target * 4) + (protein.target * 4) + (fat.target * 9)
    }

    private var percent: Int {
        guard targetKcal > 0 else { return 0 }
        return min(Int((Double(consumedKcal) / Double(targetKcal)) * 100), 100)
    }

    private var segments: [DonutSegment] {
        [
            .init(label: "Carbs", value: Double(carbs.consumed * 4), color: carbs.color),
            .init(label: "Protein", value: Double(protein.consumed * 4), color: protein.color),
            .init(label: "Fat", value: Double(fat.consumed * 9), color: fat.color)
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)

            HStack(alignment: .center, spacing: 16) {
                GlassDonutChart(
                    segments: segments,
                    lineWidth: 26,
                    gapDegrees: 6
                ) {
                    VStack(spacing: 2) {
                        Text("\(percent)%")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("\(consumedKcal) kcal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 170, height: 170)

                VStack(alignment: .leading, spacing: 10) {
                    MacroLegendRow(
                        label: "Carbs",
                        color: carbs.color,
                        detail: "\(carbs.consumed) / \(carbs.target)g"
                    )
                    MacroLegendRow(
                        label: "Protein",
                        color: protein.color,
                        detail: "\(protein.consumed) / \(protein.target)g"
                    )
                    MacroLegendRow(
                        label: "Fat",
                        color: fat.color,
                        detail: "\(fat.consumed) / \(fat.target)g"
                    )
                }

                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.10), radius: 22, x: 0, y: 14)
    }
}

private struct MacroLegendRow: View {
    let label: String
    let color: Color
    let detail: String

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
                .shadow(color: color.opacity(0.35), radius: 8, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct DonutSegment: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

private struct GlassDonutChart<Center: View>: View {
    let segments: [DonutSegment]
    let lineWidth: CGFloat
    let gapDegrees: Double
    @ViewBuilder let center: () -> Center

    private var total: Double {
        segments.map(\.value).reduce(0, +)
    }

    var body: some View {
        ZStack {
            // Outer glass plate + shadow (reference-like)
            Circle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Circle().stroke(.white.opacity(0.22), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.10), radius: 26, x: 0, y: 18)

            // Inner soft glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.22),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 95
                    )
                )
                .blur(radius: 2)
                .opacity(0.65)

            // Base track
            Circle()
                .stroke(Color.primary.opacity(0.08), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Segments
            ForEach(ringSegments(), id: \.id) { seg in
                Circle()
                    .trim(from: seg.trimFrom, to: seg.trimTo)
                    .stroke(
                        seg.color,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: seg.color.opacity(0.35), radius: 16, x: 0, y: 10)
                    .rotationEffect(.degrees(-90))
            }

            // Inner cutout to make it donut + glass inset
            Circle()
                .fill(.thinMaterial)
                .padding(lineWidth * 0.92)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.18), lineWidth: 1)
                        .padding(lineWidth * 0.92)
                )

            center()
                .padding(lineWidth * 0.95)
        }
    }

    private struct RingSeg: Identifiable {
        let id: UUID
        let trimFrom: CGFloat
        let trimTo: CGFloat
        let color: Color
    }

    private func ringSegments() -> [RingSeg] {
        guard total > 0 else { return [] }

        let gap = max(0, min(gapDegrees, 30))
        let gapFraction = gap / 360.0

        var cursor = 0.0
        return segments.compactMap { seg in
            guard seg.value > 0 else { return nil }
            let raw = seg.value / total
            let usable = max(0, raw - gapFraction)
            let start = cursor + (gapFraction / 2.0)
            let end = start + usable
            cursor += raw
            return RingSeg(
                id: seg.id,
                trimFrom: CGFloat(start),
                trimTo: CGFloat(end),
                color: seg.color
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(TodayIntakeStore())
}

