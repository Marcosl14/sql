CREATE TABLE "users" (
  "user_id" SERIAL PRIMARY KEY,
  "username" varchar UNIQUE NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password" varchar NOT NULL,
  "name" varchar NOT NULL,
  "role" varchar NOT NULL,
  "gender" varchar(10) NOT NULL,
  "avatar" varchar,
  "created_at" timestamp DEFAULT 'now()'
);

CREATE TABLE "posts" (
  "post_id" SERIAL PRIMARY KEY,
  "title" varchar(200) DEFAULT '',
  "body" text DEFAULT '',
  "og_image" varchar,
  "slug" varchar UNIQUE NOT NULL,
  "published" boolean,
  "created_by" integer,
  "created_at" timestamp DEFAULT 'now()'
);

CREATE TABLE "claps" (
  "clap_id" SERIAL PRIMARY KEY,
  "post_id" integer,
  "user_id" integer,
  "counter" integer DEFAULT 0,
  "created_at" timestamp
);

CREATE TABLE "comments" (
  "comment_id" SERIAL PRIMARY KEY,
  "post_id" integer,
  "user_id" increment,
  "content" text,
  "created_at" timestamp,
  "visible" boolean,
  "comment_parent_id" integer
);

CREATE TABLE "user_lists" (
  "user_list_id" SERIAL PRIMARY KEY,
  "user_id" integer,
  "title" varchar(100)
);

CREATE TABLE "user_list_entry" (
  "user_list_entry" SERIAL PRIMARY KEY,
  "user_list_id" integer,
  "post_id" integer
);

ALTER TABLE "posts" ADD FOREIGN KEY ("created_by") REFERENCES "users" ("user_id");

ALTER TABLE "claps" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("post_id");

ALTER TABLE "claps" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "comments" ADD FOREIGN KEY ("comment_id") REFERENCES "posts" ("post_id");

ALTER TABLE "comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "comments" ADD FOREIGN KEY ("comment_parent_id") REFERENCES "comments" ("comment_id");

ALTER TABLE "user_lists" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "user_list_entry" ADD FOREIGN KEY ("user_list_id") REFERENCES "user_lists" ("user_list_id");

ALTER TABLE "user_list_entry" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("post_id");

CREATE UNIQUE INDEX "user_post_claps_index" ON "claps" ("post_id", "user_id");

CREATE INDEX "post_claps_index" ON "claps" ("post_id");

CREATE INDEX "post_comments_index" ON "comments" ("post_id");

CREATE INDEX "post_visibility_index" ON "comments" ("visible");

CREATE UNIQUE INDEX "userlists_user_title_index" ON "user_lists" ("user_id", "title");

CREATE INDEX "userlists_user_index" ON "user_lists" ("user_id");

COMMENT ON TABLE "users" IS 'Users Table';

COMMENT ON COLUMN "users"."user_id" IS 'This PK should be ALWAYS';

COMMENT ON COLUMN "posts"."published" IS '💸 true,
❌ false,';
