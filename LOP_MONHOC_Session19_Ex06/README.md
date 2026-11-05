# Session19 – Ex06: Ngăn chặn rò rỉ thông tin bí mật trên GitHub

Repo mẫu cho dự án thương mại điện tử trước khi công khai (GitHub Public).

## Cấu trúc
```
.
├── .gitignore                      # chặn .env, key, log, dump...
├── .env.example                    # template chung
├── .env.development.example        # Dev
├── .env.test.example               # Test/CI
├── .env.production.example         # Production (chỉ liệt kê tên biến)
├── PRE_PUSH_CHECKLIST.md           # Checklist 3 bước
├── scripts/pre-push-scan.sh        # Script quét secrets + hook pre-push
├── .github/workflows/secret-scan.yml   # Gitleaks trên CI
└── docs/
    ├── RISK_ASSESSMENT_GITIGNORE.md    # Báo cáo rủi ro khi thiếu .gitignore
    └── 2FA_GUIDE.md                    # Hướng dẫn bật 2FA bắt buộc
```

## Cách dùng nhanh
```bash
cp .env.development.example .env      # điền giá trị thật, KHÔNG commit
bash scripts/pre-push-scan.sh         # quét trước khi push
cp scripts/pre-push-scan.sh .git/hooks/pre-push && chmod +x .git/hooks/pre-push
```

## Quy tắc vàng
1. Secret **không bao giờ** nằm trong code hoặc Git.
2. Lỡ lộ = **rotate key ngay**, rồi mới dọn lịch sử.
3. Mọi thành viên bật **2FA**.
