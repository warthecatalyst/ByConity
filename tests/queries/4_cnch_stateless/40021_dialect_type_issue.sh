#!/usr/bin/env bash

CURDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=../shell_config.sh
. "$CURDIR"/../shell_config.sh

# remove any predefined dialect type
CLICKHOUSE_CLIENT=$(echo ${CLICKHOUSE_CLIENT} | sed 's/'"--dialect_type=[[:alpha:]]\+"'//g')

CLICKHOUSE_CLIENT_ANSI="$CLICKHOUSE_CLIENT --dialect_type=ANSI --enable_replace_group_by_literal_to_symbol=0"
CLICKHOUSE_CLIENT_CK="$CLICKHOUSE_CLIENT --dialect_type=CLICKHOUSE --enable_replace_group_by_literal_to_symbol=1"

$CLICKHOUSE_CLIENT_ANSI -nmq \
  "select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name;"

echo "---"

$CLICKHOUSE_CLIENT_ANSI -nmq \
  "set dialect_type='CLICKHOUSE', enable_replace_group_by_literal_to_symbol=1; \
   select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name;"

echo "---"

$CLICKHOUSE_CLIENT_ANSI -nmq \
  "set dialect_type='CLICKHOUSE', enable_replace_group_by_literal_to_symbol=1; \
   select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name \
   settings dialect_type='ANSI', enable_replace_group_by_literal_to_symbol=0;"

echo "---"

$CLICKHOUSE_CLIENT_CK -nmq \
  "select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name;"

echo "---"

$CLICKHOUSE_CLIENT_CK -nmq \
  "set dialect_type='ANSI', enable_replace_group_by_literal_to_symbol=0; \
   select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name;"

echo "---"

$CLICKHOUSE_CLIENT_CK -nmq \
  "set dialect_type='ANSI', enable_replace_group_by_literal_to_symbol=0; \
   select name, value from system.settings \
   where name in ('dialect_type', 'enable_replace_group_by_literal_to_symbol') \
   order by name \
   settings dialect_type='CLICKHOUSE', enable_replace_group_by_literal_to_symbol=1;"
