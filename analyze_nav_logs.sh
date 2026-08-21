#!/bin/bash

for f in "$@"
do
        tail -n +2 "$f" | awk -F',' '

                BEGIN{
                        first = 0
                }

                {
                if($2 == "Path"){
                        if(!first){
                                print "Run " $1
                                first = 1
                        }
                        print "From " $6, "to " $8, ": " $11 "seconds"
                }
                if($2 == "Decision"){
                        print "Decision time at " substr($5, index($5, " ") + 1) ":", $12 "seconds"
                }
                if($2 == "Summary"){
                        first = 0
                        print "Total time: " $18 "seconds"
                        print "--------------------------------------"
                }
        }'
done
