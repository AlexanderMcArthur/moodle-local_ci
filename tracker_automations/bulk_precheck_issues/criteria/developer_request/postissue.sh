# Remove the "cime" label.
${basereq} --action removeLabels \
    --issue ${issue} \
    --labels "cime"

# Add the comment with results
comment=$(cat "${resultfile}.${issue}")
${basereq} --action addComment \
    --issue ${issue} \
    --comment "${comment}"
