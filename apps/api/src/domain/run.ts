export interface RunLocationSample {
  readonly sequence: number;
  readonly t: number;
  readonly lat: number;
  readonly lng: number;
  readonly accuracyMeters: number;
  readonly speedMps?: number;
  readonly mocked?: boolean;
}

export interface RunPausePeriod {
  readonly pausedAt: number;
  readonly resumedAt: number | null;
}

export interface RunMilestoneCandidate {
  readonly id: string;
  readonly ordinal: number;
  readonly distanceMeters: number;
  readonly exp: number;
  readonly radiusMeters: number;
  readonly routeProgress: number;
  readonly latitude: number;
  readonly longitude: number;
}

export interface VerifiedRunMilestone extends RunMilestoneCandidate {
  readonly sequence: number;
  readonly timestampMs: number;
  readonly activeSecAtReach: number;
}

const EARTH_RADIUS_METERS = 6_371_008.8;

export function distanceBetweenMeters(
  left: { readonly lat: number; readonly lng: number },
  right: { readonly lat: number; readonly lng: number },
): number {
  const toRadians = Math.PI / 180;
  const latitudeDelta = (right.lat - left.lat) * toRadians;
  const longitudeDelta = (right.lng - left.lng) * toRadians;
  const leftLatitude = left.lat * toRadians;
  const rightLatitude = right.lat * toRadians;
  const haversine =
    Math.sin(latitudeDelta / 2) ** 2 +
    Math.cos(leftLatitude) * Math.cos(rightLatitude) * Math.sin(longitudeDelta / 2) ** 2;
  return 2 * EARTH_RADIUS_METERS * Math.asin(Math.sqrt(Math.min(1, haversine)));
}

export function runDistanceMeters(samples: readonly RunLocationSample[]): number {
  let distance = 0;
  for (let index = 1; index < samples.length; index += 1) {
    const previous = samples[index - 1];
    const current = samples[index];
    if (previous && current) {
      distance += distanceBetweenMeters(previous, current);
    }
  }
  return Math.round(distance);
}

export function gpsQuality(
  samples: readonly RunLocationSample[],
): "strong" | "moderate" | "weak" {
  if (samples.length === 0) return "weak";
  const averageAccuracy =
    samples.reduce((total, sample) => total + sample.accuracyMeters, 0) / samples.length;
  if (averageAccuracy <= 12) return "strong";
  if (averageAccuracy <= 30) return "moderate";
  return "weak";
}

export function activeSecondsAt(input: {
  readonly startedAtMs: number;
  readonly timestampMs: number;
  readonly pausePeriods: readonly RunPausePeriod[];
}): number {
  const elapsedMs = Math.max(0, input.timestampMs - input.startedAtMs);
  const pausedMs = input.pausePeriods.reduce((total, period) => {
    const endMs = period.resumedAt ?? input.timestampMs;
    const overlapMs = Math.max(
      0,
      Math.min(endMs, input.timestampMs) - Math.max(period.pausedAt, input.startedAtMs),
    );
    return total + overlapMs;
  }, 0);
  return Math.max(0, Math.floor((elapsedMs - pausedMs) / 1000));
}

export function verifyRunMilestones(input: {
  readonly samples: readonly RunLocationSample[];
  readonly milestones: readonly RunMilestoneCandidate[];
  readonly startedAtMs: number;
  readonly pausePeriods: readonly RunPausePeriod[];
}): readonly VerifiedRunMilestone[] {
  const orderedSamples = [...input.samples].sort(
    (left, right) => left.sequence - right.sequence,
  );
  const orderedMilestones = [...input.milestones].sort(
    (left, right) => left.ordinal - right.ordinal,
  );
  const verified: VerifiedRunMilestone[] = [];
  let previousSequence = 0;
  let previousProgress = -1;

  for (const milestone of orderedMilestones) {
    if (milestone.routeProgress < previousProgress) continue;
    const match = orderedSamples.find((sample) => {
      if (sample.sequence <= previousSequence) return false;
      const allowedDistance = milestone.radiusMeters + sample.accuracyMeters;
      return (
        distanceBetweenMeters(
          { lat: sample.lat, lng: sample.lng },
          { lat: milestone.latitude, lng: milestone.longitude },
        ) <= allowedDistance
      );
    });
    if (!match) continue;
    verified.push({
      ...milestone,
      sequence: match.sequence,
      timestampMs: match.t,
      activeSecAtReach: activeSecondsAt({
        startedAtMs: input.startedAtMs,
        timestampMs: match.t,
        pausePeriods: input.pausePeriods,
      }),
    });
    previousSequence = match.sequence;
    previousProgress = milestone.routeProgress;
  }
  return verified;
}
