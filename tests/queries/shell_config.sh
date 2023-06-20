#!/usr/bin/env bash

# Don't check for ODR violation, since we may test shared build with ASAN
export ASAN_OPTIONS=detect_odr_violation=0

export CLICKHOUSE_DATABASE=${CLICKHOUSE_DATABASE:="test"}
export CLICKHOUSE_CLIENT_SERVER_LOGS_LEVEL=${CLICKHOUSE_CLIENT_SERVER_LOGS_LEVEL:="warning"}

# Unique zookeeper path (based on test name and current database) to avoid overlaps
export CLICKHOUSE_TEST_PATH="${BASH_SOURCE[1]}"
CLICKHOUSE_TEST_NAME="$(basename "$CLICKHOUSE_TEST_PATH" .sh)"
export CLICKHOUSE_TEST_NAME
export CLICKHOUSE_TEST_ZOOKEEPER_PREFIX="${CLICKHOUSE_TEST_NAME}_${CLICKHOUSE_DATABASE}"

export CNCH_WRITE_WORKER_HOST=${CNCH_WRITE_WORKER_HOST:="localhost"}
export CNCH_WRITE_WORKER_PORT_TCP=${CNCH_WRITE_WORKER_PORT_TCP:="8132"}

[ -v CLICKHOUSE_CONFIG_CLIENT ] && CLICKHOUSE_CLIENT_OPT0+=" --config-file=${CLICKHOUSE_CONFIG_CLIENT} " && CNCH_WRITE_WORKER_CLIENT_OPT+=" --config-file=${CLICKHOUSE_CONFIG_CLIENT} "
[ -v CLICKHOUSE_HOST ] && CLICKHOUSE_CLIENT_OPT0+=" --host=${CLICKHOUSE_HOST} "
[ -v CNCH_WRITE_WORKER_HOST} ] && CNCH_WRITE_WORKER_CLIENT_OPT+=" --host=${CNCH_WRITE_WORKER_HOST} "
[ -v CNCH_WRITE_WORKER_PORT_TCP ] && CNCH_WRITE_WORKER_CLIENT_OPT+=" --port=${CNCH_WRITE_WORKER_PORT_TCP} "

[ -v CLICKHOUSE_PORT_TCP ] && CLICKHOUSE_CLIENT_OPT0+=" --port=${CLICKHOUSE_PORT_TCP} "
[ -v CLICKHOUSE_PORT_TCP ] && CLICKHOUSE_BENCHMARK_OPT0+=" --port=${CLICKHOUSE_PORT_TCP} "
[ -v CLICKHOUSE_CLIENT_SERVER_LOGS_LEVEL ] && CLICKHOUSE_CLIENT_OPT0+=" --send_logs_level=${CLICKHOUSE_CLIENT_SERVER_LOGS_LEVEL} "
[ -v CLICKHOUSE_DATABASE ] && CLICKHOUSE_CLIENT_OPT0+=" --database=${CLICKHOUSE_DATABASE} "
[ -v CLICKHOUSE_LOG_COMMENT ] && CLICKHOUSE_CLIENT_OPT0+=" --log_comment='${CLICKHOUSE_LOG_COMMENT}' "
[ -v CLICKHOUSE_DATABASE ] && CLICKHOUSE_BENCHMARK_OPT0+=" --database=${CLICKHOUSE_DATABASE} "
[ -v CLICKHOUSE_LOG_COMMENT ] && CLICKHOUSE_BENCHMARK_OPT0+=" --log_comment='${CLICKHOUSE_LOG_COMMENT}' "

