#!/usr/bin/env bats

@test "run sample map-reduce job" {
    run hadoop jar /opt/hadoop/current/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0-cdh5.14.2.jar pi 10 100
    [ "$status" -eq 0 ]
}