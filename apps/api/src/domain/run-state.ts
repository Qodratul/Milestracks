import type { RunStatus } from "../types/game";

export type RunEvent = "pause" | "resume" | "finish" | "safe_stop" | "reject";

export type RunTransition =
  | { readonly allowed: true; readonly status: RunStatus }
  | {
      readonly allowed: false;
      readonly status: RunStatus;
      readonly reason: "invalid_transition";
    };

const TRANSITIONS: Readonly<Record<RunStatus, Partial<Record<RunEvent, RunStatus>>>> = {
  active: {
    pause: "paused",
    finish: "completed",
    safe_stop: "safe_stopped",
    reject: "rejected",
  },
  paused: {
    resume: "active",
    finish: "completed",
    safe_stop: "safe_stopped",
    reject: "rejected",
  },
  completed: {},
  safe_stopped: {},
  rejected: {},
};

export function transitionRunState(status: RunStatus, event: RunEvent): RunTransition {
  const nextStatus = TRANSITIONS[status][event];
  if (!nextStatus) {
    return { allowed: false, status, reason: "invalid_transition" };
  }
  return { allowed: true, status: nextStatus };
}
