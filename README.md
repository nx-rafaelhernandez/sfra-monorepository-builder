# sfra-monorepository-builder
Shell script that creates a SFCC project following SFRA architecture and a monorepository approach.

# What is does
- Creates new folder project
- Ask user to clone their repository if exist
- Install sfra-webpack-builder from [official repository](https://github.com/SalesforceCommerceCloud/sfra-webpack-builder)
- Creates necessary files as described on the sfra-webpack-builder repository
- Creates a basic vscode configuration
- Clone the default storefront-reference-architecture from [official repository](https://github.com/SalesforceCommerceCloud/storefront-reference-architecture) into the proper "src" folder
- Edit files from the storefront-reference-architecture repository
- Install all dependencies and run default build
- Create dw.json if desired (It will ask for user inputs)


# How to use it
Copy the build.sh file into the root workspace folder.  
Must no be inside a git repository folder.  
Run
```
sh buider.sh
```
and answer he messages when prompted.