export CLICKHOUSE_BINARY=${CLICKHOUSE_BINARY:="clickhouse"}
# client
[ -x "$CLICKHOUSE_BINARY-client" ] && CLICKHOUSE_CLIENT_BINARY=${CLICKHOUSE_CLIENT_BINARY:=$CLICKHOUSE_BINARY-client}
[ -x "$CLICKHOUSE_BINARY" ] && CLICKHOUSE_CLIENT_BINARY=${CLICKHOUSE_CLIENT_BINARY:=$CLICKHOUSE_BINARY client}
export CLICKHOUSE_CLIENT_BINARY=${CLICKHOUSE_CLIENT_BINARY:=$CLICKHOUSE_BINARY-client}
export CLICKHOUSE_CLIENT_OPT="${CLICKHOUSE_CLIENT_OPT0:-} ${CLICKHOUSE_CLIENT_OPT:-}"
export CLICKHOUSE_CLIENT=${CLICKHOUSE_CLIENT:="$CLICKHOUSE_CLIENT_BINARY ${CLICKHOUSE_CLIENT_OPT:-}"}
export CNCH_WRITE_WORKER_CLIENT=${CNCH_WRITE_WORKER_CLIENT:="$CLICKHOUSE_CLIENT_BINARY ${CNCH_WRITE_WORKER_CLIENT_OPT}"}

# local
[ -x "${CLICKHOUSE_BINARY}-local" ] && CLICKHOUSE_LOCAL=${CLICKHOUSE_LOCAL:="${CLICKHOUSE_BINARY}-local"}
[ -x "${CLICKHOUSE_BINARY}" ] && CLICKHOUSE_LOCAL=${CLICKHOUSE_LOCAL:="${CLICKHOUSE_BINARY} local"}
export CLICKHOUSE_LOCAL=${CLICKHOUSE_LOCAL:="${CLICKHOUSE_BINARY}-local"}
# server
[ -x "${CLICKHOUSE_BINARY}-server" ] && CLICKHOUSE_SERVER_BINARY=${CLICKHOUSE_SERVER_BINARY:="${CLICKHOUSE_BINARY}-server"}
[ -x "${CLICKHOUSE_BINARY}" ] && CLICKHOUSE_SERVER_BINARY=${CLICKHOUSE_SERVER_BINARY:="${CLICKHOUSE_BINARY} server"}
export CLICKHOUSE_SERVER_BINARY=${CLICKHOUSE_SERVER_BINARY:="${CLICKHOUSE_BINARY}-server"}
# others
export CLICKHOUSE_OBFUSCATOR=${CLICKHOUSE_OBFUSCATOR:="${CLICKHOUSE_BINARY}-obfuscator"}
export CLICKHOUSE_COMPRESSOR=${CLICKHOUSE_COMPRESSOR:="${CLICKHOUSE_BINARY}-compressor"}
export CLICKHOUSE_BENCHMARK=${CLICKHOUSE_BENCHMARK:="${CLICKHOUSE_BINARY}-benchmark ${CLICKHOUSE_BENCHMARK_OPT0:-}"}
export CLICKHOUSE_GIT_IMPORT=${CLICKHOUSE_GIT_IMPORT="${CLICKHOUSE_BINARY}-git-import"}

export CLICKHOUSE_CONFIG=${CLICKHOUSE_CONFIG:="/etc/clickhouse-server/config.xml"}
export CLICKHOUSE_CONFIG_CLIENT=${CLICKHOUSE_CONFIG_CLIENT:="/etc/clickhouse-client/config.xml"}

[ -x "${CLICKHOUSE_BINARY}-extract-from-config" ] && CLICKHOUSE_EXTRACT_CONFIG=${CLICKHOUSE_EXTRACT_CONFIG:="$CLICKHOUSE_BINARY-extract-from-config --config=$CLICKHOUSE_CONFIG"}
[ -x "${CLICKHOUSE_BINARY}" ] && CLICKHOUSE_EXTRACT_CONFIG=${CLICKHOUSE_EXTRACT_CONFIG:="$CLICKHOUSE_BINARY extract-from-config --config=$CLICKHOUSE_CONFIG"}
export CLICKHOUSE_EXTRACT_CONFIG=${CLICKHOUSE_EXTRACT_CONFIG:="$CLICKHOUSE_BINARY-extract-from-config --config=$CLICKHOUSE_CONFIG"}

