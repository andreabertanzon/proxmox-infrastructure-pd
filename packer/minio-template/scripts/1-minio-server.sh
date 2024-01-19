echo "Installing MinIO Server..."
wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20240116160738.0.0_amd64.deb -O minio.deb
sudo dpkg -i minio.deb
echo "MinIO Server installed."