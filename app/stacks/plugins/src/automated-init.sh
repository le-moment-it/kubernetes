#!/usr/bin/env bash

# Define a function kubectl that imitate the real kubectl command by calling it from a docker container
function kubectld() {
    DOCKER_USER="$(id -u):$(id -g)" \
        docker-compose run --rm kubectld --kubeconfig=/app/.kube/config "$@"
}

kubectld cluster-info
key_nb=3
key_nd=3
nb_replicas=$(kubectld get pods -n hashicorp-vault | grep -cE 'hashicorp-vault-[0-9]+')
kubectld exec -n hashicorp-vault hashicorp-vault-0 -- vault operator init \
    -key-shares=$key_nb \
    -key-threshold=$key_nd \
    -format=json > cluster-keys.json


# We get the m first keys to unseal the vault.
for ((j = 0; j < $nb_replicas; j++)); do
    for ((i = 3; i <= $((2 + $key_nd)); i++)); do
        key=$(sed "${i}q;d" cluster-keys.json | sed 's/ //g' | sed 's/\"//g' | sed 's/,//g')
        number=$(($i - 2))
        echo "Unsealing pod ${j} with key ${number} out of ${key_nd} needed..."
        kubectld exec -n hashicorp-vault hashicorp-vault-$j -- vault operator unseal $key
        sleep 2
    done
done

exit 0