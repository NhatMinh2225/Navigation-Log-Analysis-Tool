# Navigation Log Analyzer

A command-line tool for analyzing navigation log CSV files exported from MentalSpace. Built with Bash and AWK on Linux.

## What It Does

This script parses navigation log CSV files and reports:

- Number of runs
- Travel time between nodes
- Decision time at each node
- Total time per run

## Requirements

- Linux environment
- Bash
- AWK

## Usage

1. Download `analyze_nav_logs.sh` along with your CSV input files.
2. Make the script executable (if needed):
   ```bash
   chmod +x analyze_nav_logs.sh
   ```
3. Run it against a single file:
   ```bash
   ./analyze_nav_logs.sh path_result_xxx.csv
   ```
4. Or run it against all matching files at once:
   ```bash
   ./analyze_nav_logs.sh path_result_*.csv
   ```

## Example Output

```
Run 1
From S1 to L1_1 : 14.16seconds
From L1_1 to L2_2 : 13.32seconds
From L2_2 to E1 : 18.3seconds
Decision time at L1_2: 9.48seconds
Decision time at L2_2: 7.16seconds
Total time: 45.78seconds
--------------------------------------
Run 2
From S1 to L1_0 : 13.94seconds
From L1_0 to L2_3 : 24.7seconds
From L2_3 to E0 : 17.82seconds
Decision time at L1_0: 2.88seconds
Decision time at L2_3: 5.34seconds
Total time: 56.46seconds
--------------------------------------
```

Each run shows the path taken from node to node with travel times, the decision time spent at intermediate nodes, and the total time for that run.
