#!/usr/bin/env bats

@test "check native environment" {
    run hadoop checknative
    [ "$status" -eq 0 ]
}