CREATE OR REPLACE VIEW application_installed AS
SELECT rd.id AS release_deployment_id,
       rd.release_id,
       rd.installation_id,
       rd.deployed_on,
       ra.application_id
       -- , r.name
       -- , latest.max_deployed_on
       -- , latest.installation_id
       -- , latest.application_id
FROM release_deployments rd
    INNER JOIN release_applications ra ON ra.release_id = rd.release_id
    INNER JOIN (
        SELECT 
            lra.application_id,
            lrd.installation_id,
            MAX(lrd.deployed_on) AS max_deployed_on
        FROM release_deployments lrd
            INNER JOIN release_applications lra ON lrd.release_id = lra.release_id
        GROUP BY lrd.installation_id, lra.application_id
    ) latest ON ra.application_id = latest.application_id
        AND rd.installation_id = latest.installation_id
        AND rd.deployed_on = latest.max_deployed_on
    INNER JOIN `release` r ON r.id = rd.release_id
-- WHERE rd.installation_id = 17