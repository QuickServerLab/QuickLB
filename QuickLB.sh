#!/bin/bash
#-XX:+UseParallelGC
exec java -server -Dappname=QuickLB -XX:CompileThreshold=1500 -XX:+UseConcMarkSweepGC -jar dist/QuickLB.jar $@
