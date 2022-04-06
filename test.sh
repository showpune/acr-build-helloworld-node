#!/usr/bin/env bash

az login
az account set --subscription=d51e3ffe-6b84-49cd-b426-0dc4ec660356
export ACR_NAME='serviceacr'
az acr build --registry $ACR_NAME \
            --resource-group azdmss-dogfood \
            --image showpune/baseimages/node:15-alpine \
            --file Dockerfile-base . 

az acr task create \
    --registry $ACR_NAME \
    --name baseexample1 \
    --image helloworld:{{.Run.ID}} \
    --arg REGISTRY_NAME=$ACR_NAME.azurecr.io \
    --resource-group azdmss-dogfood \
    --context https://github.com/showpune/acr-build-helloworld-node.git#main \
    --file Dockerfile-app \
    --git-access-token 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

az acr task run --registry $ACR_NAME \
                --resource-group azdmss-dogfood \
                --name baseexample1