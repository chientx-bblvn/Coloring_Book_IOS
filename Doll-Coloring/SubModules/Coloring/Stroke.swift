//
//  Stroke.swift
//  LFColoringBook
//
//  Created by Trabajo on 17/09/20.
//

import UIKit
import simd

/// Drawing tip style — pencil (hard/thin) vs brush (soft/wide).
enum StrokeKind: String {
    case brush
    case pencil

    init(raw: String?) {
        self = StrokeKind(rawValue: raw ?? "") ?? .brush
    }
}

struct Stroke {
    private static var currentID: UInt64 = 0
    // Array of CGPoints to draw lines between them
    var points: [CGPoint] = [CGPoint]()
    // Update rect of whole stroke
    var strokeRect: CGRect = .null

    // LineWidth and Color of the stroke
    let lineWidth: CGFloat
    let color: UIColor
    let nameColor: String
    let id: UInt64
    let isPens: Bool
    let kind: StrokeKind

    // Helper variable to know which points the active stroke has already drawn
    private (set) var lastDrawnPoint: Int = -1

    /// Dirty-region padding around each point (brush is wider/softer).
    private var pointPad: CGFloat {
        switch kind {
        case .pencil: return max(lineWidth * 0.55, 3)
        case .brush: return max(lineWidth * 0.9, 6)
        }
    }

    init(
        color: UIColor = .black,
        lineWidth: CGFloat = 5.0,
        nameColor: String = "",
        isPens: Bool = true,
        kind: StrokeKind = .brush
    ) {
        self.color = color
        self.lineWidth = lineWidth
        self.nameColor = nameColor
        self.isPens = isPens
        self.kind = kind
        self.id = Stroke.currentID
        Stroke.currentID += 1
    }

    mutating func addPoint(_ point: CGPoint) {
        // Pencil samples denser for a sketchy edge; brush skips closer points for smoother ink.
        let minDistance: Float = kind == .pencil ? 0.5 : 1.35
        if let lastPoint = self.points.last {
            let lastSimd = simd_float2(x: Float(lastPoint.x), y: Float(lastPoint.y))
            let newSimd = simd_float2(x: Float(point.x), y: Float(point.y))
            if simd_distance(lastSimd, newSimd) < minDistance {
                return
            }
        }

        let pad = pointPad
        let pointRect = CGRect(
            x: point.x - pad,
            y: point.y - pad,
            width: pad * 2,
            height: pad * 2
        )
        strokeRect = strokeRect.union(pointRect)
        self.points.append(point)
    }

    func drawInContext(_ context: CGContext) {
        if CommandLine.arguments.contains("-debugStrokes") {
            context.setFillColor(UIColor.red.cgColor)
            for point in self.points {
                context.fillEllipse(in: CGRect(x: point.x - 1.0,
                                               y: point.y - 1.0,
                                               width: 2.0, height: 2.0))
            }
            return
        }
        strokePath(in: context, points: self.points)
    }

    mutating func drawSinceLastIn(_ context: CGContext) -> CGRect? {
        guard !self.points.isEmpty else { return nil }
        if self.lastDrawnPoint == (self.points.count - 1) { return nil }

        let arrayStart: Int = lastDrawnPoint >= 0 ? lastDrawnPoint : 0
        let arrayEnd: Int = self.points.count - 1
        self.lastDrawnPoint = arrayEnd

        var updateRect: CGRect = .null
        var linePoints: [CGPoint] = []
        let pad = pointPad

        for point in self.points[arrayStart...arrayEnd] {
            linePoints.append(point)
            let pointRect = CGRect(
                x: point.x - pad,
                y: point.y - pad,
                width: pad * 2,
                height: pad * 2
            )
            updateRect = updateRect.union(pointRect)
        }

        if CommandLine.arguments.contains("-debugStrokes") {
            context.setFillColor(UIColor.red.cgColor)
            for point in linePoints {
                context.fillEllipse(in: CGRect(x: point.x - 1.0,
                                               y: point.y - 1.0,
                                               width: 2.0, height: 2.0))
            }
        } else {
            strokePath(in: context, points: linePoints)
        }

        return updateRect
    }

    /// Pencil = hard thin graphite; brush = soft layered ink.
    private func strokePath(in context: CGContext, points: [CGPoint]) {
        guard !points.isEmpty else { return }

        context.saveGState()
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setBlendMode(.normal)

        switch kind {
        case .pencil:
            // Hard, thin, slightly textured — reads as graphite, not paint.
            let width = max(1.0, lineWidth * 0.42)
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(width)
            if points.count == 1, let p = points.first {
                context.setFillColor(color.cgColor)
                context.fillEllipse(in: CGRect(
                    x: p.x - width / 2,
                    y: p.y - width / 2,
                    width: width,
                    height: width
                ))
            } else {
                context.addLines(between: points)
                context.strokePath()
            }
            // Light grain so it doesn't look like a solid brush tip.
            context.setFillColor(color.withAlphaComponent(0.28).cgColor)
            for (i, p) in points.enumerated() where i % 2 == 0 {
                let ox = CGFloat((i % 5) - 2) * 0.28
                let oy = CGFloat(((i + 1) % 5) - 2) * 0.28
                let d: CGFloat = max(0.55, width * 0.35)
                context.fillEllipse(in: CGRect(x: p.x + ox - d / 2, y: p.y + oy - d / 2, width: d, height: d))
            }

        case .brush:
            // Soft brush: wide translucent body + denser core.
            let width = max(2.0, lineWidth)
            if points.count == 1, let p = points.first {
                context.setFillColor(color.withAlphaComponent(0.35).cgColor)
                context.fillEllipse(in: CGRect(
                    x: p.x - width * 0.75,
                    y: p.y - width * 0.75,
                    width: width * 1.5,
                    height: width * 1.5
                ))
                context.setFillColor(color.withAlphaComponent(0.9).cgColor)
                context.fillEllipse(in: CGRect(
                    x: p.x - width * 0.35,
                    y: p.y - width * 0.35,
                    width: width * 0.7,
                    height: width * 0.7
                ))
            } else {
                context.setStrokeColor(color.withAlphaComponent(0.26).cgColor)
                context.setLineWidth(width * 1.6)
                context.addLines(between: points)
                context.strokePath()

                context.setStrokeColor(color.withAlphaComponent(0.5).cgColor)
                context.setLineWidth(width * 1.1)
                context.addLines(between: points)
                context.strokePath()

                context.setStrokeColor(color.withAlphaComponent(0.92).cgColor)
                context.setLineWidth(width * 0.7)
                context.addLines(between: points)
                context.strokePath()
            }
        }

        context.restoreGState()
    }
}
