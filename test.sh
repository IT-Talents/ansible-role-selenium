#!/usr/bin/env bash

set -e

distro="geerlingguy/docker-ubuntu1404-ansible:latest"
init="/sbin/init"
run_opts="--privileged"
container_id=$(mktemp)
idempotence=$(mktemp)

echo "removing all docker containers..."
docker rm -f $(sudo docker ps -a -q)

echo "pulling distro..."
docker pull ${distro}

echo "creating docker image..."
docker run --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro ${run_opts} ${distro} "${init}" > "${container_id}"

echo "using container id: $(cat ${container_id})"

echo "install galaxy deps..."
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml

echo "checking syntax..."
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check

echo "first test run..."
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

echo "second test run for idempotency..."
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

echo "used container id: $(cat ${container_id})"