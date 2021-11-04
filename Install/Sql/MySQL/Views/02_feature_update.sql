CREATE OR REPLACE VIEW feature_update AS

SELECT 
	ff.feature_id,
	vuf.vcs_update_id,
	vu.update_time as active_since,
	vu.name as summary
FROM 
	feature_files ff
	 JOIN application_file af ON ff.application_file_id = af.id
	 JOIN vcs_update_files vuf ON vuf.application_file_id = af.id
	 JOIN vcs_update vu ON vu.id = vuf.vcs_update_id
GROUP BY
	ff.feature_id,
	vuf.vcs_update_id;