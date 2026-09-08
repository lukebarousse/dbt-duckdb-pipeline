-- The question this model answers: 
-- each month, what SHARE of postings are remote?

WITH totals AS (
    SELECT month, SUM(postings) AS total_postings
    FROM {{ ref("jobs_per_month")}}
    GROUP BY month
),
remote AS (
    SELECT
        DATE_TRUNC('month', search_date) AS month,
        COUNT(*) AS remote_postings
    FROM {{  ref("job_postings")}}
    WHERE job_work_from_home
    GROUP BY month
)
SELECT
    month,
    total_postings,
    remote_postings,
    ROUND(remote_postings/total_postings * 100, 1) AS pct_remote
FROM totals
INNER JOIN remote USING (month)
ORDER BY month