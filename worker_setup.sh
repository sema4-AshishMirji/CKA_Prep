#!/bin/sh
sh alias_setup.sh

echo "Download docker gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo "Add the Docker repository"
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
echo "Add the Kubernetes repository"
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
echo "apt-get update"
sudo apt-get update -y
process_id=$!
wait $process_id
sudo apt-get upgrade -y
process_id=$!
wait $process_id
echo "install docker, kublet, kubeadm, kubectl"
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.13.5-00 kubeadm=1.13.5-00 kubectl=1.13.5-00
process_id=$!
wait $process_id
echo "Hold them at the current version"
sudo apt-mark hold docker-ce kubelet kubeadm kubectl
echo "Add the iptables rule to sysctl.conf"
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
echo "Enable ip tables immediately"
sudo sysctl -p
sh shell_setup.sh
echo "##############------##############"
exit
echo "Enter worker join command: "
