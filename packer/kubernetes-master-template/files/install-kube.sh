#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Step 1: Add Kubernetes Signing Key
echo "Adding Kubernetes signing key..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Step 2: Add Kubernetes Software Repository
echo "Adding Kubernetes software repository..."
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list

# Step 3: Update Packages
echo "Updating packages..."
apt update

# Step 4: Install Kubernetes Tools
echo "Installing Kubernetes tools..."
apt install kubeadm kubelet kubectl -y

# Step 5: Hold Kubernetes Packages at Current Version
echo "Holding Kubernetes packages at their current version..."
apt-mark hold kubeadm kubelet kubectl

# Step 6: Disable Swap
echo "Disabling swap..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Step 7: Configure Kernel Modules and Sysctl
echo "Configuring kernel modules and sysctl..."
echo "overlay" | tee /etc/modules-load.d/containerd.conf
echo "br_netfilter" | tee -a /etc/modules-load.d/containerd.conf

modprobe overlay
modprobe br_netfilter

# Sysctl settings for Kubernetes networking
echo "net.bridge.bridge-nf-call-iptables=1" | tee /etc/sysctl.d/kubernetes.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" | tee -a /etc/sysctl.d/kubernetes.conf
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.d/kubernetes.conf

# Apply sysctl parameters
sysctl --system

# Step 8: Configure Kubelet with Systemd Cgroup Driver
echo "Configuring kubelet with systemd cgroup driver..."
echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" | tee /etc/default/kubelet

# Reload config and restart kubelet
systemctl daemon-reload && systemctl restart kubelet

# Step 9: Configure Docker Daemon
echo "Configuring Docker daemon..."
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Reload Docker configuration and restart
systemctl daemon-reload && systemctl restart docker

# Step 10: Update kubelet to not fail on swap
echo "Updating kubelet service configuration..."
echo "Environment='KUBELET_EXTRA_ARGS=--fail-swap-on=false'" | tee -a /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload && systemctl restart kubelet

echo "Kubernetes setup script completed."
