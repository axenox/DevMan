CREATE OR REPLACE VIEW release_tickets AS
SELECT 
    t.id AS ticket_id,
    IFNULL(rp.id, rip.id) AS release_id
FROM `release` rp
    LEFT JOIN release_includes ri ON rp.id = ri.release_id
    LEFT JOIN `release` rip ON rip.id = ri.release_included_id
    LEFT JOIN ticket t ON t.release_id = rp.id OR t.release_id = rip.id