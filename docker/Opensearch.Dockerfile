FROM opensearchproject/opensearch:2.6.0

RUN bin/opensearch-plugin install "https://github.com/aiven/prometheus-exporter-plugin-for-opensearch/releases/download/2.6.0.0/prometheus-exporter-2.6.0.0.zip"
