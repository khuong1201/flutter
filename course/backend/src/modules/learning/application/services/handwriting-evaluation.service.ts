import { Injectable } from '@nestjs/common';

type Point = { x: number; y: number };

@Injectable()
export class HandwritingEvaluationService {
  
  public evaluate(userStrokes: Point[][], expectedStrokes: Point[][]): number {
    if (expectedStrokes.length === 0 || userStrokes.length === 0) return 0;

    const normUserStrokes = this.normalizeStrokes(userStrokes);
    const normExpectedStrokes = this.normalizeStrokes(expectedStrokes);

    let totalScore = 0;
    const minStrokes = Math.min(normUserStrokes.length, normExpectedStrokes.length);
    const maxStrokes = Math.max(normUserStrokes.length, normExpectedStrokes.length);

    // Penalty for wrong stroke count (e.g. -10 points per missing/extra stroke)
    const strokeCountPenalty = (maxStrokes - minStrokes) * 10;

    for (let i = 0; i < minStrokes; i++) {
      const uStroke = this.resample(normUserStrokes[i], 50);
      const eStroke = this.resample(normExpectedStrokes[i], 50);
      
      const distance = this.calculateAverageDistance(uStroke, eStroke);
      
      // Distance is typically between 0 and 1. 
      // If average distance is 0 -> 100 points. If 0.3 -> 0 points (it's very far).
      let strokeScore = Math.max(0, 100 - (distance * 333));

      // Direction check
      const uDir = this.getDirection(uStroke);
      const eDir = this.getDirection(eStroke);
      const angleDiff = this.getAngleDifference(uDir, eDir);

      if (angleDiff > Math.PI / 2) {
        strokeScore -= 30; // heavy penalty for drawing backward
      }

      totalScore += Math.max(0, strokeScore);
    }

    let finalScore = (totalScore / Math.max(minStrokes, 1)) - strokeCountPenalty;
    return Math.max(0, Math.min(100, Math.round(finalScore)));
  }

  private normalizeStrokes(strokes: Point[][]): Point[][] {
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    
    for (const stroke of strokes) {
      for (const p of stroke) {
        if (p.x < minX) minX = p.x;
        if (p.y < minY) minY = p.y;
        if (p.x > maxX) maxX = p.x;
        if (p.y > maxY) maxY = p.y;
      }
    }

    const width = maxX - minX;
    const height = maxY - minY;
    const scale = Math.max(width, height) || 1;

    // Center it in [0, 1] bounding box
    const offsetX = (1 - width / scale) / 2;
    const offsetY = (1 - height / scale) / 2;

    return strokes.map(stroke => 
      stroke.map(p => ({
        x: ((p.x - minX) / scale) + offsetX,
        y: ((p.y - minY) / scale) + offsetY,
      }))
    );
  }

  private resample(stroke: Point[], n: number): Point[] {
    if (stroke.length === 0) return [];
    if (stroke.length === 1) return Array(n).fill(stroke[0]);

    let totalLength = 0;
    const distances: number[] = [0];
    
    for (let i = 1; i < stroke.length; i++) {
      const d = this.distance(stroke[i - 1], stroke[i]);
      totalLength += d;
      distances.push(totalLength);
    }

    const interval = totalLength / (n - 1);
    const resampled: Point[] = [stroke[0]];
    
    let currentDist = interval;
    let i = 1;

    while (resampled.length < n - 1 && i < stroke.length) {
      if (distances[i] >= currentDist) {
        const d0 = distances[i - 1];
        const d1 = distances[i];
        const p0 = stroke[i - 1];
        const p1 = stroke[i];
        
        const ratio = (currentDist - d0) / (d1 - d0 || 1);
        resampled.push({
          x: p0.x + ratio * (p1.x - p0.x),
          y: p0.y + ratio * (p1.y - p0.y),
        });
        currentDist += interval;
      } else {
        i++;
      }
    }

    resampled.push(stroke[stroke.length - 1]);
    return resampled;
  }

  private calculateAverageDistance(path1: Point[], path2: Point[]): number {
    const len = Math.min(path1.length, path2.length);
    if (len === 0) return 1;

    let sum = 0;
    for (let i = 0; i < len; i++) {
      sum += this.distance(path1[i], path2[i]);
    }
    return sum / len;
  }

  private distance(p1: Point, p2: Point): number {
    const dx = p1.x - p2.x;
    const dy = p1.y - p2.y;
    return Math.sqrt(dx * dx + dy * dy);
  }

  private getDirection(stroke: Point[]): Point {
    if (stroke.length < 2) return { x: 0, y: 0 };
    const p1 = stroke[0];
    const p2 = stroke[stroke.length - 1];
    const dx = p2.x - p1.x;
    const dy = p2.y - p1.y;
    const len = Math.sqrt(dx * dx + dy * dy) || 1;
    return { x: dx / len, y: dy / len };
  }

  private getAngleDifference(v1: Point, v2: Point): number {
    const dot = v1.x * v2.x + v1.y * v2.y;
    // clip to [-1, 1] to avoid NaN from Math.acos
    const clippedDot = Math.max(-1, Math.min(1, dot));
    return Math.acos(clippedDot);
  }
}