[ -x "${CLICKHOUSE_BINARY}-format" ] && CLICKHOUSE_FORMAT=${CLICKHOUSE_FORMAT:="$CLICKHOUSE_BINARY-format"}
[ -x "${CLICKHOUSE_BINARY}" ] && CLICKHOUSE_FORMAT=${CLICKHOUSE_FORMAT:="$CLICKHOUSE_BINARY format"}
export CLICKHOUSE_FORMAT=${CLICKHOUSE_FORMAT:="$CLICKHOUSE_BINARY-format"}

export CLICKHOUSE_CONFIG_GREP=${CLICKHOUSE_CONFIG_GREP:="/etc/clickhouse-server/preprocessed/config.xml"}

if [ -n "$ENABLE_IPV6" ]; then
  IP_ADDRESS=BYTED_HOST_IPV6
else
  IP_ADDRESS=$(hostname -I | cut -d " " -f 1) # container's ipv4 address
fi

export CLICKHOUSE_HOST="${CLICKHOUSE_HOST:=$IP_ADDRESS}"
export CLICKHOUSE_PORT_TCP=${CLICKHOUSE_PORT_TCP:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=tcp_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_TCP=${CLICKHOUSE_PORT_TCP:="9000"}
export CLICKHOUSE_PORT_TCP_SECURE=${CLICKHOUSE_PORT_TCP_SECURE:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=tcp_port_secure 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_TCP_SECURE=${CLICKHOUSE_PORT_TCP_SECURE:="9440"}
export CLICKHOUSE_PORT_TCP_WITH_PROXY=${CLICKHOUSE_PORT_TCP_WITH_PROXY:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=tcp_with_proxy_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_TCP_WITH_PROXY=${CLICKHOUSE_PORT_TCP_WITH_PROXY:="9010"}
export CLICKHOUSE_PORT_HTTP=${CLICKHOUSE_PORT_HTTP:=$(${CLICKHOUSE_EXTRACT_CONFIG} --key=http_port 2>/dev/null)}
export CLICKHOUSE_PORT_HTTP=${CLICKHOUSE_PORT_HTTP:="8123"}
export CLICKHOUSE_PORT_HTTPS=${CLICKHOUSE_PORT_HTTPS:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=https_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_HTTPS=${CLICKHOUSE_PORT_HTTPS:="8443"}
export CLICKHOUSE_PORT_HTTP_PROTO=${CLICKHOUSE_PORT_HTTP_PROTO:="http"}
export CLICKHOUSE_PORT_MYSQL=${CLICKHOUSE_PORT_MYSQL:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=mysql_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_MYSQL=${CLICKHOUSE_PORT_MYSQL:="9004"}
export CLICKHOUSE_PORT_POSTGRESQL=${CLICKHOUSE_PORT_POSTGRESQL:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=postgresql_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_POSTGRESQL=${CLICKHOUSE_PORT_POSTGRESQL:="9005"}
export CLICKHOUSE_PORT_KEEPER=${CLICKHOUSE_PORT_KEEPER:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=keeper_server.tcp_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_KEEPER=${CLICKHOUSE_PORT_KEEPER:="9181"}

export CLICKHOUSE_CLIENT_SECURE=${CLICKHOUSE_CLIENT_SECURE:=$(echo ${CLICKHOUSE_CLIENT} | sed 's/'"--port=${CLICKHOUSE_PORT_TCP}"'/'"--secure --port=${CLICKHOUSE_PORT_TCP_SECURE}"'/g')}

# Add database and log comment to url params
if [ -v CLICKHOUSE_URL_PARAMS ]
then
  export CLICKHOUSE_URL_PARAMS="${CLICKHOUSE_URL_PARAMS}&database=${CLICKHOUSE_DATABASE}"
else
  export CLICKHOUSE_URL_PARAMS="database=${CLICKHOUSE_DATABASE}"
fi
# Note: missing url encoding of the log comment.
[ -v CLICKHOUSE_LOG_COMMENT ] && export CLICKHOUSE_URL_PARAMS="${CLICKHOUSE_URL_PARAMS}&log_comment=${CLICKHOUSE_LOG_COMMENT}"

export CLICKHOUSE_URL=${CLICKHOUSE_URL:="${CLICKHOUSE_PORT_HTTP_PROTO}://${CLICKHOUSE_HOST}:${CLICKHOUSE_PORT_HTTP}/"}
export CLICKHOUSE_URL_HTTPS=${CLICKHOUSE_URL_HTTPS:="https://${CLICKHOUSE_HOST}:${CLICKHOUSE_PORT_HTTPS}/"}

# Add url params to url
if [ -v CLICKHOUSE_URL_PARAMS ]
then
  export CLICKHOUSE_URL="${CLICKHOUSE_URL}?${CLICKHOUSE_URL_PARAMS}"
  export CLICKHOUSE_URL_HTTPS="${CLICKHOUSE_URL_HTTPS}?${CLICKHOUSE_URL_PARAMS}"
fi

export CLICKHOUSE_PORT_INTERSERVER=${CLICKHOUSE_PORT_INTERSERVER:=$(${CLICKHOUSE_EXTRACT_CONFIG} --try --key=interserver_http_port 2>/dev/null)} 2>/dev/null
export CLICKHOUSE_PORT_INTERSERVER=${CLICKHOUSE_PORT_INTERSERVER:="9009"}
export CLICKHOUSE_URL_INTERSERVER=${CLICKHOUSE_URL_INTERSERVER:="${CLICKHOUSE_PORT_HTTP_PROTO}://${CLICKHOUSE_HOST}:${CLICKHOUSE_PORT_INTERSERVER}/"}

export CLICKHOUSE_CURL_COMMAND=${CLICKHOUSE_CURL_COMMAND:="curl"}
# The queries in CI are prone to sudden delays, and we often don't check for curl
# errors, so it makes sense to set a relatively generous timeout.
export CLICKHOUSE_CURL_TIMEOUT=${CLICKHOUSE_CURL_TIMEOUT:="60"}
export CLICKHOUSE_CURL=${CLICKHOUSE_CURL:="${CLICKHOUSE_CURL_COMMAND} -q -s --max-time ${CLICKHOUSE_CURL_TIMEOUT}"}
export CLICKHOUSE_TMP=${CLICKHOUSE_TMP:="."}
mkdir -p ${CLICKHOUSE_TMP}

export MYSQL_CLIENT_BINARY=${MYSQL_CLIENT_BINARY:="mysql"}
export MYSQL_CLIENT_CLICKHOUSE_USER=${MYSQL_CLIENT_CLICKHOUSE_USER:="default"}
# Avoids "Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'" when connecting to localhost
[ -v CLICKHOUSE_HOST ] && MYSQL_CLIENT_OPT0+=" --protocol tcp "
[ -v CLICKHOUSE_HOST ] && MYSQL_CLIENT_OPT0+=" --host ${CLICKHOUSE_HOST} "
[ -v CLICKHOUSE_PORT_MYSQL ] && MYSQL_CLIENT_OPT0+=" --port ${CLICKHOUSE_PORT_MYSQL} "
[ -v CLICKHOUSE_DATABASE ] && MYSQL_CLIENT_OPT0+=" --database ${CLICKHOUSE_DATABASE} "
MYSQL_CLIENT_OPT0+=" --user ${MYSQL_CLIENT_CLICKHOUSE_USER} "
export MYSQL_CLIENT_OPT="${MYSQL_CLIENT_OPT0:-} ${MYSQL_CLIENT_OPT:-}"
export MYSQL_CLIENT=${MYSQL_CLIENT:="$MYSQL_CLIENT_BINARY ${MYSQL_CLIENT_OPT:-}"}

export PROTOC_BINARY=${PROTOC_BINARY:="protoc"}

function clickhouse_client_removed_host_parameter()
{
    # removing only `--host=value` and `--host value` (removing '-hvalue' feels to dangerous) with python regex.
    # bash regex magic is arcane, but version dependant and weak; sed or awk are not really portable.
    $(echo "$CLICKHOUSE_CLIENT"  | python3 -c "import sys, re; print(re.sub('--host(\s+|=)[^\s]+', '', sys.stdin.read()))") "$@"
}
