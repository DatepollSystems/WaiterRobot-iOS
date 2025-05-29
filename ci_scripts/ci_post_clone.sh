#!/bin/sh

# Define the credentials
netrc_user=$netrc_user
netrc_password=$netrc_password

# Create or overwrite the .netrc file
cat <<EOF > ~/.netrc
machine maven.pkg.github.com
login $netrc_user
password $netrc_password
EOF

# Set secure permissions
chmod 600 ~/.netrc

echo ".netrc file created for maven.pkg.github.com"
