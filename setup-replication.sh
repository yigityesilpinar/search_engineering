usage() {
  echo "Example: ./setup-replication.sh -l opensearch-cl1-node1:9300 -f https://localhost:9201 -i bbuy_products -a bbuy_products-replication"
  exit 2
}
LEADER_SEED_HOST="opensearch-cl1-node1:9300"
FOLLOWER_HOST="https://localhost:9201"
INDEX_NAME="bbuy_products"
REPLICATION_ALIAS="$INDEX_NAME-replication"

while getopts ':l:f:h:i:a:' c; do
  case $c in
  l) LEADER_SEED_HOST=$OPTARG ;;
  f) FOLLOWER_HOST=$OPTARG ;;
  i) INDEX_NAME=$OPTARG ;;
  a) REPLICATION_ALIAS=$OPTARG ;;
  h) usage ;;
  [?])
    echo "Invalid option: -${OPTARG}"
    usage
    ;;
  esac
done
shift $((OPTIND - 1))

echo "Replicating index $INDEX_NAME"
set -x

curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' "$FOLLOWER_HOST/_cluster/settings?pretty" -d '
{
  "persistent": {
    "cluster": {
      "remote": {
        "'$REPLICATION_ALIAS'": {
          "seeds": ["'$LEADER_SEED_HOST'"]
        }
      }
    }
  }
}'
if [ $? -ne 0 ]; then
  echo "Failed to set up a cross-cluster connection"
  exit 2
fi
curl -XPUT -k -H 'Content-Type: application/json' -u 'admin:admin' "$FOLLOWER_HOST/_plugins/_replication/$INDEX_NAME/_start?pretty" -d '
{
   "leader_alias": "'$REPLICATION_ALIAS'",
   "leader_index": "'$INDEX_NAME'",
   "use_roles":{
      "leader_cluster_role": "all_access",
      "follower_cluster_role": "all_access"
   }
}'
if [ $? -ne 0 ]; then
  echo "Failed to replicate index $INDEX_NAME"
  exit 2
fi
