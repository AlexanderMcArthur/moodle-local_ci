${basereq} --action getIssueList \
           --search "project = 'Moodle' \
                 AND status = 'Waiting for integration review' \
                 AND (labels IS EMPTY OR labels NOT IN (ci, security_held, integration_held)) \
                 AND level IS EMPTY \
                 AND 'Currently in integration' IS NOT EMPTY \
                 ORDER BY priority DESC, votes DESC" \
           --outputFormat 101 \
           --file "${resultfile}"
