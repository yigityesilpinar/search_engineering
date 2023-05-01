usage()
{
  echo "Usage: $0 [-y /path/to/python/indexing/code] [-k week number, as in week1] [-b batch size of number of docs to send in one request.]  [-o hostname where OpenSearch is running. Default is localhost] [-m max docs PER WORKER. Default: 2000000] [-w number of threads. Default: 8] [-d /path/to/kaggle/best/buy/datasets] [-p /path/to/bbuy/products/field/mappings] [ -g /path/to/write/logs/to ]"
  echo "Example: ./index-data.sh  -y /Users/grantingersoll/projects/corise/search_engineering/src/main/python/search_eng/week1_finished   -d /Users/grantingersoll/projects/corise/datasets/bbuy  -p /Users/grantingersoll/projects/corise/search_engineering/src/main/conf/bbuy_products.json -g /tmp"
  exit 2
}

DATASETS_DIR=`pwd`/datasets
PYTHON_LOC=`pwd`
WEEK=`pwd`/utilities #Default indexing is in utilities
PRODUCTS_JSON_FILE="bbuy_products.json"
HOST="localhost"
INDEX_NAME="bbuy_products"
LOGS_DIR=`pwd`/logs
WORKERS=8
MAX_DOCS=2000000
BATCH_SIZE=200
while getopts ':p:b:k:i:o:g:y:d:m:w:h' c
do
  case $c in
    b) BATCH_SIZE=$OPTARG ;;
    d) DATASETS_DIR=$OPTARG ;;
    g) LOGS_DIR=$OPTARG ;;
    k) WEEK=$OPTARG ;;
    i) INDEX_NAME=$OPTARG ;;
    m) MAX_DOCS=$OPTARG ;;
    o) HOST=$OPTARG ;;
    p) PRODUCTS_JSON_FILE=$OPTARG ;;
    w) WORKERS=$OPTARG ;;
    y) PYTHON_LOC=$OPTARG ;;
    h) usage ;;
    [?])
      echo "Invalid option: -${OPTARG}"
      usage ;;
  esac
done
shift $((OPTIND -1))

rm -rf $LOGS_DIR
mkdir $LOGS_DIR
touch $LOGS_DIR/index.log

cd $PYTHON_LOC || exit
cd $WEEK || exit
echo "Running python scripts from $PYTHON_LOC/$WEEK"

#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
set -x

#pyenv activate search_eng
echo "Creating index settings and mappings"
if [ -f $PRODUCTS_JSON_FILE ]; then
  echo " Product file: $PRODUCTS_JSON_FILE"
  curl -k -X PUT -u admin:admin  "https://$HOST:9200/$INDEX_NAME" -H 'Content-Type: application/json' -d "@$PRODUCTS_JSON_FILE"
  if [ $? -ne 0 ] ; then
    echo "Failed to create index with settings of $PRODUCTS_JSON_FILE"
    exit 2
  fi

  if [ -f index.py ]; then
    echo "Indexing product data in $DATASETS_DIR/product_data/products and writing logs to $LOGS_DIR/index.log"
    nohup python index.py -w $WORKERS -m $MAX_DOCS -b $BATCH_SIZE -s "$DATASETS_DIR/product_data/products" -o "$HOST" -i "$INDEX_NAME" > "$LOGS_DIR/index.log" &
    if [ $? -ne 0 ] ; then
      echo "Failed to index products"
      exit 2
    fi
  fi
fi