#!/usr/bin/env bash
# =============================================================
# Generate RSA Key Pair for Snowflake Terraform Authentication
# =============================================================
# Usage: ./scripts/generate-keys.sh
# Keys are stored in ~/.ssh/

set -euo pipefail

KEY_DIR="$HOME/.ssh"
PRIVATE_KEY="$KEY_DIR/snowflake_tf_snow_key.p8"
PUBLIC_KEY="$KEY_DIR/snowflake_tf_snow_key.pub"

mkdir -p "$KEY_DIR"

if [[ -f "$PRIVATE_KEY" ]]; then
    echo "WARNING: Private key already exists at $PRIVATE_KEY"
    read -p "Overwrite? (y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo "Generating 2048-bit RSA key pair..."
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out "$PRIVATE_KEY" -nocrypt
openssl rsa -in "$PRIVATE_KEY" -pubout -out "$PUBLIC_KEY"

chmod 600 "$PRIVATE_KEY"
chmod 644 "$PUBLIC_KEY"

echo ""
echo "Keys generated successfully:"
echo "  Private key: $PRIVATE_KEY"
echo "  Public key:  $PUBLIC_KEY"
echo ""
echo "Next step: Copy the public key below into the Snowflake SQL script"
echo "============================================================="
cat "$PUBLIC_KEY"
echo "============================================================="
