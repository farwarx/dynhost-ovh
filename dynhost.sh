#/bin/sh

### CONFIG ###
HOST="DOMAIN_NAME"
LOGIN="LOGIN"
PASSWORD="PASSWORD"
LOG_FILE=/var/log/dynhost.log

# Get current IPv4 and corresponding configured
HOST_IP=$(host -4 ${HOST} | cut -d" " -f4)
CURRENT_IP=$(curl -m 5 -4 ifconfig.co 2>/dev/null)

### EXECUTION ###
touch "$LOG_FILE"
LOG_PREFIX="$(date) - Current IP: $CURRENT_IP ; Host IP: $HOST_IP"

if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
    echo "No IP retrieved" >> $PATH_LOG
else

# Update dynamic IPv4, if needed
if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
  echo "[$CURRENT_DATETIME]: No IP retrieved" >> $PATH_LOG
else
  if [ "$HOST_IP" != "$CURRENT_IP" ]
  then
    RES=$(curl -m 5 --insecure --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP")
    LOG_SUFFIX="IP has changed - Result request dynHost: $RES"
  else
    LOG_SUFFIX="IP has not changed"
  fi
fi
echo "$LOG_PREFIX - $LOG_SUFFIX" >> "$LOG_FILE"