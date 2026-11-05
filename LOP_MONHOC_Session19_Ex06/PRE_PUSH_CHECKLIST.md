# ✅ Pre-push Checklist (GitHub Public)

Chạy từng mục trước khi `git push`. Tất cả phải tick.

## Bước 1 – Kiểm tra mã nguồn
- [ ] Chạy `bash scripts/pre-push-scan.sh` → kết quả ✅
- [ ] Chạy `gitleaks detect --source .` quét **cả lịch sử commit**
- [ ] Tìm thủ công: `git grep -niE "key|secret|token|password|passwd"`
- [ ] Rà file cấu hình: `config/`, `docker-compose*.yml`, `application.yml`, `settings.py`, `*.json`
- [ ] Rà test/fixture/seed data: không chứa email, SĐT, thẻ thanh toán thật của khách
- [ ] Rà log & file dump: không có `*.log`, `*.sql`, `*.dump`
- [ ] Rà commit message, comment, README, Postman collection, ảnh chụp màn hình

## Bước 2 – Loại bỏ thông tin
- [ ] Mọi secret chuyển sang biến môi trường (`process.env.X` / `os.getenv("X")`)
- [ ] Chỉ có `.env*.example` (giá trị rỗng/placeholder) trong repo
- [ ] `.gitignore` có `.env`, `.env.*`, `*.pem`, `*.key` và **đã có từ commit đầu tiên**
- [ ] `git ls-files | grep -E "\.env"` chỉ ra các file `.example`
- [ ] Nếu từng lộ secret: **ROTATE (thu hồi + tạo key mới) trước**, rồi mới làm sạch lịch sử (`git filter-repo` hoặc BFG). Xoá file ở commit mới là KHÔNG đủ.

## Bước 3 – Đẩy mã nguồn
- [ ] Repo mới/clean history (cân nhắc tạo repo mới nếu lịch sử đã từng chứa secret)
- [ ] Bật **Secret scanning + Push protection** (Settings → Code security)
- [ ] Bật **Branch protection** cho `main` (yêu cầu PR + review)
- [ ] Mọi thành viên đã bật **2FA** (xem `docs/2FA_GUIDE.md`)
- [ ] Workflow `secret-scan` chạy xanh trên GitHub Actions
- [ ] Tạo repo **Private** trước → kiểm tra lần cuối → mới chuyển **Public**
