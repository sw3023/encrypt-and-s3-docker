# encrypt-and-s3-docker 
Signature Version 4 enabled for AWS. 

This is a [docker](https://www.docker.io) image that uses a provided openssl public key to encrypt files (via envelope encryption of an intermediary passphraes) and upload to s3 -- allowing encrypted backups on s3 that amazon employees have no access to (while operating on a shoe-string, Amazon KMS-less budget), as well as never having to provide the secret to your docker environment.

## Usage

```bash
docker run --rm --name encrypt-and-s3 \
  -e AWS_ACCESS_KEY_ID="yourawsaccesskey" \
  -e AWS_SECRET_ACCESS_KEY="yourawssecretkey" \
  -e BUCKET=someexistingbucket \
  -e AWS_DEFAULT_REGION=bucketregion \
  -v /path/to/your/pub/key.pem:/key.pub \
  -v /directory/to/backup/*:/backup:ro \
  centerx/encrypt-and-s3-docker-master
```

  * `FILE_REGEX`, defaults=`'*'`, can be passed to replace the name param used in `find`
  * `BUCKET`, passing a subdir here would work as well (just be sure not to add a trailing slash). Example: `-e BUCKET='my-unique-bucket/my-subdirectory-for-backups'`
  * `AWS_DEFAULT_REGION`, passing the region where the bucket is located. Example: `-e AWS_DEFAULT_REGION='us-east-2'`
  * A good [blog post](https://rietta.com/blog/2012/01/27/openssl-generating-rsa-key-from-command/) on creating an openssl keypair and exporting the public key for use with this tool.
  * `/backup` dir can be passed as read-only, encrypted copies will be stored temporarily in the container and cleaned up upon upload.

# License/Author

Author: Shuhao Wu
Author: Steve Nolen

License: Apache v2 (see `LICENSE` file in this repository for details)
