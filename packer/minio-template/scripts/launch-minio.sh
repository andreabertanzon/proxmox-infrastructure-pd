mkdir -p ~/minio/data

sudo docker run \
    -d \
    --restart=always \
    -p 9000:9000 \
    -p 9001:9001 \
    --name minio \
    -v ~/minio/data:/data \
    -e "MINIO_ROOT_USER=abcode" \
    -e "MINIO_ROOT_PASSWORD=password" \
    quay.io/minio/minio@sha256:ea59ffcd90548eb041b4d332f78514af2558e7ffce66785c816d583792de3a8a server /data --console-address ":9001"
