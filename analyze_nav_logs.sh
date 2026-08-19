#!/bin/bash
# Navigation Log Analysis Tool
# Analyzes MentalSpace navigation CSV logs (path_results_*.csv)
# CSV columns:
# PlaythroughID,RecordType,CompletionStatus,Order,Name,FromNode,FromNodeEnterTimestamp,
# ToNode,ToNodeEnterTimestamp,Weight,TravelTime,DecisionTime,DecisionEnterTimestamp,
# DecisionExitTimestamp,ToDecisionNodeAndEnd,ExitEnterTimestamp,
# FinalTotalWeight,FinalTravelTime,FinalDecisionTime

LOG_DIR="${1:-.}"
OUT="session_summary.csv"

echo "File,PlaythroughID,CompletionStatus,PathSegments,Decisions,TotalWeight,TotalTravelTime,TotalDecisionTime" > "$OUT"

for f in "$LOG_DIR"/path_results_*.csv; do
    [ -f "$f" ] || continue

    # Per-session metrics via awk (field-separated by comma, skip header)
    awk -F',' -v fname="$(basename "$f")" '
        NR==1 { next }
        {
            id = $1
            status[id] = $3            # last CompletionStatus wins
            if ($2 == "Path") {
                segs[id]++
                w[id]   += $10          # Weight
                tt[id]  += $11          # TravelTime
            } else if ($2 == "Decision") {
                dec[id]++
                dt[id]  += $12          # DecisionTime
            }
        }
        END {
            for (id in status) {
                printf "%s,%s,%s,%d,%d,%.2f,%.2f,%.2f\n",
                    fname, id, status[id], segs[id]+0, dec[id]+0,
                    w[id]+0, tt[id]+0, dt[id]+0
            }
        }
    ' "$f" >> "$OUT"
done

echo "Per-session summary written to $OUT"

# --- Aggregate stats using grep / sort / uniq ---
echo
echo "Completion status distribution:"
grep -v "^File" "$OUT" | awk -F',' '{print $3}' | sort | uniq -c | sort -rn

echo
echo "Most frequently visited nodes (FromNode) across all logs:"
for f in "$LOG_DIR"/path_results_*.csv; do
    grep ",Path," "$f" | cut -d',' -f6
done | sort | uniq -c | sort -rn | head -10

echo
echo "Sessions with most decisions:"
sort -t',' -k5 -rn "$OUT" | head -5
