sh worker_setup.sh
# MASTER ONLY
echo "Initalize the cluster"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16  | grep "kubeadm join" > join_key.txt
echo "Set up local kubeconfig"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "Apply flannel CNI network overlay"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
