# Argo Workflows Helm Chart

This Helm chart deploys Argo Workflows resources, including:

- Workflow Template for building and pushing Docker images
- Workflow resource that is triggered by new revisions
- ArgoCD Application that manages the deployment

## Prerequisites

- Kubernetes cluster with Argo Workflows installed
- ArgoCD installed (if using the ArgoCD application)
- Service account `argo-workflow-sa` with appropriate permissions
- Cluster-scoped templates: `git-clone-template` and `docker-build-and-push-template`

## Installation

### With Helm

```bash
# Install the chart with default values
helm install argo-workflows ./argo-helm

# Install with custom values file
helm install argo-workflows ./argo-helm -f custom-values.yaml

# Override specific values
helm install argo-workflows ./argo-helm --set workflow.appRevision=v1.0.0
```

### With ArgoCD

1. Apply the ArgoCD application manifest:

```bash
kubectl apply -f argo-helm/templates/workflow-app.yaml
```

2. ArgoCD will automatically manage the workflow template and create workflows based on new revisions.

## Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `application.name` | Name of the ArgoCD application | `workflow-app` |
| `application.namespace` | Namespace for the ArgoCD application | `argocd` |
| `application.project` | ArgoCD project to use | `default` |
| `application.repoURL` | Git repository URL | `https://github.com/segfault16/python-multistage-docker` |
| `application.targetRevision` | Git revision to use | `HEAD` |
| `workflowTemplate.name` | Name of the workflow template | `python-multistage-docker` |
| `workflowTemplate.serviceAccountName` | Service account for workflows | `argo-workflow-sa` |
| `workflowTemplate.volumeClaimSize` | Size of the volume claim | `64Mi` |
| `workflowTemplate.repo.url` | Repository URL to clone | `https://github.com/segfault16/python-multistage-docker` |
| `workflowTemplate.repo.branch` | Branch to clone | `master` |
| `workflowTemplate.images.prefix` | Docker image registry prefix | `494150080395.dkr.ecr.eu-west-1.amazonaws.com` |
| `workflowTemplate.images.repository` | Docker image repository | `mega-repository` |
| `workflowTemplate.images.cacheTag` | Docker image cache tag | `mega-repository-cache` |
| `workflow.generateName` | Prefix for generated workflow names | `python-multistage-docker-` |
| `workflow.serviceAccountName` | Service account for workflow | `argo-workflow-sa` |
| `workflow.appRevision` | Application revision for workflow (set by ArgoCD) | `latest` |

## Usage with ArgoCD

This chart is designed to work with ArgoCD. When a new revision is deployed through ArgoCD, the `ARGOCD_APP_REVISION` environment variable is passed to the Helm chart, which creates a new workflow with the appropriate revision.

The ArgoCD application is configured to:

1. Watch the Git repository
2. Deploy the Helm chart with the current revision as a parameter
3. Create a new workflow when a new revision is detected
