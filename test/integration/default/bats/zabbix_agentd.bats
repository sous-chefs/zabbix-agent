#!/usr/bin/env bats

@test "Zabbix agent is running" {
  ps -ef |grep -v grep|grep -q zabbix_agentd
  [ "$status" -eq 0 ]
}
