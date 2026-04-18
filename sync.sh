#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/research-vault
git add .
git commit -m "vault sync $(date '+%Y-%m-%d %H:%M')" 2>/dev/null
git pull origin main --rebase
git push origin main
echo "Vault synced"
