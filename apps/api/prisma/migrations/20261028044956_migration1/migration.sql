-- DropIndex
DROP INDEX "route_template_milestones_location_gist";

-- DropIndex
DROP INDEX "route_templates_geometry_gist";

-- DropIndex
DROP INDEX "route_templates_start_point_gist";

-- RenameIndex
ALTER INDEX "routes_user_replaces_created_idx" RENAME TO "routes_user_id_replaces_route_id_created_at_idx";
