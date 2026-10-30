CREATE SCHEMA IF NOT EXISTS extensions;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA extensions;
SET search_path = public, extensions;
-- CreateEnum
CREATE TYPE "user_role" AS ENUM ('user', 'admin');

-- CreateEnum
CREATE TYPE "user_status" AS ENUM ('active', 'disabled');

-- CreateEnum
CREATE TYPE "locale" AS ENUM ('id', 'en');

-- CreateEnum
CREATE TYPE "units" AS ENUM ('metric', 'imperial');

-- CreateEnum
CREATE TYPE "level_code" AS ENUM ('beginner', 'intermediate', 'advanced', 'professional', 'master');

-- CreateEnum
CREATE TYPE "item_code" AS ENUM ('exp_boost', 'less_compensation', 'gain_more');

-- CreateEnum
CREATE TYPE "reveal_mode" AS ENUM ('full', 'next_milestone', 'blind');

-- CreateEnum
CREATE TYPE "route_status" AS ENUM ('generating', 'ready', 'failed', 'used', 'expired');

-- CreateEnum
CREATE TYPE "template_status" AS ENUM ('active', 'flagged', 'suspended');

-- CreateEnum
CREATE TYPE "report_reason" AS ENUM ('safety_concern', 'incorrect_map', 'inaccessible', 'other');

-- CreateEnum
CREATE TYPE "report_status" AS ENUM ('received', 'reviewing', 'resolved', 'dismissed');

-- CreateEnum
CREATE TYPE "run_status" AS ENUM ('active', 'paused', 'completed', 'safe_stopped', 'rejected');

-- CreateEnum
CREATE TYPE "integrity" AS ENUM ('clean', 'flagged', 'rejected');

-- CreateEnum
CREATE TYPE "idempotency_state" AS ENUM ('processing', 'completed');

-- CreateEnum
CREATE TYPE "anti_cheat_mode" AS ENUM ('shadow', 'enforce');

