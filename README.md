Aethier Checker Node - Podman Container
--------------------------------------------

HowTo: 

1. Install dependencies
~~~
dnf install git podman podman-compose -y
~~~

2. Create the persistent storage volume
~~~
podman volume create aethir-checker-storage
~~~

3. Download the files and create the container
~~~
mkdir /opt/aethir
cd /opt/aethir
git clone https://github.com/0xQuindar/aethir-checker-node.git .
podman compose build
~~~

4. Start the new container and check the status
~~~
podman compose up -d
podman ps
~~~

5. Create the burner wallet in the container
~~~
podman exec -it aethir-checker-node /opt/aethir/AethirCheckerCLI
[...] 
Please input:y -> Accept ToS
[...] 
Please input:aethir wallet create
[...] 
~~~

Optional: Backup the private key
~~~
Please input:aethir wallet export
[...] 
~~~
The private key is also in /usr/key/yxpri.pem

6. Copy public key of the burner wallet and delegate on app.aethir.com

7. Wait 1-5 minutes

8. Accept the license delegation
~~~
podman exec -it aethir-checker-node /opt/aethir/AethirCheckerCLI
[...] 
aethir license list --pending
[...] 
aethir license approve --all
~~~

9. Optional: Create a systemd unit file that takes care of the container start/stop at host reboot
~~~
podman generate systemd --new --restart-policy=on-failure --name aethir-checker-node > /etc/systemd/system/container-aethir-checker-node.service
systemctl daemon-reload
podman stop aethir-checker-node
systemctl enable --now container-aethir-checker-node.service 
~~~
