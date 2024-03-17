import SwiftUI

private let minimumAngle = 130.0
private let maximumAngle = 410.0

struct Gauge: View {
    let value: String
    let percentage: Double
    let icon: Image
    let colors: [Color]
    
    func getColor(percentage: Double) -> Color {
        let colorIndex = percentage/(100.0/Double(colors.count))
        if colorIndex < 1.0 {
            return colors[0]
        }
        else if colorIndex > Double(colors.count)-1 {
            return colors[colors.count-1]
        }
        else {
            return colors[Int(colorIndex)]
        }
    }
    
    var body: some View {
        let perc = percentage > 100 ? 100 : percentage < 0 ? 0 : percentage
        let percAngle = ((maximumAngle - minimumAngle) * perc/100) + minimumAngle
        let color = getColor(percentage: percentage)
        GeometryReader(content: { geometry in
            VStack {
                ZStack(alignment: .bottom) {
                    ZStack {
                        RoundedArc(
                            startAngle: .degrees(minimumAngle),
                            endAngle: .degrees(maximumAngle),
                            lineWidth: geometry.size.width*0.075
                        )
                        .foregroundColor(color.opacity(0.3))
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        RoundedArc(
                            startAngle: .degrees(minimumAngle),
                            endAngle: .degrees(percAngle),
                            lineWidth: geometry.size.width*0.075
                        )
                        .foregroundColor(color)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        icon
                            .font(.system(size: geometry.size.width*0.25))
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                    Text(value)
                        .font(.system(size: geometry.size.width*0.13))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
            }
        })
    }
}

private struct RoundedArc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var lineWidth: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - lineWidth / 2
        
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        
        return path.strokedPath(.init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
    }
}

#Preview {
    Gauge(
        value: "30%",
        percentage: 30.0,
        icon: Image(systemName: "cpu"),
        colors: [Color.blue, Color.green, Color.yellow, Color.orange, Color.red]
    ).frame(width: 160, height: 160)
}
