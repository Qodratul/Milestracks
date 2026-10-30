interface PendingJob {
  readonly key: string;
  readonly execute: () => Promise<void>;
}

export class InProcessJobQueue {
  private readonly pending: PendingJob[] = [];
  private readonly activeKeys = new Set<string>();
  private activeCount = 0;

  public constructor(private readonly concurrency: number) {
    if (!Number.isSafeInteger(concurrency) || concurrency < 1) {
      throw new RangeError("Job concurrency must be a positive integer.");
    }
  }

  public enqueue(key: string, execute: () => Promise<void>): void {
    if (this.activeKeys.has(key)) return;
    this.activeKeys.add(key);
    this.pending.push({ key, execute });
    this.pump();
  }

  public get pendingCount(): number {
    return this.pending.length + this.activeCount;
  }

  private pump(): void {
    while (this.activeCount < this.concurrency) {
      const job = this.pending.shift();
      if (!job) return;
      this.activeCount += 1;
      void job
        .execute()
        .catch(() => undefined)
        .finally(() => {
          this.activeCount -= 1;
          this.activeKeys.delete(job.key);
          this.pump();
        });
    }
  }
}
