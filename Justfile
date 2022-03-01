@_list:
  just --list

# Create the shared network
create-network:
  podman network create shared

# Remove the shared network
delete-network:
  podman network rm shared