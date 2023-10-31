Executable command on ubuntu - 

sudo docker run -d -e AZP_URL="https://dev.azure.com/ret/" -e AZP_TOKEN="" -e AZP_POOL="Docker-agent-pool" -e AZP_AGENT_NAME="Docker-Agent-1" --name "azp-agent-linux-1" -v /var/run/docker.sock:/var/run/docker.sock azp-agent:linux
