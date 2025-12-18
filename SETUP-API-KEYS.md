# 🔑 Setup API Key và Secret cho LiveKit

## API Key và Secret là gì?

API Key và Secret dùng để:
- **Xác thực** (authentication) khi app của bạn kết nối với LiveKit server
- **Ký JWT tokens** để user join vào rooms
- **Bảo mật** server của bạn

---

## 📍 API Key/Secret được config ở đâu?

### 1. Trong LiveKit Server Config (`livekit.yaml`)

File `livekit.yaml` chứa cấu hình keys:

```yaml
keys:
  devkey: secret        # Dev mode (mặc định)
  # hoặc
  YOUR_API_KEY: YOUR_API_SECRET  # Production
```

**Vị trí file:** `D:\livekit\livekit.yaml`

### 2. Trong App của bạn (Environment Variables)

App của bạn cần set các biến môi trường để kết nối:

```powershell
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

---

## 🚀 Cách Setup

### Option 1: Dùng Dev Mode (Mặc định - Cho development)

**Không cần làm gì!** Khi chạy `--dev`, LiveKit tự động dùng:
- **API Key:** `devkey`
- **API Secret:** `secret`

Chỉ cần set trong app của bạn:

```powershell
$env:LIVEKIT_URL = "ws://localhost:7880"
$env:LIVEKIT_API_KEY = "devkey"
$env:LIVEKIT_API_SECRET = "secret"
```

### Option 2: Generate Key/Secret mới (Cho production)

#### Bước 1: Generate keys

Chạy script:

```powershell
cd D:\livekit
.\generate-keys.ps1
```

Hoặc chạy thủ công:

```powershell
docker run --rm livekit/livekit-server:latest livekit-server generate-keys
```

Output sẽ có dạng:
```
API Key: APxxxxxxxxxxxx
API Secret: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Bước 2: Cập nhật `livekit.yaml`

Mở file `D:\livekit\livekit.yaml` và sửa phần `keys`:

```yaml
keys:
  APxxxxxxxxxxxx: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Lưu ý:** Bạn có thể có nhiều key/secret pairs:

```yaml
keys:
  devkey: secret                    # Cho dev
  APxxxxxxxxxxxx: secret1           # Cho production app 1
  APyyyyyyyyyyyy: secret2           # Cho production app 2
```

#### Bước 3: Cập nhật Environment Variables trong App

Trong app của bạn (ví dụ: `server/index.mjs` hoặc `.env`):

```bash
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=APxxxxxxxxxxxx
LIVEKIT_API_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Bước 4: Restart LiveKit Server

```powershell
# Stop server
.\stop-livekit.ps1
# hoặc
.\stop-livekit-dev.ps1

# Start lại
.\start-livekit.ps1
```

---

## 📝 Ví dụ Setup trong App

### Node.js/Express (`server/index.mjs`)

```javascript
const LIVEKIT_URL = process.env.LIVEKIT_URL || 'ws://localhost:7880';
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'devkey';
const LIVEKIT_API_SECRET = process.env.LIVEKIT_API_SECRET || 'secret';

// Check env vars
if (!LIVEKIT_URL || !LIVEKIT_API_KEY || !LIVEKIT_API_SECRET) {
  console.error('Missing LIVEKIT_URL / LIVEKIT_API_KEY / LIVEKIT_API_SECRET');
  process.exit(1);
}
```

### Python

```python
import os

LIVEKIT_URL = os.getenv('LIVEKIT_URL', 'ws://localhost:7880')
LIVEKIT_API_KEY = os.getenv('LIVEKIT_API_KEY', 'devkey')
LIVEKIT_API_SECRET = os.getenv('LIVEKIT_API_SECRET', 'secret')
```

### .env File

Tạo file `.env` trong project của bạn:

```bash
# LiveKit Configuration
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

---

## 🔍 Kiểm tra Keys đang dùng

### Xem config hiện tại:

```powershell
# Xem file config
Get-Content D:\livekit\livekit.yaml | Select-String -Pattern "keys:" -Context 0,5
```

### Test kết nối:

```powershell
# Check server đang chạy
.\check-livekit.ps1

# Test với curl (nếu có LiveKit CLI)
# lk token create --api-key devkey --api-secret secret --join --room test --identity user1
```

---

## ⚠️ Lưu ý Bảo mật

1. **Dev Mode (`devkey:secret`):**
   - ✅ OK cho development local
   - ❌ KHÔNG dùng cho production!

2. **Production:**
   - ✅ Generate key/secret riêng
   - ✅ Giữ secret an toàn (không commit vào git)
   - ✅ Dùng environment variables, không hardcode
   - ✅ Rotate keys định kỳ

3. **Best Practices:**
   - Mỗi app/environment dùng key riêng
   - Revoke keys cũ khi không dùng
   - Log mọi request để audit

---

## 🆘 Troubleshooting

### Lỗi: "Invalid API key"

**Nguyên nhân:** Key trong app không khớp với key trong `livekit.yaml`

**Giải pháp:**
1. Check key trong `livekit.yaml`
2. Check env vars trong app
3. Restart cả server và app

### Lỗi: "Missing LIVEKIT_API_KEY"

**Nguyên nhân:** App chưa set environment variables

**Giải pháp:**
1. Export env vars trước khi chạy app
2. Hoặc dùng file `.env` và load bằng `dotenv`

### Keys không hoạt động sau khi update

**Giải pháp:**
1. Restart LiveKit server sau khi sửa `livekit.yaml`
2. Đảm bảo format YAML đúng (indentation, không có tab)
3. Check logs: `docker logs livekit-server-dev`

---

## 📚 Tài liệu tham khảo

- [LiveKit Authentication Docs](https://docs.livekit.io/home/get-started/authentication/)
- [Server Configuration](https://docs.livekit.io/self-hosting/config/)
- [JWT Token Guide](https://docs.livekit.io/home/get-started/authentication/#creating-a-token)

