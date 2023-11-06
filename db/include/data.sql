-- Default data
-- In particular the filter_categories as well as application default information

INSERT INTO "data".filter_categories ("name", "order", "enabled", "description")
VALUES 
    ('comprehensibility', 1, true, 'comprehensibility TODO'),
    ('user_friendliness', 2, true, 'user_friendliness TODO'),
    ('trustworthiness', 3, true, 'trustworthiness TODO'),
    ('recency', 4, true, 'recency TODO');

INSERT INTO "data".filter_values ("label", threshold, "enabled", category_name)
VALUES 
    ('unwichtig', 0.0, true, 'comprehensibility'),
    ('eher wichtig', 0.33, true, 'comprehensibility'),
    ('wichtig', 0.66, true, 'comprehensibility'),
    ('sehr wichtig', 1.0, true, 'comprehensibility'),
    ('unwichtig', 0.0, true, 'user_friendliness'),
    ('eher wichtig', 0.33, true, 'user_friendliness'),
    ('wichtig', 0.66, true, 'user_friendliness'),
    ('sehr wichtig', 1.0, true, 'user_friendliness'),
    ('unwichtig', 0.0, true, 'trustworthiness'),
    ('eher wichtig', 0.33, true, 'trustworthiness'),
    ('wichtig', 0.66, true, 'trustworthiness'),
    ('sehr wichtig', 1.0, true, 'trustworthiness'),
    ('unwichtig', 0.0, true, 'recency'),
    ('eher wichtig', 0.33, true, 'recency'),
    ('wichtig', 0.66, true, 'recency'),
    ('sehr wichtig', 1.0, true, 'recency');


INSERT INTO "data".config (description_filters, description_search, limit_results_per_page, limit_words_short_description, limit_search_suggestions)
VALUES 
    ('description_filters TODO', 'description_search TODO', 20, 32, 10);


-- TO import data: 
-- $ \copy "data".import_interface FROM './sample.csv' ENCODING 'UTF8' CSV NULL '' QUOTE'"' ESCAPE '\' DELIMITER ',' HEADER;

