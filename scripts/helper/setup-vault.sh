oc exec -ti vault-server-0 -- vault operator init
oc exec -ti vault-server-0 -- vault operator unseal
oc exec -ti vault-server-1 -- vault operator raft join http://vault-server-0.vault-server-internal:8200
oc exec -ti vault-server-1 -- vault operator unseal
oc exec -ti vault-server-2 -- vault operator raft join http://vault-server-0.vault-server-internal:8200
oc exec -ti vault-server-2 -- vault operator unseal

oc exec -ti vault-server-0 -- vault login
oc exec -ti vault-server-0 -- vault operator raft list-peers

oc exec -ti vault-server-0 -- vault secrets enable -path=secret/ kv
oc exec -ti vault-server-0 -- vault kv put secret/openshiftpullsecret dockerconfigjson='{"auths":{"cloud.openshift.com":{"auth":"3BlbnNoaWZ0LXJl==","email":"example@redhat.com"},"quay.io":{"auth":"ZZMVhJRUJUR1I3WUwxN05VMQ==","email":"example@redhat.com"},"registry.connect.redhat.com":{"auth":"3BlbnNoaWZ0LXJl==","email":"example@redhat.com"},"registry.redhat.io":{"auth":"==","email":"example@redhat.com"}}}'

oc create secret generic vault-token --from-literal=token="s.68yvrsufCKn5gO7kIxoJFLl3" -n vault 

# Unseal Key 1: vDOUH+64ClDDMoUETLOwM0t25jlsSlF4Gp9Uo50VazIY
# Unseal Key 2: BTVywAKZB3+cBFaCiaD6ETGo8OqCD3mYo7nDBDEtgocW
# Unseal Key 3: q5AyTKv7+Lm4SSAz2vguZxD+bSy+YD85CPcLwFASGJoc
# Unseal Key 4: 4yXKKTYPiigjnf5QAoEnutkqOlEDeTfc7E3rtX/8EZ8f
# Unseal Key 5: dd2q6sLTKCvrupmAiySWsjCKmackWZeQgrKy1X0rkV13

# Initial Root Token: s.68yvrsufCKn5gO7kIxoJFLl3