-- CreateTable
CREATE TABLE "users" (
    "id" VARCHAR(64) NOT NULL,
    "email" VARCHAR(320) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "role" "user_role" NOT NULL DEFAULT 'user',
    "status" "user_status" NOT NULL DEFAULT 'active',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profiles" (
    "user_id" VARCHAR(64) NOT NULL,
    "display_name" VARCHAR(30) NOT NULL,
    "locale" "locale" NOT NULL DEFAULT 'en',
    "timezone" VARCHAR(64) NOT NULL DEFAULT 'UTC',
    "units" "units" NOT NULL DEFAULT 'metric',
    "total_exp" INTEGER NOT NULL DEFAULT 0,
    "level_code" "level_code" NOT NULL DEFAULT 'beginner',
    "coin_balance" INTEGER NOT NULL DEFAULT 0,
    "coin_carry_milli" INTEGER NOT NULL DEFAULT 0,
    "rp_total" INTEGER NOT NULL DEFAULT 0,
    "completed_runs" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "token_hash" VARCHAR(128) NOT NULL,
    "family_id" VARCHAR(64) NOT NULL,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "revoked_at" TIMESTAMPTZ(6),
    "replaced_by" VARCHAR(64),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "idempotency_keys" (
    "id" UUID NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "key" UUID NOT NULL,
    "route" VARCHAR(255) NOT NULL,
    "request_hash" CHAR(64) NOT NULL,
    "state" "idempotency_state" NOT NULL DEFAULT 'processing',
    "response" JSONB,
    "status_code" SMALLINT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "idempotency_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_config_versions" (
    "version" INTEGER NOT NULL,
    "payload" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT false,
    "active_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_config_versions_pkey" PRIMARY KEY ("version")
);

-- CreateTable
CREATE TABLE "route_templates" (
    "id" VARCHAR(64) NOT NULL,
    "level_code" "level_code" NOT NULL,
    "distance_meters" INTEGER NOT NULL,
    "estimated_duration_sec" INTEGER NOT NULL,
    "estimated_calories" INTEGER NOT NULL,
    "geometry" geometry(LineString,4326) NOT NULL,
    "start_point" geometry(Point,4326) NOT NULL,
    "safety_score" DOUBLE PRECISION NOT NULL,
    "data_confidence" DOUBLE PRECISION NOT NULL,
    "status" "template_status" NOT NULL DEFAULT 'active',
    "algorithm_version" VARCHAR(64) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "route_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "route_template_milestones" (
    "template_id" VARCHAR(64) NOT NULL,
    "ordinal" INTEGER NOT NULL,
    "milestone_id" VARCHAR(64) NOT NULL,
    "location" geometry(Point,4326) NOT NULL,
    "distance_meters" INTEGER NOT NULL,
    "radius_meters" INTEGER NOT NULL DEFAULT 25,
    "exp" INTEGER NOT NULL,

    CONSTRAINT "route_template_milestones_pkey" PRIMARY KEY ("template_id","ordinal")
);

-- CreateTable
CREATE TABLE "route_template_narrations" (
    "id" VARCHAR(64) NOT NULL,
    "template_id" VARCHAR(64) NOT NULL,
    "locale" "locale" NOT NULL,
    "title" VARCHAR(120) NOT NULL,
    "mystery_brief" VARCHAR(500) NOT NULL,
    "pre_run_tip" VARCHAR(240) NOT NULL,
    "warning" VARCHAR(240),
    "selection_reason" VARCHAR(240) NOT NULL,
    "dialogues" JSONB NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "route_template_narrations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "routes" (
    "id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "template_id" VARCHAR(64) NOT NULL,
    "config_version" INTEGER NOT NULL,
    "status" "route_status" NOT NULL DEFAULT 'generating',
    "reveal_mode" "reveal_mode" NOT NULL,
    "selection_reason" VARCHAR(240),
    "weather_hint" JSONB,
    "generation_failure" JSONB,
    "expires_at" TIMESTAMPTZ(6) NOT NULL,
    "used_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "routes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "route_reports" (
    "id" VARCHAR(64) NOT NULL,
    "route_id" VARCHAR(64) NOT NULL,
    "template_id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "reason" "report_reason" NOT NULL,
    "details" VARCHAR(240),
    "status" "report_status" NOT NULL DEFAULT 'received',
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "route_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inventory" (
    "user_id" VARCHAR(64) NOT NULL,
    "item_code" "item_code" NOT NULL,
    "quantity" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "inventory_pkey" PRIMARY KEY ("user_id","item_code")
);

-- CreateTable
CREATE TABLE "loadouts" (
    "user_id" VARCHAR(64) NOT NULL,
    "boost_item_code" "item_code",
    "modifier_item_code" "item_code",
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "loadouts_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "runs" (
    "id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "route_id" VARCHAR(64) NOT NULL,
    "config_version" INTEGER NOT NULL,
    "status" "run_status" NOT NULL DEFAULT 'active',
    "integrity" "integrity" NOT NULL DEFAULT 'clean',
    "reason_codes" JSONB NOT NULL DEFAULT '[]',
    "locked_loadout" JSONB NOT NULL,
    "claim_id" VARCHAR(64),
    "claimed_at" TIMESTAMPTZ(6),
    "result" JSONB,
    "started_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ended_at" TIMESTAMPTZ(6),
    "last_sequence" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "runs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "run_location_batches" (
    "id" VARCHAR(64) NOT NULL,
    "run_id" VARCHAR(64) NOT NULL,
    "first_sequence" INTEGER NOT NULL,
    "last_sequence" INTEGER NOT NULL,
    "sample_count" INTEGER NOT NULL,
    "samples" JSONB NOT NULL,
    "received_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "run_location_batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "run_milestone_results" (
    "id" VARCHAR(64) NOT NULL,
    "run_id" VARCHAR(64) NOT NULL,
    "milestone_id" VARCHAR(64) NOT NULL,
    "ordinal" INTEGER NOT NULL,
    "client_reached_at" TIMESTAMPTZ(6),
    "client_location" JSONB,
    "last_sample_sequence" INTEGER,
    "status" VARCHAR(16) NOT NULL,
    "verification" VARCHAR(16) NOT NULL DEFAULT 'provisional',
    "verified_at" TIMESTAMPTZ(6),
    "active_sec_at_reach" INTEGER,
    "earned_exp" INTEGER NOT NULL DEFAULT 0,
    "protected" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "run_milestone_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "run_integrity_metrics" (
    "run_id" VARCHAR(64) NOT NULL,
    "metrics" JSONB NOT NULL,
    "reason_codes" JSONB NOT NULL DEFAULT '[]',
    "mode" "anti_cheat_mode" NOT NULL,
    "calculated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "run_integrity_metrics_pkey" PRIMARY KEY ("run_id")
);

-- CreateTable
CREATE TABLE "exp_ledger" (
    "id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "run_id" VARCHAR(64),
    "delta" INTEGER NOT NULL,
    "reason" VARCHAR(64) NOT NULL,
    "ref_id" VARCHAR(64),
    "idempotency_key" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exp_ledger_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coin_ledger" (
    "id" VARCHAR(64) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "run_id" VARCHAR(64),
    "delta" INTEGER NOT NULL,
    "carry_milli" INTEGER NOT NULL,
    "reason" VARCHAR(64) NOT NULL,
    "ref_id" VARCHAR(64),
    "idempotency_key" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "coin_ledger_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "anti_cheat_config" (
    "version" INTEGER NOT NULL,
    "mode" "anti_cheat_mode" NOT NULL,
    "thresholds" JSONB NOT NULL,
    "active_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "anti_cheat_config_pkey" PRIMARY KEY ("version")
);

-- CreateIndex
CREATE INDEX "users_created_at_idx" ON "users"("created_at");

-- CreateIndex
CREATE INDEX "profiles_level_code_total_exp_idx" ON "profiles"("level_code", "total_exp");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_hash_key" ON "refresh_tokens"("token_hash");

-- CreateIndex
CREATE INDEX "refresh_tokens_user_id_expires_at_idx" ON "refresh_tokens"("user_id", "expires_at");

-- CreateIndex
CREATE INDEX "refresh_tokens_family_id_idx" ON "refresh_tokens"("family_id");

-- CreateIndex
CREATE INDEX "idempotency_keys_expires_at_idx" ON "idempotency_keys"("expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "idempotency_keys_user_key_route_key" ON "idempotency_keys"("user_id", "key", "route");

-- CreateIndex
CREATE INDEX "game_config_versions_is_active_version_idx" ON "game_config_versions"("is_active", "version");

-- CreateIndex
CREATE INDEX "route_templates_level_code_distance_meters_status_idx" ON "route_templates"("level_code", "distance_meters", "status");

-- CreateIndex
CREATE UNIQUE INDEX "route_template_milestones_template_id_milestone_id_key" ON "route_template_milestones"("template_id", "milestone_id");

-- CreateIndex
CREATE UNIQUE INDEX "route_template_narrations_template_id_locale_key" ON "route_template_narrations"("template_id", "locale");

-- CreateIndex
CREATE INDEX "routes_user_id_status_created_at_idx" ON "routes"("user_id", "status", "created_at");

-- CreateIndex
CREATE INDEX "routes_template_id_user_id_used_at_idx" ON "routes"("template_id", "user_id", "used_at");

-- CreateIndex
CREATE INDEX "route_reports_template_id_status_created_at_idx" ON "route_reports"("template_id", "status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "route_reports_route_id_user_id_key" ON "route_reports"("route_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "runs_route_id_key" ON "runs"("route_id");

-- CreateIndex
CREATE UNIQUE INDEX "runs_claim_id_key" ON "runs"("claim_id");

-- CreateIndex
CREATE INDEX "runs_user_id_status_started_at_idx" ON "runs"("user_id", "status", "started_at");

-- CreateIndex
CREATE INDEX "runs_user_id_ended_at_idx" ON "runs"("user_id", "ended_at");

-- CreateIndex
CREATE INDEX "run_location_batches_run_id_first_sequence_idx" ON "run_location_batches"("run_id", "first_sequence");

-- CreateIndex
CREATE UNIQUE INDEX "run_location_batches_run_id_first_sequence_last_sequence_key" ON "run_location_batches"("run_id", "first_sequence", "last_sequence");

-- CreateIndex
CREATE UNIQUE INDEX "run_milestone_results_run_id_milestone_id_key" ON "run_milestone_results"("run_id", "milestone_id");

-- CreateIndex
CREATE UNIQUE INDEX "run_milestone_results_run_id_ordinal_key" ON "run_milestone_results"("run_id", "ordinal");

-- CreateIndex
CREATE UNIQUE INDEX "exp_ledger_idempotency_key_key" ON "exp_ledger"("idempotency_key");

-- CreateIndex
CREATE INDEX "exp_ledger_user_id_created_at_idx" ON "exp_ledger"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "exp_ledger_run_id_idx" ON "exp_ledger"("run_id");

-- CreateIndex
CREATE UNIQUE INDEX "coin_ledger_idempotency_key_key" ON "coin_ledger"("idempotency_key");

-- CreateIndex
CREATE INDEX "coin_ledger_user_id_created_at_idx" ON "coin_ledger"("user_id", "created_at");

-- CreateIndex
CREATE INDEX "coin_ledger_run_id_idx" ON "coin_ledger"("run_id");

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "idempotency_keys" ADD CONSTRAINT "idempotency_keys_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "route_template_milestones" ADD CONSTRAINT "route_template_milestones_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "route_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "route_template_narrations" ADD CONSTRAINT "route_template_narrations_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "route_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "routes" ADD CONSTRAINT "routes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "routes" ADD CONSTRAINT "routes_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "route_templates"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "routes" ADD CONSTRAINT "routes_config_version_fkey" FOREIGN KEY ("config_version") REFERENCES "game_config_versions"("version") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "route_reports" ADD CONSTRAINT "route_reports_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "routes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "route_reports" ADD CONSTRAINT "route_reports_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "route_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "route_reports" ADD CONSTRAINT "route_reports_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "loadouts" ADD CONSTRAINT "loadouts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "runs" ADD CONSTRAINT "runs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "runs" ADD CONSTRAINT "runs_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "routes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "run_location_batches" ADD CONSTRAINT "run_location_batches_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "run_milestone_results" ADD CONSTRAINT "run_milestone_results_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "run_integrity_metrics" ADD CONSTRAINT "run_integrity_metrics_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "runs"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exp_ledger" ADD CONSTRAINT "exp_ledger_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exp_ledger" ADD CONSTRAINT "exp_ledger_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "runs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coin_ledger" ADD CONSTRAINT "coin_ledger_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coin_ledger" ADD CONSTRAINT "coin_ledger_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "runs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


CREATE UNIQUE INDEX "game_config_versions_one_active" ON "game_config_versions" ("is_active") WHERE "is_active";
CREATE UNIQUE INDEX "users_email_lower_key" ON "users" (lower("email"));
CREATE UNIQUE INDEX "runs_one_active_per_user" ON "runs" ("user_id") WHERE "status" IN ('active', 'paused');
CREATE UNIQUE INDEX "routes_one_active_per_user" ON "routes" ("user_id") WHERE "status" IN ('generating', 'ready');
CREATE INDEX "route_templates_geometry_gist" ON "route_templates" USING GIST ("geometry");
CREATE INDEX "route_templates_start_point_gist" ON "route_templates" USING GIST ("start_point");
CREATE INDEX "route_template_milestones_location_gist" ON "route_template_milestones" USING GIST ("location");
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_nonnegative_balances_check" CHECK ("total_exp" >= 0 AND "coin_balance" >= 0 AND "coin_carry_milli" BETWEEN 0 AND 999 AND "rp_total" >= 0 AND "completed_runs" >= 0);
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_quantity_nonnegative_check" CHECK ("quantity" >= 0);
ALTER TABLE "route_templates" ADD CONSTRAINT "route_templates_metrics_check" CHECK ("distance_meters" > 0 AND "estimated_duration_sec" > 0 AND "estimated_calories" >= 0 AND "safety_score" BETWEEN 0 AND 1 AND "data_confidence" BETWEEN 0 AND 1);
ALTER TABLE "route_template_milestones" ADD CONSTRAINT "route_template_milestones_nonnegative_check" CHECK ("ordinal" >= 0 AND "distance_meters" >= 0 AND "radius_meters" > 0 AND "exp" >= 0);
ALTER TABLE "idempotency_keys" ADD CONSTRAINT "idempotency_keys_status_pair_check" CHECK (("state" = 'processing' AND "response" IS NULL AND "status_code" IS NULL) OR ("state" = 'completed' AND "response" IS NOT NULL AND "status_code" IS NOT NULL));
ALTER TABLE "runs" ADD CONSTRAINT "runs_last_sequence_nonnegative_check" CHECK ("last_sequence" >= 0);
ALTER TABLE "run_location_batches" ADD CONSTRAINT "run_location_batches_sequence_range_check" CHECK ("first_sequence" > 0 AND "last_sequence" >= "first_sequence" AND "sample_count" > 0);
ALTER TABLE "exp_ledger" ADD CONSTRAINT "exp_ledger_reason_nonempty_check" CHECK (length("reason") > 0);
ALTER TABLE "coin_ledger" ADD CONSTRAINT "coin_ledger_carry_range_check" CHECK ("carry_milli" BETWEEN 0 AND 999 AND length("reason") > 0);
CREATE FUNCTION reject_ledger_mutation() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN RAISE EXCEPTION 'ledger entries are append-only'; END; $$;
CREATE TRIGGER "exp_ledger_append_only" BEFORE UPDATE OR DELETE ON "exp_ledger" FOR EACH ROW EXECUTE FUNCTION reject_ledger_mutation();
CREATE TRIGGER "coin_ledger_append_only" BEFORE UPDATE OR DELETE ON "coin_ledger" FOR EACH ROW EXECUTE FUNCTION reject_ledger_mutation();