export const routeNarrativeMessages = {
  id: {
    title: (level: string) => "Jejak Misteri " + level,
    brief: (distanceKm: number, milestoneCount: number) =>
      "Lintasan memutar sejauh " +
      distanceKm +
      " km dengan " +
      milestoneCount +
      " milestone siap menantang langkahmu hari ini.",
    preRunTip: "Awali dengan pemanasan ringan dan perhatikan petunjuk belok di depan.",
    selectionReason:
      "Rute pilihan aman yang seimbang untuk ritme lari dan kondisi saat ini.",
    cheers: [
      "Kamu keren! Milestone {n} kelar dengan mulus.",
      "Langkah mantap! Titik milestone {n} berhasil dilewati.",
      "Ritme larimu bagus banget di milestone {n}!",
      "Satu target lagi tuntas! Milestone {n} sudah di tangan.",
    ],
    continues: [
      "Napas masih aman? Yuk gas ke titik berikutnya!",
      "Momentum lagi bagus, lanjutkan langkahmu dengan stabil!",
      "Jalur depan menanti, jaga ayunan langkahmu tetap ringan.",
      "Siap lanjut? Pertahankan ritme larimu sampai titik selanjutnya!",
    ],
    rests: [
      "Mau tarik napas dulu semenit? Istirahat itu bagian strategi.",
      "Ambil jeda 60 detik kalau betis mulai terasa tegang.",
      "Minum seteguk air dan tenangkan detak jantungmu sebentar.",
      "Jeda sejenak tanpa penalti, pulihkan tenagamu dulu ya.",
    ],
    warning: "Perhatikan permukaan jalan dan lalu lintas sekitar.",
  },
  en: {
    title: (level: string) => level + " Mystery Trail",
    brief: (distanceKm: number, milestoneCount: number) =>
      "A custom " +
      distanceKm +
      " km loop with " +
      milestoneCount +
      " milestones tailored for your current level.",
    preRunTip: "Start with a light warm-up and watch upcoming turn prompts.",
    selectionReason: "A safe route balanced for a steady rhythm and current conditions.",
    cheers: [
      "Awesome job! Milestone {n} is officially cleared.",
      "Great stride! You just conquered milestone {n}.",
      "Smooth pacing! Milestone {n} is behind you now.",
      "Another checkpoint done! Milestone {n} complete.",
    ],
    continues: [
      "Breathing steady? Let's push to the next checkpoint!",
      "Momentum looks great, keep your stride smooth and light!",
      "The trail ahead awaits, keep your rhythm steady.",
      "Ready to roll? Hold this pace to the next point!",
    ],
    rests: [
      "Need a one-minute breather? Smart runners know when to pause.",
      "Take 60 seconds to stretch if your calves feel tight.",
      "Grab a quick sip and slow your heart rate down.",
      "Penalty-free pause available, recharge your legs for a moment.",
    ],
    warning: "Watch the path and nearby traffic.",
  },
} as const;
