#sends an event to splunk webhook

echo $0 ${targetURL} ${hecToken}
url=$1
hecToken=$2

basic="u:${hecToken}"
header="Authorization: Splunk ${hecToken}"

event=" "

curl -u "${basic}" -k ${url} -d '{"event": { "text": "basic auth" }}'

echo ""
curl -H "${header}" -k ${url} -d '{"event": { "text": "header" }}'
echo ""
