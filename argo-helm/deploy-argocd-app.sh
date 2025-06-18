#!/bin/bash
# This script deploys the ArgoCD application

# First, generate and save the ArgoCD application manifest
helm template argo-workflows ./argo-helm -s templates/workflow-app.yaml > workflow-app.yaml

# Apply the ArgoCD application manifest
echo "Deploying ArgoCD application"
kubectl apply -f workflow-app.yaml

# Check that the application was created
echo ""
echo "ArgoCD application status:"
kubectl get applications -n argocd workflow-app
