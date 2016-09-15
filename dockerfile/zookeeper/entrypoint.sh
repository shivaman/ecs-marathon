#!/bin/bash
IP=$(curl -s --connect-timeout 3 -m 1 169.254.169.254/latest/meta-data/local-hostname || echo "127.0.0.1")

cat <<- EOF > /opt/exhibitor/defaults.conf
        zookeeper-data-directory=/opt/zookeeper/snapshots
        zookeeper-install-directory=/opt/zookeeper
        zookeeper-log-directory=/opt/zookeeper/transactions
        log-index-directory=/opt/zookeeper/transactions
        cleanup-period-ms=300000
        check-ms=30000
        backup-period-ms=600000
        client-port=${ZK_CLIENT_PORT}
        cleanup-max-files=20
        backup-max-store-ms=21600000
        connect-port=${ZK_CONNECT_PORT}
        observer-threshold=0
        election-port=${ZK_ELECTION_PORT}
        zoo-cfg-extra=tickTime\=500&initLimit\=10&syncLimit\=5&quorumListenOnAllIPs\=true
        auto-manage-instances-settling-period-ms=0
        auto-manage-instances=1
        auto-manage-instances-fixed-ensemble-size=${ENSEMBLE_SIZE}
EOF

if [[ -n ${S3_BUCKET} ]]; then
  echo "backup-extra=throttle\=&bucket-name\=${S3_BUCKET}&key-prefix\=${S3_PREFIX}&max-retries\=4&retry-sleep-ms\=30000" >> /opt/exhibitor/defaults.conf
  BACKUP_CONFIG="--configtype s3 --s3config ${S3_BUCKET}:${S3_PREFIX} --s3region ${S3_REGION} --s3backup true"
else
  BACKUP_CONFIG="--configtype file --fsconfigdir /opt/zookeeper/local_configs --filesystembackup true"
fi


exec 2>&1
exec java -jar /opt/exhibitor/exhibitor.jar \
  --port ${EXHIBITOR_PORT} --defaultconfig /opt/exhibitor/defaults.conf ${BACKUP_CONFIG} --hostname ${IP}
