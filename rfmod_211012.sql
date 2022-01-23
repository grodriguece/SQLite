DROP TABLE IF EXISTS rfportNorOcc;
CREATE TABLE rfportNorOcc AS
SELECT *
FROM rfport_usage
WHERE plmn_id = 'rc7' OR plmn_id = 'rc8';