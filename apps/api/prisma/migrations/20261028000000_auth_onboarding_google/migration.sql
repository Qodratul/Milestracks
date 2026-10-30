ALTER TABLE "profiles"
ADD COLUMN "health_disclaimer_accepted_at" TIMESTAMPTZ(6);

CREATE TABLE "google_identities" (
    "google_subject" VARCHAR(255) NOT NULL,
    "user_id" VARCHAR(64) NOT NULL,
    "email" VARCHAR(320) NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "google_identities_pkey" PRIMARY KEY ("google_subject")
);

CREATE UNIQUE INDEX "google_identities_user_id_key"
ON "google_identities"("user_id");

ALTER TABLE "google_identities"
ADD CONSTRAINT "google_identities_user_id_fkey"
FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
