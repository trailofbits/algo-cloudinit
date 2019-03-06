# algo-cloudinit


### How to test

- Lightsail
  - Create instance
    ```bash
    aws lightsail create-instances \
        --instance-names cloud-init-test \
        --availability-zone eu-central-1a \
        --blueprint-id ubuntu_18_04 \
        --bundle-id nano_2_0 \
        --user-data "$(cat cloud-init.sh)" \
        --key-pair-name jack

    aws lightsail get-instance \
        --instance-name cloud-init-test \
        --query 'instance.publicIpAddress'
    ```
  - Delete instance
  ```bash
  aws lightsail delete-instance \
      --instance-name cloud-init-test
  ```
- DigitalOcean
  - Create instance
  ```bash
  doctl compute droplet create \
      --user-data-file cloud-init.sh \
      --image ubuntu-18-04-x64 \
      --size s-1vcpu-1gb \
      --ssh-keys 24144029 \
      --region fra1 \
      --enable-ipv6 \
      --wait \
      -o json \
      cloud-init-test |
  jq .[0].networks.v4[0].ip_address -r
  ```
  - Delete instance
  ```bash
  doctl compute droplet delete cloud-init-test
  ```
