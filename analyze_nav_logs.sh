#!/bin/bash
# Navigation Log Analysis Tool
# For each playthrough: prints travel time A->B, decision time per node,
# and total run time (from the Summary row).

LOG_DIR="${1:-.}"

for f in "$LOG_DIR"/path_results_*.csv; do
    [ -f "$f" ] || continue
    echo "=== $(basename "$f") ==="

    awk -F',' '
        NR==1 { next }
        $2 == "Path" {
            print "  Run " $1 ": " $6 " -> " $8 "  travel_time=" $11 "s"
        }
        $2 == "Decision" {
            print "  Run " $1 ": decision @ " $5 "  decision_time=" $12 "s"
        }
        $2 == "Summary" {
            total = $18 + $19
            printf "  Run %s: TOTAL travel=%.2fs decision=%.2fs run_total=%.2fs\n\n", $1, $18, $19, total
        }
    ' "$f"
done
