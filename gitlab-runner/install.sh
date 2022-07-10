GITLAB_RUNNER_INSTANCE_URL="https://gitlab.com/"
GITLAB_RUNNER_REGISTRATION_TOKEN="///"
GITLAB_RUNNER_NAME="///"


# Install docker
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG
docker version

# Install docker-compose
sudo apt-get update
sudo apt-get install docker-compose-plugin
docker compose version

# Install and Register gitlab-runner
docker run -d --name $GITLAB_RUNNER_NAME --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:alpine
docker run -d --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner:alpine register --registration-token="$GITLAB_RUNNER_REGISTRATION_TOKEN" --non-interactive --url "$GITLAB_RUNNER_INSTANCE_URL" --executor docker --docker-image alpine --description "runner-${USER}" --run-untagged --locked=false --docker-privileged

# Get gitlab-runner version and list
docker exec -it $GITLAB_RUNNER_NAME sh -c 'gitlab-runner --version && gitlab-runner list; exit $?'
