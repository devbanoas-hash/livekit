# 🚀 LiveKit Server - Hướng dẫn Deploy trên Windows

Hướng dẫn đầy đủ để deploy LiveKit server tại `D:\livekit` trên Windows.

---

## 📋 Mục lục

1. [Yêu cầu](#yêu-cầu)
2. [Quick Start](#quick-start)
3. [Cài đặt và Chạy Server](#cài-đặt-và-chạy-server)
4. [Cấu hình API Key/Secret](#cấu-hình-api-keysecret)
5. [Troubleshooting](#troubleshooting)
6. [Production Setup](#production-setup)

---

## Yêu cầu

- **Docker Desktop** đã cài đặt và đang chạy
- **Ports cần mở:**
  - 7880 (TCP) - HTTP/WebSocket
  - 7881 (TCP) - HTTP/WebSocket (TLS)
  - 7882 (UDP) - RTP
  - 50000-50100 (UDP) - TURN/STUN port range

---

## Quick Start

### Bước 1: Download Binary (Không cần Docker)

**Cách tự động (Khuyến nghị):**

```powershell
cd D:\livekit
.\download-binary.ps1
```

Script sẽ tự động download binary mới nhất từ GitHub.

**Hoặc download thủ công:**
1. Vào: https://github.com/livekit/livekit/releases/latest
2. Download file: `livekit-server_X.X.X_windows_amd64.zip`
3. Giải nén `livekit-server.exe` vào `D:\livekit\bin\`

### Bước 2: Start Server

**Cách đơn giản nhất (Binary - Không cần Docker):**

```powershell
cd D:\livekit
.\start-livekit-binary.ps1
```

**Hoặc chạy thủ công:**

```powershell
# Dev mode (không cần config)
.\bin\livekit-server.exe --dev

# Hoặc với config file
.\bin\livekit-server.exe --config livekit.yaml
```

**Các cách khác (nếu có Docker):**

```powershell
# Script tự động thử nhiều phương pháp
.\start-livekit-simple.ps1

# Dev mode với Docker
.\start-livekit-dev.ps1

# Docker-compose
.\start-livekit.ps1
```

### Bước 3: Kiểm tra Server

Mở browser: **http://localhost:7880**

Hoặc chạy:

```powershell
.\check-livekit.ps1
```

### Bước 4: Thông tin kết nối cho App

Sau khi server chạy, set các biến môi trường trong app của bạn:

```powershell
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

### Bước 5: Stop Server

```powershell
# Nếu dùng binary
.\stop-livekit-binary.ps1

# Nếu dùng Docker
.\stop-livekit-dev.ps1
# hoặc
.\stop-livekit.ps1
```

---

## Cài đặt và Chạy Server

### Cách 1: Dùng Binary (Không cần Docker - Khuyến nghị)

#### Bước 1: Download Binary

**Tự động:**

```powershell
.\download-binary.ps1
```

**Thủ công:**
1. Vào: https://github.com/livekit/livekit/releases/latest
2. Tìm file: `livekit-server_X.X.X_windows_amd64.zip`
3. Download và giải nén `livekit-server.exe` vào `D:\livekit\bin\`

#### Bước 2: Chạy Server

**Dùng script:**

```powershell
.\start-livekit-binary.ps1
```

**Hoặc chạy trực tiếp:**

```powershell
# Dev mode (không cần config file)
.\bin\livekit-server.exe --dev

# Hoặc với config file
.\bin\livekit-server.exe --config livekit.yaml
```

**Stop server:**

```powershell
.\stop-livekit-binary.ps1
```

Hoặc nhấn `Ctrl+C` trong terminal đang chạy server.

#### Ưu điểm của Binary Method:
- ✅ Không cần Docker
- ✅ Không cần Go compiler
- ✅ Chạy trực tiếp, không cần container
- ✅ Dễ debug và xem logs
- ✅ Phù hợp cho development

### Cách 2: Dùng Docker

#### Option A: Dev Mode (Đơn giản nhất)

Chạy script:

```powershell
.\start-livekit-dev.ps1
```

Hoặc chạy thủ công:

```powershell
docker run -d `
    --name livekit-server-dev `
    -p 7880:7880 `
    -p 7881:7881 `
    -p 7882:7882/udp `
    -p 50000-50100:50000-50100/udp `
    --restart unless-stopped `
    livekit/livekit-server:latest `
    --dev
```

#### Option B: Dùng docker-compose (Có config file)

Chạy script:

```powershell
.\start-livekit.ps1
```

Hoặc chạy thủ công:

```powershell
docker-compose up -d
```

### Cách 3: Build từ Source (Cần Go 1.23+)

#### Bước 1: Cài đặt Go

Tải và cài Go từ https://go.dev/dl/

#### Bước 2: Cài đặt Mage

```powershell
go install github.com/magefile/mage@latest
```

Đảm bảo `$env:GOPATH\bin` có trong PATH.

#### Bước 3: Bootstrap và Build

```powershell
cd D:\livekit
go mod download
mage
```

Binary sẽ ở `bin\livekit-server.exe`

#### Bước 4: Chạy Server

```powershell
# Dev mode
.\bin\livekit-server.exe --dev

# Hoặc với config file
.\bin\livekit-server.exe --config livekit.yaml
```


---

## Cấu hình API Key/Secret

### API Key/Secret là gì?

API Key và Secret dùng để:
- **Xác thực** khi app kết nối với LiveKit server
- **Ký JWT tokens** để user join vào rooms
- **Bảo mật** server của bạn

### API Key/Secret được config ở đâu?

#### 1. Trong LiveKit Server (`livekit.yaml`)

File `D:\livekit\livekit.yaml` chứa cấu hình keys:

```yaml
keys:
  devkey: secret        # Dev mode (mặc định)
  # hoặc
  YOUR_API_KEY: YOUR_API_SECRET  # Production
```

#### 2. Trong App của bạn (Environment Variables)

App cần set các biến môi trường:

```powershell
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

### Setup cho Development (Dev Mode)

**Không cần làm gì!** Khi chạy `--dev`, LiveKit tự động dùng:
- **API Key:** `devkey`
- **API Secret:** `secret`

Chỉ cần set trong app:

```powershell
$env:LIVEKIT_URL = "ws://localhost:7880"
$env:LIVEKIT_API_KEY = "devkey"
$env:LIVEKIT_API_SECRET = "secret"
```

### Setup cho Production

#### Bước 1: Generate Keys

Chạy script:

```powershell
.\generate-keys.ps1
```

Hoặc chạy thủ công:

```powershell
docker run --rm livekit/livekit-server:latest livekit-server generate-keys
```

Output:
```
API Key: APxxxxxxxxxxxx
API Secret: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Bước 2: Cập nhật `livekit.yaml`

Mở `D:\livekit\livekit.yaml` và sửa:

```yaml
keys:
  APxxxxxxxxxxxx: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Lưu ý:** Có thể có nhiều key/secret pairs:

```yaml
keys:
  devkey: secret                    # Cho dev
  APxxxxxxxxxxxx: secret1           # Cho production app 1
  APyyyyyyyyyyyy: secret2           # Cho production app 2
```

#### Bước 3: Cập nhật Environment Variables trong App

```bash
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=APxxxxxxxxxxxx
LIVEKIT_API_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

#### Bước 4: Restart Server

```powershell
.\stop-livekit.ps1
.\start-livekit.ps1
```

### Ví dụ Setup trong App

#### Node.js/Express

```javascript
const LIVEKIT_URL = process.env.LIVEKIT_URL || 'ws://localhost:7880';
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'devkey';
const LIVEKIT_API_SECRET = process.env.LIVEKIT_API_SECRET || 'secret';

if (!LIVEKIT_URL || !LIVEKIT_API_KEY || !LIVEKIT_API_SECRET) {
  console.error('Missing LIVEKIT_* environment variables');
  process.exit(1);
}
```

#### Python

```python
import os

LIVEKIT_URL = os.getenv('LIVEKIT_URL', 'ws://localhost:7880')
LIVEKIT_API_KEY = os.getenv('LIVEKIT_API_KEY', 'devkey')
LIVEKIT_API_SECRET = os.getenv('LIVEKIT_API_SECRET', 'secret')
```

#### .env File

Tạo file `.env`:

```bash
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

### Lưu ý Bảo mật

⚠️ **Dev Mode (`devkey:secret`):**
- ✅ OK cho development local
- ❌ **KHÔNG dùng cho production!**

✅ **Production Best Practices:**
- Generate key/secret riêng
- Giữ secret an toàn (không commit vào git)
- Dùng environment variables, không hardcode
- Rotate keys định kỳ
- Mỗi app/environment dùng key riêng

---

## Troubleshooting

### Lỗi Docker API Version

**Lỗi:**
```
request returned 500 Internal Server Error for API route and version
```

**Giải pháp:**

1. **Restart Docker Desktop (Thử đầu tiên):**
   - Right-click icon Docker (whale) trong system tray
   - Click "Quit Docker Desktop"
   - Đợi 10-15 giây
   - Mở lại Docker Desktop
   - **QUAN TRỌNG:** Đợi Docker khởi động xong (whale icon ngừng animate, thường 30-60 giây)

2. **Chạy script fix:**
   ```powershell
   .\fix-docker.ps1
   ```

3. **Update Docker Desktop:**
   - Mở Docker Desktop > Settings > General
   - Check for updates
   - Update nếu có

4. **Reset Docker Desktop (Nếu vẫn lỗi):**
   - Settings > Troubleshoot > Reset to factory defaults
   - ⚠️ WARNING: Sẽ xóa tất cả containers/images

5. **Dùng Binary method (Backup plan):**
   - Download từ: https://github.com/livekit/livekit/releases/latest
   - Giải nén vào `D:\livekit\bin\`
   - Chạy: `.\bin\livekit-server.exe --dev`

### Port đã được sử dụng

Nếu port 7880 đã được dùng:

1. Sửa `livekit.yaml`:
   ```yaml
   port: 7881  # Đổi port khác
   ```

2. Cập nhật `docker-compose.yml` mapping port tương ứng

3. Cập nhật `LIVEKIT_URL` trong app: `ws://localhost:7881`

### Firewall chặn UDP ports

Mở Windows Firewall cho ports:
- 7880 (TCP)
- 7881 (TCP)
- 7882 (UDP)
- 50000-50100 (UDP)

### Server không respond

1. **Check logs:**
   ```powershell
   docker logs -f livekit-server-dev
   # hoặc
   docker-compose logs -f livekit
   ```

2. **Check container status:**
   ```powershell
   docker ps | findstr livekit
   # hoặc
   docker-compose ps
   ```

3. **Restart server:**
   ```powershell
   docker restart livekit-server-dev
   # hoặc
   docker-compose restart
   ```

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

## Production Setup

⚠️ **Dev mode (`devkey:secret`) chỉ dùng cho development!**

### Checklist cho Production:

1. ✅ **Generate key/secret mới:**
   ```powershell
   .\generate-keys.ps1
   ```

2. ✅ **Cập nhật `livekit.yaml` với key/secret mới**

3. ✅ **Cấu hình TLS và domain thật:**
   - Setup SSL certificate
   - Cấu hình reverse proxy (nginx/traefik)
   - Update `LIVEKIT_URL` thành `wss://yourdomain.com`

4. ✅ **Setup TURN server** (nếu cần cho NAT/Firewall):
   - Cấu hình trong `livekit.yaml`
   - Hoặc dùng external TURN service

5. ✅ **Cấu hình Redis** (nếu muốn distributed mode):
   - Thêm Redis config vào `livekit.yaml`
   - Deploy Redis server

6. ✅ **Monitoring và Logging:**
   - Setup Prometheus metrics (port 6789)
   - Configure log rotation
   - Setup alerts

7. ✅ **Security:**
   - Rotate keys định kỳ
   - Use strong secrets
   - Enable rate limiting
   - Setup webhooks cho audit

### Cấu hình Production Example

```yaml
# livekit.yaml - Production
port: 7880

rtc:
  port_range_start: 50000
  port_range_end: 50100
  tcp_port: 7881
  use_external_ip: true

keys:
  APxxxxxxxxxxxx: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

logging:
  level: info
  json: true  # JSON logs cho production

# Redis cho distributed mode
redis:
  address: redis.host:6379
  password: your-redis-password

# Prometheus metrics
prometheus_port: 6789
```

---

## Scripts có sẵn

| Script | Mô tả |
|--------|-------|
| **Binary Method (Không cần Docker):** | |
| `download-binary.ps1` | Download LiveKit binary tự động từ GitHub |
| `start-livekit-binary.ps1` | Start server bằng binary (không cần Docker) |
| `stop-livekit-binary.ps1` | Stop server binary |
| **Utilities:** | |
| `check-livekit.ps1` | Check status và health (hỗ trợ cả binary và Docker) |
| `generate-keys.ps1` | Generate API key/secret mới |

---

## Kiểm tra và Test

### 1. Check Server Status

```powershell
.\check-livekit.ps1
```

### 2. Test WebSocket

Mở browser: **http://localhost:7880**

### 3. Test với LiveKit CLI (nếu có)

```powershell
lk token create `
    --api-key devkey --api-secret secret `
    --join --room test --identity user1 `
    --valid-for 24h
```

### 4. Xem Logs

```powershell
# Docker logs
docker logs -f livekit-server-dev

# Docker compose logs
docker-compose logs -f livekit
```

---

## Cấu hình File

### `livekit.yaml`

File config chính cho LiveKit server. Đã được tạo với cấu hình dev mode:
- Port: 7880
- API Key: `devkey`
- API Secret: `secret`
- URL: `ws://localhost:7880`

### `docker-compose.yml`

Docker Compose config để chạy server với Docker.

---

## Tham khảo

- [LiveKit Official Docs](https://docs.livekit.io)
- [Deployment Guide](https://docs.livekit.io/deploy/)
- [Server Configuration](https://docs.livekit.io/self-hosting/config/)
- [Authentication Guide](https://docs.livekit.io/home/get-started/authentication/)
- [LiveKit Releases](https://github.com/livekit/livekit/releases)

---

## Checklist nhanh

- [ ] Docker Desktop đã cài và đang chạy
- [ ] Ports 7880, 7881, 7882, 50000-50100 đã mở
- [ ] Đã chạy `.\start-livekit-simple.ps1`
- [ ] Server respond tại http://localhost:7880
- [ ] Đã set env vars trong app: `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`
- [ ] Đã test kết nối từ app

---

**Chúc bạn deploy thành công! 🎉**

