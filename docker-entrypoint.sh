#! /bin/sh

# check to see if valid openssl pub key has been passed
openssl rsa -noout -text -inform PEM -in /key.pub -pubin &> /dev/null \
 || (echo "Please mount a valid public key file" && exit 1)

# check to see if the minimal env variables have been passed
if [ -z "$AWS_ACCESS_KEY_ID" -o -z "$AWS_SECRET_ACCESS_KEY" -o -z "$BUCKET" ]; then
  echo 'Pass the environment variables for AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and BUCKET.'
  exit 1
fi

for i in `find /backup -mindepth 1 -name "$FILE_REGEX"`; do
  echo "Found file: $i, encrypting and uploading..."
  filename=`basename $i`

  # generate a key we'll use to encrypt
  openssl rand -base64 128 -out /tmp/key.bin

  # encrypt this key with the public key passed to the environment
  openssl rsautl -encrypt -inkey /key.pub -pubin -in /tmp/key.bin -out /tmp/$filename.key.enc

  # now, encrypt the file in question with the randomly generated key
  openssl enc -aes-256-cbc -salt -in $i -pass file:/tmp/key.bin -out /tmp/$filename.enc

  # upload the encrypted version of the randomly generated key and the encrypted file itself.
  aws s3 mv /tmp/$filename.key.enc s3://$BUCKET/
  aws s3 mv /tmp/$filename.enc s3://$BUCKET/
done