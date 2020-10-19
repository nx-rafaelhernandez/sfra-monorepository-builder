#!/usr/bin/env bash

# Test empty repository with a readme.md and and a .git folder
# https://github.com/RafaelHernandeznavarro/sfra-custom-boilerplate


# storefront-reference-architecture path
sfraFolder='src/sfra-framework'


# Ask user for project name
while [[ -z "$projectInput" ]]
do
  read -p "Type projectName please: " projectInput
done
projectName=${projectInput//[[:blank:]]/}


# Check if folder exist to avoid overwriting
if [ -e ${projectName} ]
then
  echo "Folder already exist, cannot overwrite!"
  exit
fi


# Create folder using project name
mkdir ${projectName}
cd ${projectName}


# Ask user if wants to clone an existing repo
read -n1 -p "Do you want to clone an existing repository? [y,n] " doit 
case $doit in
  y|Y) 
    echo ''
    while [[ -z "$repository" ]]
    do
      read -p "Type repository url: " repository
    done;
    git clone $repository .
    break;;
  n|N) echo '\nRepository will not be cloned' ;;
  *) echo '\nRepository will not be cloned' ;;
esac


# Clone sfra-webpack-builder repository
echo '#####################################'
echo '## Installing sfra-webpack-builder ##'
echo '#####################################'
read -n1 -p "Do you want to use a token to install sfra-webpack-builder? [y,n] " doit 
case $doit in
  y|Y)
    echo ''
    read -p "Type token: " token
    npm install git+https://${token}:x-oauth-basic@github.com/SalesforceCommerceCloud/sfra-webpack-builder
    break;;
  *) npm install https://github.com/SalesforceCommerceCloud/sfra-webpack-builder.git ;;
esac


# Create necessary files as described on the repository
echo '############################'
echo '## Adding necessary files ##'
echo '############################'

echo ' - sfraBuilderConfig.js'
cat <<EOF >./sfraBuilderConfig.js
'use strict';
const path = require('path');

/**
 * Allows to configure aliases for you require loading
 */
module.exports.aliasConfig = {
  // enter all aliases to configure
  alias: {
    base: path.resolve(
      process.cwd(), // eslint-disable-next-line max-len
      './${sfraFolder}/cartridges/app_storefront_base/cartridge/client/default/'
    )
  }
}

/**
 * Exposes cartridges included in the project
 */
module.exports.cartridges = [
  './${sfraFolder}/cartridges/app_storefront_base'
];
EOF

echo ' - package.json'
cat <<EOF >./package.json
{
  "name": "${projectName}",
  "version": "1.0.0",
  "description": "Auto generated package.json",
  "main": "index.js",
  "scripts": {
    "npmInstall": "node ./node_modules/sfra-webpack-builder/installHandling/install.js",
    "prod": "webpack --config ./node_modules/sfra-webpack-builder/webpack.config.js --env.dev=false",
    "dev": "webpack --config ./node_modules/sfra-webpack-builder/webpack.config.js  --env.dev",
    "watch": "webpack --config ./node_modules/sfra-webpack-builder/webpack.config.js  --env.dev --watch",
    "watch:lint": "webpack --config ./node_modules/sfra-webpack-builder/webpack.config.js  --env.dev --env.useLinter --watch"
  },
  "sfraBuilderConfig": "./sfraBuilderConfig"
}
EOF

echo ' - .gitignore'
cat <<EOF >./.gitignore
.DS_Store
.vscode
.idea
node_modules
dw.json
EOF

# Create vscode configuration
mkdir '.vscode'
echo ' - .vscode/launch.json'
cat <<EOF >./.vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "prophet",
      "request": "launch",
      "name": "Attach to Sandbox"
    }
  ]
}
EOF

echo ' - .vscode/settings.json'
cat <<EOF >./.vscode/settings.json
{
  "editor.insertSpaces": false,
  "editor.tabSize": 4,
  "eslint.enable": true,
  "eslint.run": "onType",
  "eslint.workingDirectories": ["."],
  "stylelint.enable": true,
  "extension.prophet.upload.enabled": true,
  "grunt.autoDetect": "off",
  "files.eol": "\n"
  "search.exclude": {
    "**/node_modules": false
  },
}
EOF


# Create subfolder and clone storefront-reference-architecture repository
echo "#######################################################################"
echo "## Clonnig storefront-reference-architecture into ${sfraFolder} ##"
echo "#######################################################################"
git clone "https://github.com/nexum-AG/storefront-reference-architecture" "${sfraFolder}"


# Edit files from reference architecture repository
echo '##########################################################'
echo '## Editing files from reference architecture repository ##'
echo '##########################################################'
echo ' - bin'
mv "./$sfraFolder/bin/" "./"
echo ' - lint'
mv "./${sfraFolder}/.eslintrc.json" "./"
mv "./${sfraFolder}/.stylelintrc.json" "./"
echo ' - git'
rm -rf "./${sfraFolder}/.git"


# Install all dependencies and run default build
echo '#################################################################'
echo '## Intalling all dependencies and running default build script ##'
echo '#################################################################'
npm run npmInstall
npm run dev


# Create dw.json if desired
read -n1 -p "Do you want to create a dw.json file? [y] " doit 
case $doit in
  y|Y) 
    echo ''; 
    break;;
  *)
    echo ''
    echo '#########################'
    echo '## Finish Successfully ##'
    echo '#########################'
    exit ;;
esac


while [[ -z "$hostname" ]]
do
  read -p "Type hostname: " hostname
done

while [[ -z "$username" ]]
do
  read -p "Type username: " username
done

while [[ -z "$password" ]]
do
  read -p "Type password: " password
done

while [[ -z "$codeversion" ]]
do
  read -p "Type code-version: " codeversion
done

echo '######################'
echo '## Creating dw.json ##'
echo '######################'
echo ' - dw.json'
cat <<EOF >./dw.json
{
  "hostname": "${hostname}",
  "username": "${username}",
  "password": "${password}",
  "code-version": "${codeversion}"
}
EOF


echo '#########################'
echo '## Finish Successfully ##'
echo '#########################'
