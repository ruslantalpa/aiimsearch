DROP SCHEMA IF EXISTS "data" CASCADE;
CREATE SCHEMA "data";

-- "data".domains definition

-- Drop table

-- DROP TABLE "data".domains;
DROP TABLE IF EXISTS "data".domains;
CREATE TABLE "data".domains (
	"name" varchar NOT NULL,
	enabled bool NULL DEFAULT false,
	funding int4 NULL,
	CONSTRAINT domains_pk PRIMARY KEY (name)
);

-- "data".documents definition

-- Drop table

-- DROP TABLE "data".documents;

DROP TABLE IF EXISTS "data".documents;
CREATE TABLE "data".documents (
	"content" text NOT NULL,
	title text NOT NULL,
	url text NOT NULL,
	"domain" varchar NOT NULL,
	CONSTRAINT documents_pk PRIMARY KEY (url)
);


-- "data".documents foreign keys

ALTER TABLE "data".documents ADD CONSTRAINT documents_fk FOREIGN KEY ("domain") REFERENCES "data".domains("name");


-- "data".filter_categories definition

-- Drop table

-- DROP TABLE "data".filter_categories;

DROP TABLE IF EXISTS "data".filter_categories;
CREATE TABLE "data".filter_categories (
	"name" varchar NOT NULL,
	"order" int4 NULL,
	enabled bool NULL DEFAULT false,
	description text NOT NULL,
	CONSTRAINT filter_categories_pk PRIMARY KEY (name),
	CONSTRAINT filter_categories_un UNIQUE ("order")
);

-- "data".filter_values definition

-- Drop table

-- DROP TABLE "data".filter_values;

DROP TABLE IF EXISTS "data".filter_values;
CREATE TABLE "data".filter_values (
	"label" varchar NOT NULL,
	threshold numeric NOT NULL,
	enabled bool NULL DEFAULT false,
	category_name varchar NOT NULL,
	CONSTRAINT filter_values_pk PRIMARY KEY (label, category_name),
	CONSTRAINT filter_values_un UNIQUE (threshold, label, category_name)
);


-- "data".filter_values foreign keys

ALTER TABLE "data".filter_values ADD CONSTRAINT filter_values_fk FOREIGN KEY (category_name) REFERENCES "data".filter_categories("name");


-- "data".domain_category_values definition

-- Drop table

-- DROP TABLE "data".domain_category_values;

DROP TABLE IF EXISTS "data".domain_category_values;
CREATE TABLE "data".domain_category_values (
	value numeric NOT NULL DEFAULT 0,
	"domain" varchar NOT NULL,
	filter_category varchar NOT NULL,
	CONSTRAINT domain_category_values_pk PRIMARY KEY (domain, filter_category)
);


-- "data".domain_category_values foreign keys

ALTER TABLE "data".domain_category_values ADD CONSTRAINT domain_category_values_fk FOREIGN KEY ("domain") REFERENCES "data".domains("name");
ALTER TABLE "data".domain_category_values ADD CONSTRAINT domain_category_values_fk_1 FOREIGN KEY (filter_category) REFERENCES "data".filter_categories("name");


-- "data".config definition

-- Drop table

-- DROP TABLE "data".config;

DROP TABLE IF EXISTS "data".config;
CREATE TABLE "data".config (
	description_filters text NOT NULL,
	description_search text NOT NULL,
	limit_results_per_page int4 NOT NULL,
	limit_words_short_description int4 NOT NULL,
	limit_search_suggestions int4 NOT NULL
);

DROP FUNCTION IF EXISTS "data".get_filter_value(_domain text, _category text);
CREATE OR REPLACE FUNCTION "data".get_filter_value(_domain text, _category text)
 RETURNS numeric
 LANGUAGE sql
 IMMUTABLE
AS $function$ 
 select value from data.domain_category_values dcv 
     where dcv.domain = _domain and dcv.filter_category = _category 
$function$
;


-- "data".search_container source
DROP VIEW IF EXISTS "data".search_container;
CREATE OR REPLACE VIEW "data".search_container
AS SELECT d.content,
    d.title,
    d.url,
    d.domain,
    "data".get_filter_value(d.domain::text, 'comprehensibility'::text) AS comprehensibility,
    "data".get_filter_value(d.domain::text, 'user_friendliness'::text) AS user_friendliness,
    "data".get_filter_value(d.domain::text, 'trustworthiness'::text) AS trustworthiness,
    "data".get_filter_value(d.domain::text, 'recency'::text) AS recency,
    "do".funding
   FROM data.documents d
     JOIN data.domains "do" ON "do".name::text = d.domain::text
  WHERE "do".enabled = true;
