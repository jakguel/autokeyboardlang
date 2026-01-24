#!/bin/bash

# Script to update SHA256 checksums in the autokbisw formula

VERSION="2.1.0"
GITHUB_REPO="charliejones1/autokbisw"

echo "Downloading SHA256SUMS file..."
curl -L "https://github.com/${GITHUB_REPO}/releases/download/v${VERSION}/SHA256SUMS" -o /tmp/SHA256SUMS

if [ ! -f /tmp/SHA256SUMS ]; then
    echo "Error: Failed to download SHA256SUMS file"
    exit 1
fi

echo "Extracting checksums..."
SEQUOIA_SHA=$(grep "arm64_sequoia" /tmp/SHA256SUMS | awk '{print $1}')
TAHOE_SHA=$(grep "arm64_tahoe" /tmp/SHA256SUMS | awk '{print $1}')

if [ -z "$SEQUOIA_SHA" ] || [ -z "$TAHOE_SHA" ]; then
    echo "Error: Could not extract checksums"
    echo "SHA256SUMS content:"
    cat /tmp/SHA256SUMS
    exit 1
fi

echo "Sequoia SHA256: $SEQUOIA_SHA"
echo "Tahoe SHA256: $TAHOE_SHA"

echo "Updating Formula/autokbisw.rb..."
sed -i.bak "s/SEQUOIA_SHA256_HERE/$SEQUOIA_SHA/" Formula/autokbisw.rb
sed -i.bak "s/TAHOE_SHA256_HERE/$TAHOE_SHA/" Formula/autokbisw.rb

echo "Done! Formula updated successfully."
echo ""
echo "Next steps:"
echo "1. Review the changes: git diff Formula/autokbisw.rb"
echo "2. Commit: git add Formula/autokbisw.rb && git commit -m 'Update formula checksums for v${VERSION}'"
echo "3. Push: git push origin master"
echo "4. Install with: brew tap charliejones1/autokbisw && brew install autokbisw"

rm /tmp/SHA256SUMS
