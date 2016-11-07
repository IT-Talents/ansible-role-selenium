#!/usr/bin/env bash

set -e

distro="geerlingguy/docker-ubuntu1604-ansible:latest"
init="/lib/systemd/systemd"
run_opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
container_id=$(mktemp)
idempotence=$(mktemp)

docker rm -f $(sudo docker ps -a -q)
docker pull ${distro}

docker run --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro ${run_opts} ${distro} "${init}" > "${container_id}"

docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml

docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check

docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

cat ${container_id}