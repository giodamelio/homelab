@_list:
  just --list

# Create the shared network
create-network:
  podman network create shared

# Remove the shared network
delete-network:
  podman network rm shared

# Forward port 80 to port 8080
port-forward-create:
  sudo firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080

# Remove the forwarded ports
port-forward-rm:
  sudo firewall-cmd --add-forward-port=port=80:proto=tcp:toport=8080