oc exec -ti vault-server-0 -- vault operator init
oc exec -ti vault-server-0 -- vault operator unseal
oc exec -ti vault-server-1 -- vault operator raft join http://vault-server-0.vault-server-internal:8200
oc exec -ti vault-server-1 -- vault operator unseal
oc exec -ti vault-server-2 -- vault operator raft join http://vault-server-0.vault-server-internal:8200
oc exec -ti vault-server-2 -- vault operator unseal


oc exec -ti vault-server-0 -- vault login
oc exec -ti vault-server-0 -- vault operator raft list-peers


vault secrets enable -path=secret/ kv
vault kv put secret/openshiftpullsecret dockerconfigjson='{"auths":{"cloud.openshift.com":{"auth":"3BlbnNoaWZ0LXJl==","email":"example@redhat.com"},"quay.io":{"auth":"ZZMVhJRUJUR1I3WUwxN05VMQ==","email":"example@redhat.com"},"registry.connect.redhat.com":{"auth":"3BlbnNoaWZ0LXJl==","email":"example@redhat.com"},"registry.redhat.io":{"auth":"==","email":"example@redhat.com"}}}'


# Unseal Key 1: +oDOtObq/w3DbzaOZdbD1bOJqE+Dr5ke4ulERAFW5xj2
# Unseal Key 2: IFm1dcwmgOkX1iSbzwgwvOqxEfVkeNLuUDywXsYW+F3J
# Unseal Key 3: 3ASAixl7YK2n6bBgKM3WLxbSRjd4OtBhMkOoCUmvUHVz
# Unseal Key 4: brhNnAMJMfpMxeRsTIOQ6MKrvqsGE2FKG8tFnyknH8S4
# Unseal Key 5: kSn9fENze9hOCsYiKDdXPLINEVo0+IjgZwfwKktWjofl

# Initial Root Token: s.STiv0eifCCcX3OoApPvqHJmF