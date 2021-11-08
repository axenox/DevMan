CREATE OR REPLACE VIEW server_software AS
SELECT 
	ssl3.id,
	ssl3.created_on,
	ssl3.modified_on,
	ssl3.created_by_user_oid,
	ssl3.modified_by_user_oid,
	ssl3.server_id,
	ssl3.software_id,
	ssl3.version AS current_version,
	ssl3.installed_on AS last_update_on,
	ssl3.update_interval_months
FROM (
		SELECT 
			ssl1.server_id,
			ssl1.software_id,
			MAX(ssl1.installed_on) AS installed_on
		FROM server_software_log ssl1 
		GROUP BY ssl1.server_id, ssl1.software_id
	) ssl2 
	INNER JOIN server_software_log ssl3 
		ON ssl3.server_id = ssl2.server_id 
		AND ssl3.software_id = ssl2.software_id 
		AND ssl3.installed_on = ssl2.installed_on
WHERE ssl3.uninstalled_on IS NULL;