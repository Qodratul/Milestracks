import "dotenv/config";
import { llmProvider } from "../src/llm";

async function runAITests() {
  console.log("==================================================");
  console.log("🧪 MEMULAI PENGUJIAN MODUL AI NEBIUS x NVIDIA");
  console.log("==================================================\n");

  // ----------------------------------------------------------------------
  // Test Case 1: Fast Tier (nvidia/NVIDIA-Nemotron-3-Nano-30B-A3B)
  // ----------------------------------------------------------------------
  console.log("▶️ [Test 1] Menguji Fast Tier: generateTrackNarrative()");
  console.log("Parameter: Level Beginner, Jarak 1.8 km, 3 Milestone, Bahasa Indonesia\n");

  const startTimeFast = Date.now();
  const trackResult = await llmProvider.generateTrackNarrative({
    userLevel: "Beginner",
    totalDistanceKm: 1.8,
    milestoneCount: 3,
    weatherCondition: "Cerah, 29°C",
    timeOfDay: "Sore hari",
    surfaceType: "Aspal taman dan trotoar",
    language: "id",
  });
  const durationFast = Date.now() - startTimeFast;

  console.log(`⏱️ Latensi Fast Tier: ${durationFast} ms`);
  console.log("📦 Hasil Validasi Zod Track Narrative:");
  console.log(JSON.stringify(trackResult, null, 2));

  console.log("\n🔍 Audit Aturan Brevity (Maksimal 12 kata per kalimat):");
  trackResult.milestoneDialogues.forEach((d) => {
    const cheerWords = d.cheerLine.trim().split(/\s+/).length;
    const contWords = d.continuePrompt.trim().split(/\s+/).length;
    const restWords = d.restPrompt.trim().split(/\s+/).length;

    console.log(
      `Milestone #${d.milestoneOrder} -> Cheer: ${cheerWords} kata | Continue: ${contWords} kata | Rest: ${restWords} kata`
    );
  });

  console.log("\n--------------------------------------------------\n");

  // ----------------------------------------------------------------------
  // Test Case 2: Reasoning Tier
  // ----------------------------------------------------------------------
  console.log("▶️ [Test 2] Menguji Reasoning Tier: evaluateRunnerSafety()");
  console.log("Kasus: Pace drop +35% lebih lambat, Suhu 35°C (Kondisi Ekstrem), 2 Milestone Gagal\n");

  const startTimeReasoning = Date.now();
  const safetyResult = await llmProvider.evaluateRunnerSafety({
    userLevel: "Intermediate",
    currentPaceSecPerKm: 420,
    baselinePaceSecPerKm: 310,
    weatherTempCelsius: 35,
    consecutiveRunningDays: 4,
    failedMilestonesToday: 2,
    language: "id",
  });
  const durationReasoning = Date.now() - startTimeReasoning;

  console.log(`⏱️ Latensi Reasoning Tier: ${durationReasoning} ms`);
  console.log("📦 Hasil Validasi Zod Safety Diagnostic:");
  console.log(JSON.stringify(safetyResult, null, 2));

  console.log("\n==================================================");
  console.log("✅ PENGUJIAN SELESAI");
  console.log("==================================================");
}

runAITests().catch((err) => {
  console.error("❌ Terjadi kegagalan pengujian:", err);
  process.exit(1);
});