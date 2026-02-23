#!/bin/bash

# Script to generate 1000 dashboard JSON files for load testing
# Structure: 5 categories with 200 dashboards each

set -e

# Create directory structure
mkdir -p dashboards/{monitoring,applications,infrastructure,business,security}

# Function to generate dashboards for a category
generate_category() {
  category=$1
  metric=$2

  echo "Generating $category dashboards..."

  for i in {1..200}; do
    cat > "dashboards/$category/dashboard-$i.json" <<EOF
{
  "uid": "${category}-dashboard-${i}",
  "title": "$(echo $category | sed 's/.*/\u&/') Dashboard ${i}",
  "tags": ["${category}", "generated", "load-test"],
  "timezone": "browser",
  "schemaVersion": 38,
  "version": 1,
  "refresh": "30s",
  "panels": [
    {
      "id": 1,
      "title": "Panel ${i}",
      "type": "graph",
      "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0},
      "targets": [
        {
          "expr": "rate(${metric}_total[5m])",
          "refId": "A"
        }
      ]
    }
  ]
}
EOF
  done
}

# Generate 200 dashboards per category (1000 total)
generate_category "monitoring" "cpu_usage"
generate_category "applications" "request_rate"
generate_category "infrastructure" "server_health"
generate_category "business" "revenue"
generate_category "security" "auth_failures"

echo ""
echo "Generated 1,000 dashboards!"
echo "Structure:"
echo "  - dashboards/monitoring: 200 dashboards"
echo "  - dashboards/applications: 200 dashboards"
echo "  - dashboards/infrastructure: 200 dashboards"
echo "  - dashboards/business: 200 dashboards"
echo "  - dashboards/security: 200 dashboards"
