#!/usr/bin/env bash

distro="geerlingguy/docker-centos7-ansible:latest"
init="/usr/lib/systemd/systemd"
run_opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
container_id=$(mktemp)
idempotence=$(mktemp)

docker pull ${distro}
docker run --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro ${run_opts} ${distro} "${init}" > "${container_id}"
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml
#docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --syntax-check
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml

cat ${container_id}

#sudo docker exec "$(cat ${container_id})" ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml | tee -a ${idempotence}
#tail ${idempotence} grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
