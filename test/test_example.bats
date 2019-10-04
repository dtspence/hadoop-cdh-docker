#!/usr/bin/env bats

@test "run sample map-reduce job" {
    run hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 10 100
    [ "$status" -eq 0 ]
}
