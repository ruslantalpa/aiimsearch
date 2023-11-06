-- Import view
-- Requires the categories: 'trustworthiness', 'recency', 'user_friendliness', 'comprehensibility'
-- to be present in the "data".filter_categories table

-- Import view to be mapped onto a csv file
DROP VIEW IF EXISTS "data".import_interface;
CREATE VIEW "data".import_interface as
SELECT 
    'domain' as domain,
    'title' as title,
    'content' as content,
    'url' as url,
    'trustworthiness' as trustworthiness,
    'recency' as recency,
    'user_friendliness' as user_friendliness,
    'comprehensibility' as comprehensibility;

-- Import trigger function to store the data from the view row by row into the database
CREATE OR REPLACE FUNCTION "data".insert_document_function() 
RETURNS TRIGGER 
LANGUAGE PLPGSQL 
AS $$ 
BEGIN
    -- Store domain if not already present
    INSERT INTO "data".domains(name, enabled, funding)
    VALUES (NEW.domain, true, 0)
    ON CONFLICT DO NOTHING;

    -- Store domain category values if not already present
    INSERT INTO "data".domain_category_values(value, domain, filter_category)
    VALUES (NEW.comprehensibility :: numeric, NEW.domain, 'comprehensibility')
    ON CONFLICT DO NOTHING;
    INSERT INTO "data".domain_category_values(value, domain, filter_category)
    VALUES (NEW.user_friendliness :: numeric, NEW.domain, 'user_friendliness')
    ON CONFLICT DO NOTHING;
    INSERT INTO "data".domain_category_values(value, domain, filter_category)
    VALUES (NEW.trustworthiness :: numeric, NEW.domain, 'trustworthiness')
    ON CONFLICT DO NOTHING;
    INSERT INTO "data".domain_category_values(value, domain, filter_category)
    VALUES (NEW.recency :: numeric, NEW.domain, 'recency')
    ON CONFLICT DO NOTHING;

    -- Store document, ignore if it already exists
    INSERT INTO "data".documents(content, title, url, domain)
    VALUES (NEW.content, NEW.title, NEW.url, NEW.domain)
    ON CONFLICT DO NOTHING;

    RETURN NEW;

END $$;

-- Import trigger configuration
DROP TRIGGER IF EXISTS insert_document_interface ON "data".import_interface;
CREATE TRIGGER insert_document_interface INSTEAD OF INSERT ON "data".import_interface 
    FOR EACH ROW EXECUTE FUNCTION "data".insert_document_function();