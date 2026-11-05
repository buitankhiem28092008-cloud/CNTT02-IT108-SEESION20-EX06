# Hướng dẫn bật & bắt buộc 2FA cho repository

## A. Từng thành viên tự bật 2FA
1. GitHub → avatar → **Settings** → **Password and authentication**.
2. **Enable two-factor authentication**.
3. Chọn **Authenticator app** (Google Authenticator, Authy, 1Password…) hoặc **Security key / Passkey**. Hạn chế SMS.
4. Quét QR, nhập mã 6 số để xác nhận.
5. **Tải và lưu recovery codes** ở nơi an toàn (password manager), không lưu trong repo.
6. Thêm ít nhất 2 phương thức dự phòng (ví dụ app + passkey).
7. Với `git push` qua HTTPS: dùng **Personal Access Token (fine-grained)** hoặc SSH key thay cho mật khẩu.

## B. Admin bắt buộc 2FA cho cả team
1. Áp dụng cho repo thuộc **Organization** (không áp dụng cho tài khoản cá nhân).
2. Org → **Settings** → **Authentication security**.
3. Tick **Require two-factor authentication for everyone in your organization** → Save.
4. Thành viên chưa bật 2FA sẽ bị gỡ khỏi org (có thể khôi phục sau khi họ bật 2FA).
5. Kiểm tra: Org → **People** → lọc **2FA: Disabled** → nhắc nhở.

## C. Bảo vệ bổ sung (Settings của repo)
- **Code security** → bật *Secret scanning* + *Push protection*.
- **Branches** → rule cho `main`: Require PR, Require approvals, Require status checks (`secret-scan`).
- Cấp quyền tối thiểu (Read/Triage/Write); hạn chế Admin.
- Rà soát định kỳ: Deploy keys, PAT, GitHub Apps, OAuth apps.

## D. Ảnh minh chứng khi nộp
- [ ] Trang *Authentication security* đã bật bắt buộc 2FA
- [ ] Danh sách People không còn ai 2FA Disabled
- [ ] Secret scanning & Push protection = Enabled
- [ ] Branch protection rule của `main`
