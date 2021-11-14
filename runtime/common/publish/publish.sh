#!/bin/bash

set -e

echo "[Publish] Publishing layer..."

LAYER_NAME="prototype-${CPU}-${PHP_VERSION}-${TYPE}"

VERSION=$(aws lambda publish-layer-version \
   --region ${REGION} \
   --layer-name ${LAYER_NAME} \
   --description "Bref Runtime for ${PHP_VERSION}" \
   --license-info MIT \
   --zip-file fileb:///tmp/bref-zip/${PHP_VERSION}-${TYPE}.zip \
   --compatible-runtimes provided.al2 \
   --output text \
   --query Version)

echo "[Publish] Layer ${VERSION} published! Adding layer permission..."

aws lambda add-layer-version-permission \
    --region ${REGION} \
    --layer-name ${LAYER_NAME} \
    --version-number ${VERSION} \
    --statement-id public \
    --action lambda:GetLayerVersion \
    --principal * \
    --output text \
    --query Statement

echo "[Publish] Layer ${LAYER} added!"

echo "${LAYER_NAME}[${REGION}]=${VERSION}" >> /tmp/bref-zip/output.ini