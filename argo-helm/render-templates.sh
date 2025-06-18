#!/bin/bash
# This script generates the Helm template output with the specified revision

# Default to 'latest' if no revision is provided
REVISION=${1:-latest}

# Run helm template and output to stdout
echo "Generating Helm template output with revision=$REVISION"
helm template argo-workflows ./argo-helm --set workflow.appRevision=$REVISION

# To install the chart with this revision:
echo ""
echo "To install this chart with revision $REVISION, run:"
echo "helm install argo-workflows ./argo-helm --set workflow.appRevision=$REVISION"
