SELECT nurses.first_name, nurses.last_name, SUM(hours_worked) as total_hours,
MAX(CASE WHEN scheduled = TRUE AND hours_worked < 12 THEN date END) as last_calloff,
CASE WHEN
(SELECT MIN(nurse_hours)
FROM (
    SELECT SUM(hours_worked) as nurse_hours
    FROM `nurse-scheduling-493000.nurse_scheduling.shifts_table` as s
    INNER JOIN `nurse-scheduling-493000.nurse_scheduling.nurses_table` as n ON s.nurse_id=n.nurse_id
    WHERE s.date >= DATE_SUB(DATE '2026-03-28', INTERVAL 7 DAY)
    AND s.date <= DATE '2026-03-28'
    AND n.status = 'FT'
    GROUP BY s.nurse_id
)) >= 24 AND nurses.status = 'PRN' THEN 1 ELSE 0 END as prn_priority
FROM `nurse-scheduling-493000.nurse_scheduling.shifts_table` as shifts
INNER JOIN `nurse-scheduling-493000.nurse_scheduling.nurses_table` as nurses ON shifts.nurse_id = nurses.nurse_id
WHERE shifts.date >= DATE_SUB(DATE '2026-03-28', INTERVAL 7 DAY)
AND shifts.date <= DATE '2026-03-28'
AND shifts.nurse_id IN (
    SELECT nurse_id
    FROM `nurse-scheduling-493000.nurse_scheduling.shifts_table`
    WHERE date = DATE '2026-03-28'
    AND scheduled = TRUE
)
GROUP BY nurses.nurse_id, nurses.first_name, nurses.last_name, nurses.status
ORDER BY prn_priority, total_hours DESC, last_calloff