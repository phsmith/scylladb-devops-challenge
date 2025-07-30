# DevOps Home Task – Blue/Green Runbook (Starter)

| dir / file | purpose |
|------------|---------|
| `.github/workflows/ci.yml` | Self-test pipeline (kind + Argo) – will go green only after the task is solved. |
| `ansible/project/` | Ansible Runner playbooks folder – contains playbooks to spin up **green** Deployment, patch Service, perform smoke tests, and rollback tasks. |
| `argo/workflow.yaml` | Argo Workflows definition – responsible for running Ansible playbooks and other tasks on the Kubernetes cluster. |
| `k8s/` | Base v1 (blue) Deployment + Service. |
| `kind/` | Kind cluster configurations folder. |
| `scripts/` | Helper scripts folder. |

## Quick start

### Prerequisites

- [Argo CLI](https://argo-workflows.readthedocs.io/en/latest/walk-through/argo-cli/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Setup

Run the following script to:

- Create a Kind cluster named `test`
- Create the k8s namespaces `argo` and `test-app` in the cluster.
- Install Argo Workflows in the k8s cluster.

```bash
bash ./scripts/local-tests-setup.sh
```

### Testing

Run the following script to:

- Deploy the [blue version of the app](./k8s/deployment-v1.yaml) in the k8s cluster.
- Run the [Argo workflow](./argo/workflow.yaml).

```bash
bash ./scripts/local-tests-run.sh
```

Argo Workflow executes Ansible playbooks found in the `ansible/project` directory to perform the following tasks in the k8s cluster:

1. Lint Ansible playbooks and k8s files.
2. Perform smoke tests in the blue deployment by hitting the service url and checking the app name.
3. Create the green deployment.
4. Switch traffic to the green deployment.
5. Perform smoke tests in the green deployment by hitting the service url and checking the app name.
6. Automatically roll back to the blue deployment if any errors occur.

To manually check the application response, run the following commands:

```bash
kubectl -n test-app port-forward service/test-app 8080:80
curl http://localhost:8080
```

### Cleanup

Run the following command to clean up the environment:

```bash
kind delete cluster --name test
```
