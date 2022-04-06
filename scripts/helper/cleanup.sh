oc api-resources --verbs=list --namespaced -o name | xargs -n 1 oc get --show-kind --ignore-not-found -n   openshift-gitops
oc delete application --all -n openshift-gitops
oc get application --no-headers -n openshift-gitops  -o name | xargs -n 1 oc patch -n openshift-gitops -p '{"metadata":{"finalizers":null}}' --type=merge
oc patch argocd openshift-gitops -n openshift-gitops -p '{"metadata":{"finalizers":null}}' --type=merge