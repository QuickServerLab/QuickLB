@echo off
title QuickLB %*

rem set JAVA_HOME=d:\jdk1.6.0_23
rem set JAVA=%JAVA_HOME%\bin\java
rem set cp1=-cp %JAVA_HOME%\lib\tools.jar;.;

set JVM_OPTIONS=-XX:CompileThreshold=1500 -XX:+UseConcMarkSweepGC

java -server %JVM_OPTIONS% -Dappname=QuickLB -jar dist\QuickLB.jar %*

