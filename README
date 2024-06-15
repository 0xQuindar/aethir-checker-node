Aethier Checker Node - Podman Container
--------------------------------------------

HowTo: 

1. Install podman and podman-compose
`dnf install podman podman-compose -y`

2. Create the persistent storage volume
`podman volume create aethir-checker-storage`

3. Build the container
`podman compose build`

4. Start the Container
`podman compose up -d`

5. Create the burner wallet in the container
~~~
`podman exec -it aethir-checker-node /opt/aethir/AethirCheckerCLI`
[...] 
Please input:y -> Accept ToS
[...] 
Please input:aethir wallet create
[...] 

Optional: Backup the private key
Please input:aethir wallet export
[...] 
~~~

6. Copy public key of the burner wallet and delegate on app.aethir.com

7. Accept the license delegation
~~~
`podman exec -it aethir-checker-node /opt/aethir/AethirCheckerCLI`
[...] 
aethir license list --pending
[...] 
aethir license approve --all
~~~

8. Optional: Create a systemd unit file that takes care of the container start/stop at host reboot
~~~
podman generate systemd --new --restart-policy=on-failure --name aethir-checker-node > /etc/systemd/system/container-aethir-checker-node.service
systemctl daemon-reload
podman stop aethir-checker-node
systemctl enable --now container-aethir-checker-node.service 
~~~
