ALTER TABLE "routes" ALTER COLUMN "template_id" DROP NOT NULL;
ALTER TABLE "routes" ADD COLUMN "generation_input" JSONB;
ALTER TABLE "routes" ADD COLUMN "replaces_route_id" VARCHAR(64);
ALTER TABLE "routes" DROP CONSTRAINT "routes_template_id_fkey";
ALTER TABLE "routes"
  ADD CONSTRAINT "routes_template_id_fkey"
  FOREIGN KEY ("template_id") REFERENCES "route_templates"("id")
  ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "routes"
  ADD CONSTRAINT "routes_replaces_route_id_fkey"
  FOREIGN KEY ("replaces_route_id") REFERENCES "routes"("id")
  ON DELETE SET NULL ON UPDATE CASCADE;
CREATE UNIQUE INDEX "routes_replaces_route_id_key" ON "routes"("replaces_route_id");
CREATE INDEX "routes_user_replaces_created_idx"
  ON "routes"("user_id", "replaces_route_id", "created_at");
