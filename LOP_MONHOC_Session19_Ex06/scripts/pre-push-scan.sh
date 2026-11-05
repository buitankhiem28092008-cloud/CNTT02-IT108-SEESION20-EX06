#!/usr/bin/env bash
# Quét secrets hardcode trước khi push. Chạy: bash scripts/pre-push-scan.sh
# Cài làm hook: cp scripts/pre-push-scan.sh .git/hooks/pre-push && chmod +x .git/hooks/pre-push
set -u
FAIL=0
red(){ printf '\033[31m%s\033[0m\n' "$*"; }
grn(){ printf '\033[32m%s\033[0m\n' "$*"; }

PATTERNS=(
  'AKIA[0-9A-Z]{16}'                                  # AWS Access Key
  'ghp_[A-Za-z0-9]{36}'                               # GitHub PAT
  'sk_live_[0-9A-Za-z]{24,}'                          # Stripe live key
  'AIza[0-9A-Za-z_-]{35}'                             # Google API key
  'xox[baprs]-[0-9A-Za-z-]{10,}'                      # Slack token
  '-----BEGIN (RSA |EC |OPENSSH |DSA )?PRIVATE KEY-----'
  '(postgres(ql)?|mysql|mongodb(\+srv)?)://[^:/ ]+:[^@ ]+@'  # DB URL có mật khẩu
  '(api[_-]?key|secret|passwd|password|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"' ]{8,}["'"'"']'
)
EXCLUDE=(':!*.example' ':!scripts/pre-push-scan.sh' ':!docs/*' ':!*.md')

echo "== [1/4] Quét pattern secrets trong file đang được Git theo dõi =="
for p in "${PATTERNS[@]}"; do
  if git grep -nIE -i -e "$p" -- . "${EXCLUDE[@]}" 2>/dev/null; then FAIL=1; fi
done

echo "== [2/4] File nhạy cảm đã bị track =="
if git ls-files | grep -E '(^|/)\.env($|\.[^/]*$)|\.pem$|\.key$|id_rsa' | grep -vE '\.example$'; then
  red "Có file nhạy cảm đang được track!"; FAIL=1
fi

echo "== [3/4] Kiểm tra .gitignore =="
if [ -f .gitignore ] && grep -qE '^\.env' .gitignore; then :; else red "Thiếu .gitignore hoặc chưa ignore .env"; FAIL=1; fi

echo "== [4/4] Quét toàn bộ lịch sử commit (gitleaks) =="
if command -v gitleaks >/dev/null; then
  gitleaks detect --source . --verbose || FAIL=1
else
  echo "(bỏ qua - chưa cài gitleaks: https://github.com/gitleaks/gitleaks)"
fi

if [ $FAIL -ne 0 ]; then red "❌ PHÁT HIỆN RỦI RO - KHÔNG ĐƯỢC PUSH. Xoá secret, ROTATE key, làm sạch lịch sử."; exit 1; fi
grn "✅ Sạch - có thể push."
