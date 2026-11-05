# Báo cáo đánh giá rủi ro khi thiếu `.gitignore`

## 1. Tóm tắt
Thiếu `.gitignore` khiến `git add .` đưa **mọi file** vào lịch sử Git, gồm `.env`, khoá riêng tư, log, DB dump. Với repo **Public**, các thông tin này lộ ra toàn Internet. Bot quét GitHub tự động và có thể khai thác key chỉ sau **vài phút**.

## 2. Ma trận rủi ro

| # | Tài sản bị lộ | Kịch bản tấn công | Khả năng | Tác động | Mức |
|---|---|---|---|---|---|
| 1 | `.env` (DB password, JWT secret) | Truy cập DB, đọc/xoá dữ liệu khách hàng; giả mạo token đăng nhập | Cao | Rất cao | **Nghiêm trọng** |
| 2 | API key thanh toán / cloud (AWS, Stripe) | Tạo tài nguyên đào coin, lạm dụng cổng thanh toán, hoá đơn hàng nghìn USD | Cao | Rất cao | **Nghiêm trọng** |
| 3 | Private key `*.pem`, SSH key | Truy cập server, cài mã độc | Trung bình | Rất cao | **Nghiêm trọng** |
| 4 | DB dump / log chứa dữ liệu cá nhân | Rò rỉ PII (email, SĐT, địa chỉ) → vi phạm quy định bảo vệ dữ liệu cá nhân, mất uy tín | Trung bình | Cao | **Cao** |
| 5 | `node_modules/`, `build/` | Repo phình to, lộ phiên bản thư viện (dễ dò lỗ hổng), xung đột merge | Cao | Thấp | Trung bình |
| 6 | File IDE/OS (`.idea`, `.DS_Store`) | Lộ đường dẫn máy cá nhân, cấu hình nội bộ | Cao | Thấp | Thấp |

## 3. Vì sao xoá file ở commit sau vẫn không an toàn?
- Git lưu **toàn bộ lịch sử**; commit cũ vẫn chứa secret (`git log -p`, `git show`).
- Repo có thể đã bị fork/clone/cache trước khi bạn kịp xoá.
- Bot quét sự kiện push theo thời gian thực.

## 4. Hậu quả với dự án thương mại điện tử
- Thiệt hại tài chính (lạm dụng API thanh toán, cloud).
- Rò rỉ dữ liệu khách hàng → trách nhiệm pháp lý.
- Mất niềm tin của đối tác đang kiểm tra mã nguồn.
- Chi phí khắc phục: rotate toàn bộ key, làm sạch lịch sử, xử lý sự cố.

## 5. Biện pháp giảm thiểu
1. Tạo `.gitignore` **trước commit đầu tiên** (file mẫu trong repo này).
2. Dùng `.env.example` thay vì `.env` thật.
3. Pre-push script + gitleaks + GitHub Push Protection.
4. Secret Manager cho môi trường Production.
5. Nếu đã lộ: **rotate key ngay** → `git filter-repo`/BFG → force push → yêu cầu mọi người re-clone.
6. Bật 2FA bắt buộc, branch protection, review PR.

## 6. Kết luận
Rủi ro khi thiếu `.gitignore` là **Nghiêm trọng**: chi phí phòng ngừa gần như bằng 0, chi phí khắc phục rất lớn.
